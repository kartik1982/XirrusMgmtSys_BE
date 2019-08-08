$:.unshift File.dirname(__FILE__)
require 'rest-client'
require 'json'
require 'open-uri'
require 'net/http'
require 'net/smtp'
require 'net/ssh'
require 'net/telnet'
require 'socket'
require 'timeout'

require_relative '../array/array_telnet_session.rb'
require_relative '../array/array_api_client.rb'

module EXECUTOR

  def self.array(args = {})
    EXECUTOR::Array.new(args)
  end

  def self.array_api_client(args = {})
    EXECUTOR::ArrayApiClient.new(args)
  end

  def self.array_from_fixture(_serial)
    EXECUTOR::Array.new(json_file: "#{XMS.fixtures_root}/json/#{_serial}.json")
  end

  class Array

    attr_accessor :cu,:cp, :country, :tags, :serial, :manufacturer, :hostname, :id, :tenant_id, :profileId, :profileName, :gateway,  :netmask, :username, :password, :ip, :model, :aos, :token, :iaps, :profile, :license, :iapmac, :mac, :location
    CELL_SIZE_PAIRINGS = [
      {size: "Small", tx: 5, rx: -82},
      {size: "Medium", tx: 12, rx: -86},
      {size: "Large", tx: 19, rx: -89},
      {size: "Max", tx: 20, rx: -90}
    ]

  	  def initialize(args = {})
        @cu = args[:cu]
        @cp = args[:cp]
        @username = args[:username] || "admin"
        @password = args[:password] || "admin"
        @api_version = args[:api_version] || "3"
        if args[:json_file]
          array_data = JSON.parse(File.read(args[:json_file]))

          @gateway = array_data['actualGateway']
          @netmask = array_data['actualNetmask']
          @location = array_data['location']

          @ip = array_data['actualIpAddress']
          @hostname = array_data['hostName']
          @aos = array_data['licensedAosVersion']
          @model = array_data['arrayModel']
          @license = array_data['licenseKey']
          @iapmac = array_data['baseIapMacAddress']
          @mac = array_data['baseMacAddress']
          @country = array_data['country']
          @tags = array_data['tags']

          @manufacturer = array_data['manufacturer']
          @serial = array_data['serialNumber']
        else

          @id = args[:id]
          @profileName = args[:profileName]
          @gateway = args[:gateway] || GATEWAY
          @netmask = args[:netmask] || NETMASK
          @location = args[:location] || "SQA XMS"
          @tenant_id = args[:tenant_id]
          @profileId = args[:profileId]
          @ip = args[:ip]
          if (!@ip.nil? && @ip.length > 3)

          else
            @ip = "#{TEST_SUBNET}#{@ip}"
          end
          @profile = args[:profile]
          @token = args[:token]
          @initial_args = args
          @api_version = args[:api_version] || "3"
          @aos = args[:aos] || "7.1.0"
          @model = args[:model] || "XR520"
          @license = args[:license]
          @iapmac = args[:iapmac]
          @mac = args[:mac]
          @country = args[:country] || "US"
          @tags = args[:tags] || []
          @iaps = []
          @manufacturer = args[:manufacturer]
          @serial = args[:serial]
        end
  	  end

      def self.cell_size_pair(size)
         CELL_SIZE_PAIRINGS.select{|csp| csp[:size].downcase == size.downcase }.first
      end

      def telnet_session(args = {})
        EXECUTOR::ArrayTelnetSession.new({ip: @ip, username: @username, password: @password}.merge(args))
      end

      def ssh_commands(commands = ['configure','no more','management','show','exit','exit','exit'])
        res = []
        Net::SSH.start(@ip, @username, :password => @password, :auth_methods => ["password"]) do |session|

          session.open_channel do |channel|
            puts "SSH channel successfully opened ....."

            channel.request_pty do |ch, success|
              raise "Error requesting pty" unless success

              ch.send_channel_request("shell") do |ch, success|
                raise "Error opening shell" unless success
              end
            end

            channel.on_data do |ch, data|

             # puts data.to_json
              STDOUT.print data
              res << data

            end

            channel.on_extended_data do |ch, type, data|
              STDOUT.print "Error: #{data}\n"
            end

            for i in 0..commands.length-1 do

              channel.send_data( "#{commands[i]}\n")

            end


          end
        end #Net::SSH
        #puts "SSH COMMANDS RES: #{res}"
        res
      end # ssh_commands


      def reboot
        ssh_commands(['configure','reboot','yes','yes'])
      end



      def ssh_cmds2(commands = ['management','show'])
        res = nil
         Net::SSH.start(@ip, @username, :password => @password, :auth_methods => ["password"]) do |ssh|
           res =  ssh.exec!("configure\n")

            ssh.close
         end
         res
      end


      def clear_license
        ssh_commands(['configure','management','clear license','exit','exit','exit'])
      end

      def get_ap_token
        res = RestClient.post("http://#{@ip}/oauth/authorize",
         {
            grant_type: "password",
            client_id: @username,
            username: @username,
            password: @password

         })
        token = JSON.parse(res)["access_token"]
      end

      def api_client
        EXECUTOR::ArrayApiClient.new({ip: @ip, token: get_ap_token})
      end

      def ng_format
        [{serialNumber: self.serial, arrayModel: self.model,
      country: @country, licensedAosVersion: @aos, aosVersion: @aos, licenseKey: self.license, ipAddress: self.ip,
       actualIpAddress: self.ip, actualNetmask: self.netmask, actualGateway: self.gateway,
      hostName: self.hostname, baseMacAddress: self.mac, baseIapMacAddress: self.iapmac }] #manufacturer: self.manufacturer,
      end


      def get_ready_for_cloud_test(args = {})
        if args[:swap_env]
          ssh_commands(['configure','activation stop','no more','management','cloud off', "cloud server stomp-#{args[:env]}.cloud.xirrus.com","save","exit","boot","set bootargs console=ttyS0,115200n8 root=/dev/ram rw quiet ACTIVATION_URL=https://activate-#{args[:env]}.cloud.xirrus.com CLIOPTS=b","save","exit","exit","exit"])
          sleep 30
        end
        ssh_commands(['configure','no more', 'management','telnet enable','telnet timeout 1800','cloud on', 'save', 'activation start', 'exit','exit','exit'])
      end


      def connect
        ssh_commands(['configure','no more', 'management','cloud on','save','activation start','exit','exit','exit'])
      end


      def disconnect
        ssh_commands(['configure','no more', 'management','cloud off','save','activation stop','exit','exit','exit'])
      end

      def all_down
        ssh_commands(['configure', 'no more' , 'interface iap','all-down','save','all-down','exit','exit','exit'])
      end

      def reset(preserve_ip = true)
        if preserve_ip
          ssh_commands(['configure','reset preserve-ip-settings','yes'])
        else
          ssh_commands(['configure','yes'])
        end
      end

      def up?(_ping_count = 4, max_attempts = 30, wait_between = 10)
        ping_count = _ping_count
        attempts = 0
        ping_success = false
        while(ping_success == false && max_attempts < 30)
          attempts += 1
          result = `ping -q -c #{_ping_count} #{ip}`

          puts result
          if ( result.include?("#{_ping_count} packets transmitted") && result.include?("0% packet loss") )
            ping_success = true
          end
          sleep wait_between
        end
        ping_success
      end

  end # Array





end # EXECUTOR