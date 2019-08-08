$:.unshift File.dirname(__FILE__)
require 'rest-client'
require 'json'
require 'open-uri'
require 'net/http'
require 'net/smtp'

module XMS
  
  def self.array_api_client(args = {})
    XMS::ArrayApiClient.new(args)
  end
  
  class ArrayApiClient

    attr_reader :ip

  	  def initialize(args = {})
        @ip = args[:ip]
        @token = args[:token]
        @initial_args = args 
        @api_version = args[:api_version] || "3"
  	  end

     # Makes a request to the Array Api using the specified endpoint
     #     
     # == Parameters:
     # endpoint:
     #   A String with the path from the api root to the resource you want
     #   
     # == Returns:
     # A JSON string
     #
     #
     def make_request(endpoint)
       res = ""
       begin
         res += RestClient.get("http://#{@ip}/api/v#{@api_version}#{endpoint}",
       	'Authorization' => "Bearer #{token}")
       rescue => e 
         res += e.message
       end
       #puts "make_request res : #{res}"
       res
     end
     

     # Makes a request to the Array Api using the specified endpoint using 'make_request'
     #     
     # == Parameters:
     # endpoint:
     #   A String with the path from the api root to the resource you want
     #   
     # == Returns:
     #  A JSON parsed object
     #
     #     
     def call(endpoint)
       res = make_request(endpoint)
       JSON.parse(res)
       #res
     end

     def settings_management
       call("/settings/management")
     end

     def settings_dns
       call("/settings/dns")
     end

     def settings_contact
       call("/settings/contact")
     end

     def settings_ssid
       call("/settings/ssid")
     end
 
     def geography_info
       call("/geography-info")
     end

     def settings_iap(iap)
       res = call("/settings/iap/iap#{iap}")
       res["iapCfg"]["entries"][0]
     end

     # returns all SSID
     def settings_ssid
       call("/settings/ssid")
     end

     def ssid_entries
       json = settings_ssid
       json["ssidCfg"]["entries"]
     end


    

     def token
       @token
     end

  end # Array




 
end # XMS