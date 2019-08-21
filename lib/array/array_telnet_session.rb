 $:.unshift File.dirname(__FILE__)
require 'rest-client'
require 'json'
require 'open-uri'
require 'net/http'
require 'net/smtp'
require 'net/telnet'
require 'rest-client'
require 'json'

module Net

  class Telnet

    # The method returns all data received during the login process from
    # the host, including the echoed username but not the password (which
    # the host should not echo).  If a block is passed in, this received
    # data is also yielded to the block as it is received.
    def login(options, password = nil) # :yield: recvdata
      login_prompt = /[Uu]sername[: ]*\z/n
      password_prompt = /[Pp]ass(?:word|phrase)[: ]*\z/n
      if options.kind_of?(Hash)
        username = options["Name"]
        password = options["Password"]
        login_prompt = options["LoginPrompt"] if options["LoginPrompt"]
        password_prompt = options["PasswordPrompt"] if options["PasswordPrompt"]
      else
        username = options
      end
 
      if block_given?
        line = waitfor(login_prompt){|c| yield c } || ""
        if password
          line += cmd({"String" => username,
                       "Match" => password_prompt}){|c| yield c } || ""
          line += cmd(password){|c| yield c } || ""
        else
          line += cmd(username){|c| yield c } || ""
        end
      else
        line = waitfor(login_prompt) || ""
        if password
          line += cmd({"String" => username,
                       "Match" => password_prompt}) || ""
          line += cmd(password) || ""
        else
          line += cmd(username) || ""
        end
      end
      line
    end
  end

end

