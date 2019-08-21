module EXECUTOR
  
  def self.get_id_by_title(title, value, token)
    begin
      path="http://10.100.185.250:3000/api/v1/#{title}"
      response = RestClient.get path, {Authorization: "Bearer #{token}", params: {title: "#{value}"}}
      response_json = JSON.parse(response, :symbolize_names => true)
      item_id =  response_json[:data][:id].to_i 
      return item_id
    rescue
      puts "#{value} NOT FOUND IN DATABASE"
    end
  end
  
def self.get_token_by_email_password(email, password)
    begin
      path="http://10.100.185.250:3000/api/v1/login"
      response = RestClient.post path, {email: "#{email}", password: "#{password}"}.to_json, {content_type: :json, accept: :json}
      response_json = JSON.parse(response, :symbolize_names => true)
      token =  response_json[:token] 
      return token
    rescue
      puts "#{value} NOT FOUND IN DATABASE"
    end
  end
  
  def self.move_log_file_to_remote_server(server_addr, local_path, remote_path, testcase_name)
    begin
        Net::SSH.start(server_addr, "xirrus", password: "Xirrus!23") do |ssh|
        ssh.exec!("mkdir -p #{remote_path}")
        ssh.scp.upload! "#{local_path}/#{testcase_name}.html", "#{remote_path}/#{testcase_name}.html"
        ssh.scp.upload! "#{local_path}/#{testcase_name}.txt", "#{remote_path}/#{testcase_name}.txt"
       end
    rescue
      puts "something wrong with file transfer"
    end
  end
  

  
  def self.spec_helper(settings)
    spec_settings = settings || {}
    #static variables
    $the_environment_used = spec_settings[:env] || "test03"
    $the_browser_used = spec_settings[:browser_name] || BROWSER_NAME
    $azure_user= "adinte@alexxirrusoutlook.onmicrosoft.com"
    $azure_password= "Xirrus!234"
    $google_user="kartik@xirrus.org"
    $google_password="Xirrus!23"
    #custom rspec varaibles
    RSpec.configuration.add_setting :spec_settings
    RSpec.configuration.spec_settings = spec_settings
    RSpec.configuration.spec_settings[:telnet] = (settings[:telnet] == false || settings[:telnet] == 'false') ? false : true
    RSpec.configuration.add_formatter 'progress'
    RSpec.configuration.add_formatter ReportStatusFormatter

    RSpec.configure do | config |
      #BEFORE ALL TESTCASES
      config.before :all do    
        # @start_time= Time.now #.strftime("%Y-%m-%d %H:%M:%S")
        require_relative '../../spec/context.rb'
        puts "In the beginning..."
           @env = spec_settings[:env] || "test03"
           @build_id = spec_settings[:build_id]
           puts "Enviornment: #{@env}"
           @xms_url = "https://xcs-#{@env}.cloud.xirrus.com"
           @login_url = "https://login-#{@env}.cloud.xirrus.com"
           puts "LOGIN_URL: #{@login_url}"
           @username = spec_settings[:username]
           @password = spec_settings[:password]
           @download = spec_settings[:download] || DEFAULT_DOWNLOAD
           puts "DOWNLOAD DIR: #{@download}"
           if (spec_settings[:skip_api] != true)
              @ng = api
            else
              @login_url = @xms_url
           end
           puts "current user , @username: #{@username}"
           @settings = spec_settings
           @date_path = spec_settings[:date_path]
           @time_path = spec_settings[:time_path] || "#{Time.now.strftime('%H-%M')}"
           @timestamp = spec_settings[:timestamp] || Time.now.strftime("%D-%H-%M").gsub('/','-')
           @log_file = RSpec.configuration.spec_settings[:log_file]
           @no_log = spec_settings[:no_log]
           @hub_URL=nil
           @each_sleep = 3
           array = spec_settings[:array]
           array_serial = spec_settings[:array_serial]
           telnet= spec_settings[:telnet]          
           
          #################################
          # Check for instance of an XMS::Array in settings
          # Create instance of XMS::Array @array if :array_serial flag passed in
          if(array && array.respond_to?(:ng_format))
            @array = array
          else
            unless array_serial.nil?
            ###
            # TODO add alternate way to create array - from backoffice json
            # XMS::Array - needs backoffice_json_to_attributes method and/or add 
              if File.exist? "#{EXECUTOR.fixtures_root}/json/#{array_serial}.json"
                @array = EXECUTOR::Array.new(json_file: "#{EXECUTOR.fixtures_root}/json/#{array_serial}.json", env: @env )
              elsif File.exist? "#{EXECUTOR.fixtures_root}/json/arrays/#{array_serial}.json"
                 @array = EXECUTOR::Array.new(json_file: "#{EXECUTOR.fixtures_root}/json/arrays/#{array_serial}.json", env: @env )
              else             
                @array = EXECUTOR::Array.new(serial: array_serial, env: @env )
              end
            end
          end
        
        @use_telnet = telnet
        puts "TELNET: #{telnet}"
        # XMS::Array instance created, setup here
        if @array
          if (telnet == true)
            @array.get_ready_for_cloud_test({env: @env})
          else
          end
        end
           ##################################
           unless @no_log
             puts "LOG FILE: #{@log_file}"
             File.open(@log_file,'w'){|f| f.write("\n-------------- Logging RSpec -------------\n  Timestamp: #{@timestamp} \n #{spec_settings[:array_serial]} - #{spec_settings[:browser_name]} \n")}
           end
           puts "UI: #{spec_settings[:ui]}"
           @browser_name = spec_settings[:browser_name] || BROWSER_NAME
           unless (spec_settings[:ui] == false || spec_settings[:ui] == "false")
             puts ""
             #          if settings[:headless] != 'false'
             #            if settings[:headless_display]
             #              display = settings[:headless_display]
             #            else
             #              display = 10
             #            end
             #            headless = Headless.new(display: display)
             #            headless.start
             #            #headless.start
             #          end
             if ( spec_settings[:sauce] == true || spec_settings[:sauce] == "true" )
               @browser = XMS.sauce_browser(spec_settings)
             elsif spec_settings[:browserstack] == true
               puts "Using BrowserStack"
               puts "OS: #{spec_settings[:os]}"
               puts "OS VERSION: #{spec_settings[:os_version]}"
               puts "User: #{spec_settings[:browserstack_user]}"
               puts "Pass: #{spec_settings[:browserstack_key]}"
               puts "browser name: #{spec_settings[:browser_name]}"
               puts "browser version: #{spec_settings[:browser_version]}"
               puts "browser stack local? = #{spec_settings[:browserstack_local]}"
               @browser = XMS.browserstack(spec_settings)
             else
               if(@browser_name.to_s=="firefox")
                 capabilitiez = Selenium::WebDriver::Remote::Capabilities.firefox(marionette: false)
                 @browser = Watir::Browser.new :firefox, {
                   :url => @hub_URL,
                   :platform => spec_settings[:os],
                   :version => spec_settings[:browser_version]
                 }
               elsif @browser_name.to_s == "edge"
                 capabilitiez = Selenium::WebDriver::Remote::Capabilities.edge
                 @browser = Watir::Browser.new :edge, {
                   :url => @hub_URL,
                   :platform => spec_settings[:os],
                   :version => spec_settings[:browser_version]
                 }#desired_capabilities: capabilitiez
               elsif @browser_name.to_s == "safari"
                 @browser = Selenium::WebDriver::Safari
               else
                 @browser = Watir::Browser.new
               end
             end
             if @browser_name.to_s!="mobile"
               if @browser_name.to_s!="safari"
                 @session_id = @browser.driver.instance_variable_get("@bridge").session_id
                 puts "BROWSER SESSION ID : #{@session_id}"
                 @browser.driver.manage.window.maximize
                 #end
               end
             end
             @ui = GUI::UI.new(args = {browser: @browser})
       
             if @browser_name.to_s!="mobile"
               unless spec_settings[:no_login]
                 @ui.login(@login_url, @username, @password)
                 $the_user_used = @username
                 sleep 2
                 @ui.main_container.wait_until(&:present?)
                 i = 0
                 while !@ui.user_name_dropdown.present?
                   sleep 0.5
                   i+=1
                   if i == 50
                     @browser.refresh
                   elsif i == 100
                     break
                   end
                 end
                 @ui.id("header_logo").wait_until(&:present?)
                 version_file = "#{ENV['HOME']}/#{@env}_version.txt"
                 if @ui.id("version_number").present?
                   #@ui.id("version_number").wait_until(&:present?)
       
                   if File.exist?(version_file)
                     previous_version = File.read(version_file)
                   else
                     previous_version = nil
                   end
       
                   current_version_number = @ui.id("version_number").text
                   @build_id=current_version_number.split('-')[1]+"-"+current_version_number.split('-').last
                   $build_id = @build_id
                   puts("CURRENT BUILD FOR THE APPLICATION: #{current_version_number}")
       
                   if previous_version == current_version_number
                     puts "#{version_file} already current - #{current_version_number}"
                   else
                     puts "updating #{version_file} from #{previous_version} to #{current_version_number}"
                     File.open("#{version_file}","w+"){|f| f.write(current_version_number)}
                   end
       
                 else
                   if File.exist?(version_file)
                     needed_version_number = File.read(version_file)
                   else
                     needed_version_number = nil
                   end
                   puts("CURRENT BUILD FOR THE APPLICATION: #{needed_version_number}")
                 end
                 puts("USER ACCOUNT: #{@username}")
                 puts("_________________________________________________________________________________")
                 if @ui.toast_dialog.present?
                   @ui.toast_dialog_ok_button.click
                   @ui.toast_dialog.wait_while_present
                   #sleep 4
                 end
                 sleep 2
                 if @ui.easypass_upgrade_modal.present?
                   sleep 1
                   @ui.easypass_upgrade_modal_close_button.click
                   @ui.easypass_upgrade_modal.wait_while_present
                 end
               end
             end
       
             sleep 3
           end #Unless NO UI
      end #before all

      #BEFORE EACH TESTCASE
      config.before :each do |example|
        unless settings[:no_log]
          puts ("Example Description --> #{example.description} - #{Time.now}")
          if @ui.toast_dialog.present?
            @ui.toast_dialog_ok_button.click
            @ui.toast_dialog.wait_while_present
            sleep 2
          end
        end
      end #Before each

      #AFTER EACH TESTCASE
      config.after :each do |example|
        unless (settings[:ui] == false || settings[:ui] == "false")
          if @ui.error_dialog.present?
            puts "Error Dialog Present"
            log("--- FAILED - Error Dialog Present ---")
            # @browser.screenshot
            if @ui.error_dialog.text != "A maximum of 64 whitelist items can be added to the guest portal"
              if @ui.error_title != "Error"
                if  @ui.error_dialog_close.present?
                  log("--- STILL FAILED --- but closed the ERROR DIALOG ---")
                  @ui.error_dialog_close.click
                end
                if @ui.error_title == "500 Server Error"
                  expect(@ui.error_title).not_to eq("500 Server Error")
                end
              end
            end
          end
        end # no ui
        sleep 4
      end #After Each
      
      #AFTER ALL TESTCASES
      config.after :all do     
        unless (spec_settings[:ui] == false || spec_settings[:ui] == "false")
           unless @browser.nil?
             @browser.quit
           end
        end # no ui
      end # after :all
    end #Rspec configuration
  end #spec_helper
end #module EXECUTOR