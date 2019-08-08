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
        line = waitfor(login_prompt){|c| yield c }
        if password
          line += cmd({"String" => username,
                       "Match" => password_prompt}){|c| yield c }
          line += cmd(password){|c| yield c }
        else
          line += cmd(username){|c| yield c }
        end
      else
        line = waitfor(login_prompt)
        if password
          line += cmd({"String" => username,
                       "Match" => password_prompt})
          line += cmd(password)
        else
          line += cmd(username)
        end
      end
      line
    end






  end

end

module XMS
  
  def self.array_telnet_session(args = {})
    XMS::ArrayTelnetSession.new(args)
  end
  
  class ArrayTelnetSession

    attr_accessor :ip, :session, :hostname

    def initialize(args = {})
      @ip = args[:ip]
      @username = args[:username] || "admin"
      @password = args[:password] || "admin"
      @initial_args = args 
      @session = telnet_session(@ip,@username,@password)
#puts @session
      #@session.cmd(@username)#{ |c| print c}
      #@session.cmd(@password){ |c| print c}
      @session.cmd('configure'){|c| 
       
        print c.gsub(16.chr, '')
      }
     
      @setup = args[:setup] || true

      if @setup
      cmd('no more')#{ |c| print c }
      unless args[:leave_snmp]
        cmd('snmp v2 off')
        cmd('snmp v3 off')
      end
      cmd('syslog console disable')
      end
     # @session.cmd('exit') { |c| print c }
    end

    def telnet_session(ip, username, password)
      array = Net::Telnet::new('Host' => ip,
                               'Timeout' => 30,
                               'Waittime' => 3,
                               #'Binmode' => true,
                               'Prompt' => /[$%#] /)
      array.login(username,password){|c| print c.gsub(16.chr, '')}    
      array      
	  end    
    

  	def cmd(command)
  	  output = @session.cmd(command){|c| 
        unless c.nil?
         print c.gsub(16.chr, '').gsub("\u0010","")
        end
      }
      unless output.nil?
        output = output.gsub(16.chr,'').gsub("\u0010",'')
        output = output.split(/\n/)
      end
      output
  	end

    def activation_done?(wait_time=10)
      top
      configure
       # puts "Waiting 30 seconds to begin checking activation interval"
      #  sleep 30
        ready_to_move_on = false
        attempts = 0
        while ((ready_to_move_on == false) && attempts < 15)
          man = cmd('show man')
          attempts += 1
          interval_line = man.select{|m| m.start_with?"Activation Interval"}.first 
          interval = interval_line.split(' ')[2]
         # log("Checking Activation Interval #{interval} - #{Time.now}")
          if interval == "5"
            ready_to_move_on = true 
          else
            sleep wait_time
          end
          
        end
      ready_to_move_on
    end

    def show_json(_command)
      JSON.parse(@session.cmd("show json #{_command}"){|c| print c}.gsub("show json #{_command}",'').gsub("#{self.hostname}(config)\#",'').gsub("\u0010",'').gsub("#{16.chr}",'').gsub("\n",''))
    end

    def close
      top
      cmd('exit')
      cmd('exit')
    end
  
  	def top
  	  cmd('top')
    end
  
  	def configure
  	  cmd('configure') #{|c| print c}
  	end
  
  	def management
  	  cmd('management')#{|c| print c}
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
     # @session.cmd("top"){|c| print c}
      configure
      cmd("interface iap")
      cmd("global-settings")
      cmd("country-code-reset")#{|c| print c}
    end

    def show_global_settings
      top
      configure
      cmd('interface iap')
      cmd('global-settings')
      #cmd('save')
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


      def show_policy(name)
        show_filter_list
        cmd("edit-list #{name}")
        cmd('show')
      end
     
      def show_saved_config_section(section)
        configure
        cmd("show saved-config inc-defaults section \"#{section}\"")
      end

      def show_running_config_section(section)
        configure
        cmd("show running-config inc-defaults section \"#{section}\"")
      end


      def iap_settings(name)
        top
        configure
        cmd('interface iap')
        cmd('iap2')
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




 
end # XMS