module EXECUTOR
  
  def self.array_telnet_session(args = {})
    EXECUTOR::ArrayTelnetSession.new(args)
  end

  ############################
  ## CUSTOM EXCEPTION CLASS ##
  ############################
  class NoAraraytelnetDataError < StandardError
    def initialize(msg="NO DATA Returned back from AP Telnet Session")
      super
    end
  end
  
  class ArrayTelnetSession

    attr_accessor :ip, :session, :hostname

    def initialize(args = {})
      @ip = args[:ip]
      @username = args[:username] || "admin"
      @password = args[:password] || "admin"
      @initial_args = args 
      @session = telnet_session(@ip, @username, @password, args[:timeout], args[:waiting_time])
      @session.cmd('configure') do |c|
        print c.gsub(16.chr, '') unless c.nil? || c.empty?
      end
     
      @setup = args[:setup] || true

      if @setup
      cmd('no more')#{ |c| print c }
      unless args[:leave_snmp]
        cmd('snmp v2 off')
        cmd('snmp v3 off')
      end
      #cmd('syslog console disable')
      end
      # @session.cmd('exit') { |c| print c }
    end

    def telnet_session(ip, username, password, timeout=nil, waiting_time=nil)
      timeout ||= 60
      waiting_time ||= 3
      array = Net::Telnet::new('Host' => ip,
         'Timeout' => timeout,
         'Waittime' => waiting_time,
         #'Binmode' => true,
         'Prompt' => /[$%#] /)
      array.login(username,password){|c|
        print c.gsub(16.chr, '') unless c.nil? || c.empty?
      }
      array      
    end    
    

    def cmd(command)
      begin
        output = @session.cmd(command) { |c| print c.gsub(16.chr, '').gsub("\u0010","") unless c.nil? || c.empty? }

        if (output.nil? || output.empty?)
          throw NoAraraytelnetDataError
        end
      rescue Errno::EPIPE, NoAraraytelnetDataError, XMS::NoAraraytelnetDataError => e
        puts e
        puts "Hmmmmmmm AGAIN, Telnet Connection is broken! Trying to Reconnect..."
        begin
          puts "Close Connection"
          @session.close()

          puts "Let's ping to see an AP is dead or alive"
          puts "Sleep 20 seconds before ping"
          sleep 20

          up = XMS::Utilities.ping(@ip, 4, 30, 10)
          if up
            puts "Successful Ping, AP is Online"
          else
            throw "AP is Ofline, Unsuccessful Ping, Please, check your AP's -> :#{@ip} connectivity to bring it Online"
          end

          puts "Trying to establish a new Telnet Connection..."
          @session = telnet_session(@ip, @username, @password, 80, 8)

          output = @session.cmd(command) {
            i = 9
            #|c| print c.gsub(16.chr, '').gsub("\u0010","") unless c.nil? || c.empty?
          }

        rescue => e
          puts " - ***************** - \n\n -- Could't Reconnect \n\n - ***************** - \n"
          puts " - ***************** - \n\n -- Actual Error \n  #{e} \n - ***************** - \n"

          throw "Can't Reconnect to the AP: #{@ip}, Error: #{e}"
        end
      end


      unless output.nil? || output.empty?
        output = output.gsub(16.chr,'').gsub("\u0010",'')
        output = output.split(/\n/)
      end
      output
    end

    def activation_done?(wait_time=10)
      top
      configure
      # puts "Waiting 30 seconds to begin checking activation interval"
      sleep 30
      ready_to_move_on = false
      attempts = 0

      while ((ready_to_move_on == false) && attempts < 35)
        interval = activation_interval()
        attempts += 1

        if interval.nil?
          throw("Unexpected Error. show man command return null which should't be the case")
        end

        if interval == 20
          ready_to_move_on = true
        else
          puts "- not configured yet. On attempt: #{attempts}"
          sleep wait_time
        end
      end

      ready_to_move_on
    end


    # should use show json settings for some commands. for example ->
    # 1. show json settings management
    # 2. show json settings iap-global-ac
    # etc
    # However, for some commands you do not need to add settings   for example -> show json running-config
    def show_json(_command)
      cleaned_show_json = @session.cmd("show json #{_command}"){|c|
        print c.gsub(16.chr, '').gsub("\u0010","") unless c.nil? || c.empty?
      }

      if cleaned_show_json
        cleaned_show_json = cleaned_show_json.gsub("show json #{_command}",'').gsub("#{self.hostname}(config)\#",'').gsub("\u0010",'').gsub("#{16.chr}",'').gsub("\n",'')
        last_curly = cleaned_show_json.rindex('}')
        final_json = cleaned_show_json[0..last_curly]
        JSON.parse(final_json)
      else
        puts "\n\n\n Something Went Wrong NO DATA Returned back from AP Telnet Session \n\n\n"
      end
    end

    def memfree
      show_mem_free = cmd("show memfree")
      show_mem_free.get_line("MemFree:").split(' ')[1]
    end

    def configure_date_time()
      cmd("configure")
      cmd("date-time")
      cmd("dst-adjust enable")
      cmd("ntp enable")
      cmd("timezone -8")
      cmd("exit")
      cmd("exit")
    end

    def configure_dns_servers(s_1="10.100.1.10", s_2="10.100.2.10")
      cmd("configure")
      cmd("dns")
      cmd("server1 #{s_1}")
      cmd("server2 #{s_2}")
      cmd("exit")
      cmd("exit")
    end

    def close_connection
      @session.close
    end

    def close(level=2)
      top
      level.times {cmd('exit')}
    end
  
    def top
      cmd('top')
    end

    def goto_management()
      cmd('top')
      configure()
      management()
    end

    def activate(env='test03')
      goto_management()
      cmd('cloud off')
      cmd("activation stop")
      set_activation_url(env)
      start_activation(true)
    end

    def start_activation(already_in_management=nil)
      goto_management() unless already_in_management
      cmd('activation interval 1')
      cmd('cloud on')
      cmd('activation start')
      cmd('save')
      cmd('exit')
    end

    def set_activation_url(env, times=1, url=nil)
      url = url || ACTIVATION_URL.gsub("env", env)
      times.times{ cmd("Activation Server #{url}") }
    end

    def activation_server()
      show_management().select{|s| s.start_with?("Activation Server")}.first
    end

    def cloud_server()
      show_management().select{|s| s.start_with?("Cloud Server")}.first
    end

    def set_offline(env='test03')
      cmd('top')
      configure()
      management()
      cmd('activation stop')
      cmd('activation interval 1')
      cmd('cloud off')
      cmd('save')
      cmd('exit')
    end

    def configure
      cmd('configure') #{|c| print c}
    end
  
    def management
      cmd('management')#{|c| print c}
    end

    def get_aos_version_info()
      show_json("running-config")["system"]["versionInfo"]
    end

    def activation_interval()
        show_json_activation_interval()
    end

    def download_aos_version(aos_url)
      cmd("configure")
      cmd("file")
      cmd("http-get #{aos_url}")
      cmd("exit")
      cmd("exit")
      cmd("exit")
    end

    def upgrade_aos_version(aos_version)
      cmd("configure")
      cmd("file")
      cmd("active-image #{aos_version}")
      cmd("exit")
      cmd("exit")
    end

    def enable_backdoor()
      cmd("configure")
      cmd("boot-env")
      #AF - 6/15/18
      #cmd("set bootargs CLIOPTS=b")
      cmd("set bootargs console=ttyS0,115200n8 root=/dev/ram rw quiet ACTIVATION_URL=https://activate-test01.cloud.xirrus.com CLIOPTS=b")
      cmd("exit")
      cmd("exit")
    end

    def show
      cmd('show')
    end

    def show_top
      cmd('top') 
      cmd('show')     
    end
  
    def show_management
      configure
      management
      show
    end

    def get_crash_log
      cmd('show crash')
    end

    def show_contact_info
      cmd('show contact-info')
    end
  
    def show_software_image
      #cmd('top')
      configure
      cmd('no more')
      cmd('show software-image')
    end

    def country_code_reset
      configure
      cmd("interface iap")
      cmd("global-settings")
      cmd("country-code-reset")#{|c| print c}
    end

    def set_country_code(code)
      configure
      cmd("interface iap")
      cmd("global-settings")
      cmd("country-code #{code}")
      cmd("exit")
      cmd("exit")
    end

    def show_global_settings
      top
      configure
      cmd('interface iap')
      cmd('global-settings')
      show
    end

    def puts_out(output)
      output.each_with_index{|o,index|
         puts "#{index} : #{o}"
      }
    end  


     def commands(commands_array)
      
      for i in 0..commands_array.length-1 do
        cmd(commands_array[i]) #{ |c| print c }
      end

     end


     def show_dns
       cmd('configure')
       cmd('show dns')
     end


     def show_ntp
       cmd('configure')
       cmd('date-time')
       cmd('show')
     end

     def show_ssids
       cmd('configure')
       cmd('ssid')
       cmd('show')
     end

    def show_ssid(ssid)
       top
       cmd('ssid')
       cmd("show ssid #{ssid}")
     end

     def ssid_whitelist(ssid_name)
       top
       cmd('ssid')
       cmd("edit #{ssid_name}")
       cmd('show wpr-whitelist all')
     end

     def show_timezone_offset()
       cmd('configure')
       cmd('date-time')
       cmd('show').get_line("Offset").split(' ')[2].strip
     end

     def show_defaults_by_section(section_type)
       valid_options = ["lldp", "security wep", "syslog", "contact-info", "interface iap"]  # TODO add more types in the future
       raise(ArgumentError, "Section type must be one of : #{valid_options.to_s}") unless valid_options.include?(section_type.delete('\\"'))
       x = cmd("show running-config inc-defaults section #{section_type}")

       section_type = section_type.delete('\\"')
       if section_type == "lldp"
         x = {
           "interval"=> x.get_line("interval").split(' ')[1].strip,
           "hold-time"=> x.get_line("hold-time").split(' ')[1].strip,
           "enable"=> x[x.index{|a|a.include?("hold-time")} + 1...x.index{|a|a.include?("request-power")}].first.strip,
           "request-power"=> x.get_line("request-power").split(' ')[1].strip
         }
       elsif section_type == "security wep"
         x = {"default-key"=> x.get_line("default-key").split(' ')[1].strip}
       elsif section_type == "syslog"
         x = {"enable"=> x[x.index{|a|a.include?("exit")}-1].strip}
       elsif section_type == "contact-info"
         x = {
           "name"=> x.get_line("name").split(' ')[1].strip.delete('\\"'),
           "phone"=> x.get_line("phone").split(' ')[1].strip.delete('\\"'),
           "email"=> x.get_line("email").split(' ')[1].strip.delete('\\"')
         }
       elsif section_type == "interface iap"
         # TODO Add more Global options if needed. For now we just return only multicasts.
         x = {
           "multicasts"=> x.get_lines(/multicast/).map{ |multicast| multicast.split(" ").drop(1).join(" ") }
         }
       end
        x
     end

     def ssid_time_settings(ssid_name)
       ssid_settings = show_ssid(ssid_name)
       time_on = ssid_settings.get_line("Time on").split(' ')[2].strip
       time_off = ssid_settings.get_line("Time off").split(' ')[2].strip
       days_on = ssid_settings.get_line("Days on").split(' ')[2..-1]
       [time_on, time_off, days_on]
     end

     def show_group(group_name)
       top
       cmd('group')
       cmd("show group #{group_name}")
     end

     def group_time_settings(group_name)
       g_settings = show_group(group_name)
       time_on = g_settings.get_line("Time on").split(' ')[2].strip
       time_off = g_settings.get_line("Time off").split(' ')[2].strip
       days_on = g_settings.get_line("Days on").split(' ')[2..-1]
       [time_on, time_off, days_on]
     end

      def show_filter_list
        cmd('configure')
        cmd('filter')
        cmd('show filter-list')
      end

      def change_filter_state(filter_name, state)
        valid_options = ["enable", "disable"]
        raise(ArgumentError, "Filter State option must be one of : #{valid_options.to_s}") unless valid_options.include?(state)
        cmd('configure')
        cmd('filter')
        cmd("edit-list #{filter_name}")
        cmd(state)
        cmd("exit")
        cmd("exit")
        cmd("exit")
      end

      def show_policy(name)
        show_filter_list
        cmd("edit-list #{name}")
        cmd('show')
      end
     
      def show_saved_config_section(section)
        configure
        cmd("show saved-config inc-defaults section \"#{section}\"")
      end

      def show_json_ssids()
        show_json("no-header raw running-config")["system"]["ssidCfg"]["entries"]
      end

      def show_json_activation_interval()
        show_json("no-header raw running-config")["system"]["extMgmt"]["mgmtCfg"]["activationInterval"]
      end

      def show_system_software()
        k = show_json("running-config")["system"]["versionInfo"]["swName"]
      end

      def show_json_policies(_case = "filterListAll")
        show_json("running-config")["system"][_case]["entries"]
      end

      def clear_syslog()
        configure
        cmd("clear syslog ")
      end

      def get_syslog()
        cmd("show syslog")
      end

      def show_json_global_settings()
        show_json("running-config")["system"]["iapGlbCfg"]
      end

      def show_json_dhcp_server_settings()
       show_json("running-config")["system"]["dhcpServerCfg"]["entries"].first
      end

      def show_json_dhcp_gig_settings(port_type = "gig1")
        show_json("running-config")["system"]["ethCfg"]["entries"].find { |entry| entry["dev"] == port_type }
      end

      def show_running_config_section(section)
        configure
        cmd("show running-config inc-defaults section \"#{section}\"")
      end

      def show_location_reporting()
        show_json("running-config")["system"]["locationCfg"]
      end

      # Before running this method please, make sure CLIOPTS=b  is set on an AP. Here how to set it
      # ssh to an AP and run  configure -> boot-env ->  the the remaining.
      # X206439033B6E(config-boot)# edit bootargs console=ttyS0,115200n8 root=/dev/ram rw quiet ACTIVATION_URL=https://activate-test03.cloud.xirrus.com CLIOPTS=b
      # X206439033B6E(config-boot)# save
      # Saving boot environment ... OK
      def show_passwords_enable()
        configure
        cmd("show clear-text enable")
      end

      def iap_settings(iap_number)
        top
        configure
        cmd('interface iap')
        cmd("iap#{iap_number}")
        cmd('show')
      end

      def global_iap_settings
        show_running_config_section("interface iap  ! (global settings)")
      end
      
      def show_gig(gig_number)
        top
        cmd("interface gig#{gig_number}")
        cmd("show")
      end

      def show_profile_optimizations
        show_json("settings iap-global-ac")
      end

      def show_gig1
        show_gig("1")
      end

      def show_gig2
        show_gig("2")
      end

      def led_setting(gig_number)
        gig_settings = self.send(:show_gig, gig_number)
        gig_settings.get_line("LED indicator").split(' ')[2].strip
      end

     def verify_list(list,verify)

       first_verify = verify.split(/\s+/)[0]
       clean_list = []
       list.each{|item| 
         it = item.gsub("#{16.chr}",'').gsub("\u0010","")
         clean_list << it 
       }
       related_list = clean_list.grep(/#{first_verify}/i)
       puts "Here is your related outputs: \n"
       related_list.each {|output| puts output}

       trimmed_list = []

       related_list.each {|list| trimmed_list.push(list.gsub(/\s+/,'').downcase)}

       if trimmed_list.include? "#{verify.gsub(/\s+/,'').downcase}"
         status = 'Pass'
       else
         status = "Fail: Not able to match: #{verify}"
       end

       status

     end

  def configure_management_show(verify)
    @verify = verify

    cmd('configure') #{ |c| print c }
    cmd('management') #{ |c| print c }
    output = cmd('show') 
    list = output #.split(/\n/)
    first_verify = @verify.split(/\s+/)[0]
    related_list = list.grep(/#{first_verify}/i)
    puts "Here is your related outputs: \n"
    related_list.each {|output| puts output}

    trimmed_list = []

    related_list.each {|list| trimmed_list.push(list.gsub(/\s+/,'').downcase)}

    if trimmed_list.include? "#{@verify.gsub(/\s+/,'').downcase}"
      status = 'Pass'
    else
      status = "Fail: Not able to match: #{@verify}"
    end
    status

  end

  def configure_datetime_show(verify)

     @verify = verify

    @session.cmd('configure') { |c| print c }
    @session.cmd('date-time') { |c| print c }

    output = cmd('show') 
   # puts "Output : #{output.to_s}"
    list = output #.split(/\n/)
    first_verify = @verify.split(/\s+/)[0]
    related_list = list.grep(/#{first_verify}/i)
    puts "Here is your related outputs: \n"
    related_list.each {|output| puts output}

    trimmed_list = []

    related_list.each {|list| trimmed_list.push(list.gsub(/\s+/,'').downcase)}

    if trimmed_list.include? "#{@verify.gsub(/\s+/,'').downcase}"
      status = 'Pass'
    else
      status = "Fail: Not able to match: #{@verify}"
    end
    status    

  end # configure, datetime show

  def show_software_image(release,build)
    @rel = release
    @build = build

    output = cmd('show software-image') 
    sw_info = output #.split(/\n/).grep(/software version/i)


    if sw_info[0].match(/#{@rel}.+#{@build}/)
      status = 'Pass'
    else
      status = "Fail: Not able to match: #{@rel} and #{@build}"
    end
    status

  end

  def show_array_info(verify)
    @verify = verify

    output = cmd('show array-info')
    list = output #.split(/\n/)
    first_verify = @verify.split(/\s+/)[0]
    related_list = list.grep(/#{first_verify}/i)
    puts "Here is your related outputs: \n"
    related_list.each {|output| puts output}

    trimmed_list = []

    related_list.each {|list| trimmed_list.push(list.gsub(/\s+/,'').downcase)}

    if trimmed_list.any? {|item| item.include? "#{@verify.gsub(/\s+/,'').downcase}"}
      status = 'Pass'
    else
      status = "Fail: Not able to match: #{@verify}"
    end
    status

  end

  def config_ssid_show(verify)
    @verify = verify
    @session.cmd('config') { |c| print c }
    @session.cmd('ssid') { |c| print c }
    output = cmd('show') # { |c| print c }
    list = output #.split(/\n/)

    first_verify = @verify.split(/\s+/)[0]
    related_list = list.grep(/#{first_verify}/i)
    puts "Here is your related outputs: \n"
    related_list.each {|output| puts output}

    trimmed_list = []

    related_list.each {|list| trimmed_list.push(list.gsub(/\s+/,'').downcase)}

    if trimmed_list.any? {|item| item.include? "#{@verify.gsub(/\s+/,'').downcase}"}
      status = 'Pass'
    else
      status = "Fail: Not able to match: #{@verify}"
    end
    status

  end

  def config_ssid_show_ssid(ssid,verify)
    @ssid = ssid
    @verify = verify
    @session.cmd('configure') { |c| print c }
    @session.cmd('ssid') { |c| print c }
    output = cmd("show ssid #{@ssid}") #{ |c| print c }
    list = output #.split(/\n/)

    first_verify = @verify.split(/\s+/)[0]
    related_list = list.grep(/#{first_verify}/i)
    puts "Here is your related outputs: \n"
    related_list.each {|output| puts output}

    trimmed_list = []

    related_list.each {|list| trimmed_list.push(list.gsub(/\s+/,'').downcase)}

    if trimmed_list.any? {|item| item.include? "#{@verify.gsub(/\s+/,'').downcase}"}
      status = 'Pass'
    else
      status = "Fail: Not able to match: #{@verify}"
    end
    status

  end

  def config_security_show(verify)
    @verify = verify
    @session.cmd('config') { |c| print c }
    @session.cmd('security') { |c| print c }
    output = cmd('show') #{ |c| print c }
    list = output #.split(/\n/)

    first_verify = @verify.split(/\s+/)[0]
    related_list = list.grep(/#{first_verify}/i)
    puts "Here is your related outputs: \n"
    related_list.each {|output| puts output}

    trimmed_list = []

    related_list.each {|list| trimmed_list.push(list.gsub(/\s+/,'').downcase)}

    if trimmed_list.any? {|item| item.include? "#{@verify.gsub(/\s+/,'').downcase}"}
      status = 'Pass'
    else
      status = "Fail: Not able to match: #{@verify}"
    end
    status

  end

 
  

  def config_filter_show_filter_list(verify)
    @verify = verify
    @session.cmd('config') { |c| print c }
    @session.cmd('filter') { |c| print c }
    output = cmd('show filter-list') #{ |c| print c }
    list = output #.split(/\n/)

    first_verify = @verify.split(/\s+/)[0]
    related_list = list.grep(/#{first_verify}/i)
    puts "Here is your related outputs: \n"
    related_list.each {|output| puts output}

    trimmed_list = []

    related_list.each {|list| trimmed_list.push(list.gsub(/\s+/,'').downcase)}

    if trimmed_list.any? {|item| item.include? "#{@verify.gsub(/\s+/,'').downcase}"}
      status = 'Pass'
    else
      status = "Fail: Not able to match: #{@verify}"
    end
    status

  end

  
  
    #private
  
    def username
      @username
    end
  
    def password
      @password
    end

  end # Array 
end # EXECUTOR