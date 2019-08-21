shared_examples "move associated column" do

  it "UI - Move Associated Clients up in column order list" do 

    column_modal = @ui.open_column_selector_modal
    sleep 1
    current_columns_list = column_modal.div(css: ".rhs.greybox").ul 
    current_columns_list.wait_until_present
    
    associated_clients_item = current_columns_list.li(text: "Associated Clients")

    associated_clients_item.wd.location_once_scrolled_into_view
    sleep 1    
    
    associated_clients_item.drag_and_drop_by 0, -50

    sleep 2
    column_modal.a(id: "column_selector_modal_save_btn").click 
    sleep 3
    column_modal.wait_while_present 

    sleep 3

    headers = @ui.ap_grid.elements( xpath: "//th" )

    ## first column is always select column so get the second one
    # column_header = @ui.ap_grid.element(xpath: "//th[2]")

    expect(headers[-1].text).to_not include("Associated Clients")

  end

end


shared_examples "set ap grid column defaults" do 

  it "UI - Set AP Grid columns back to defaults" do
    @ui.goto_mynetwork()
    sleep 10
    @ui.goto_access_points_tab()
    sleep 6
    @ui.id("arrays_grid").wait_until_present
    @ui.id("mynetwork_arrays_grid_cp").click
    sleep 1
    column_picker_modal = @browser.div(css: ".column_selector_modal")
    column_picker_modal.wait_until_present
    expect(column_picker_modal.div(css: ".commonTitle").text).to eql("Select Columns")
    column_picker_modal.a(id: "column_selector_restore_defaults").click
    column_picker_modal.a(id: "column_selector_modal_save_btn").click
    sleep 1

    expect(@ui.ap_grid.a(id: "mynetwork_arrays_grid_col_header_sort_btn_clients").present?).to be false

    ## first column is hidden action buttons, second is select column, so get the third one
    column_header = @ui.ap_grid.element(xpath: "//th[3]")

    expect(column_header.text).to include("Access Point Hostname")

  end

end



shared_examples "general tab check" do

  include_context "array details radios setup"  

  before :all do 
    @general_content = @so.general_content
    @telnet_session = @array.telnet_session
  end

    it "Profile Dropdown" do 
      sleep 2
      expect(@general_content.profile_dropdown_button).to be_present
     # @general_content.profile_dropdown_button.click
      li = @general_content.profile_list_item("Unassigned Access Points")
      li.wd.location_once_scrolled_into_view
      li.click
      sleep 1
     

    end

    it "Hostname" do 

      expect(@general_content.hostname.value).to eql(@array.hostname)

      @general_content.hostname.set("allibaba")
      sleep 1

      @ui.send_keys :tab 

      expect(@general_content.hostname.value).to eql("allibaba")

      @general_content.hostname.set(@array.hostname)
      sleep 1

      @ui.send_keys :tab 


    end

    it "Location" do 

      @general_content.location.clear 
      @general_content.location.set "#{@date_path}-#{@time_path}"
      @so.save_btn.click

    end

    it "add and delete a tag" do 
      @general_content.add_tag_btn.click
      @ui.set_text_field_by_id("arrays_clients_add_tag_input", "#{@time_path}")
      @ui.id("general_add_tag_btn").wait_until_present
      @ui.id("general_add_tag_btn").click
      new_tag = @general_content.el.div(css: ".tagControlContainer").element(xpath: "//span[@class='text' and text()='#{@time_path}']").parent
      new_tag.wait_until_present
      new_tag.span(css: ".delete").click
      sleep 1
      @so.save_btn.click
      sleep 2
      expect(@ui.error_dialog).to_not be_present          
    end

    include_examples "activate"

    it "IP Address Text Field Visible" do 

      expect(@general_content.ip_address).to be_visible

    end

    it "Netmask Text Field Visible" do 

      expect(@general_content.netmask).to be_visible

    end

    it "Gateway Text Field Visible" do 

      expect(@general_content.gateway).to be_visible

    end

end # shared general tab check





shared_examples "info tab check" do 

  include_context "array details radios setup"

  before :all do 
    sleep 3
    @so.system_tab.click
    sleep 1
    @system_content = @so.system_content
    @system_content.wait_until_present
  end

  context "Software Section" do 
  
    before :all do 
     
      expect(@system_content.software_section).to be_visible
    end

    it "Has Compenent Column" do 
      expect(@system_content.software_section_component_header).to be_visible
    end

    it "Has Version Column" do 
      expect(@system_content.software_section_version_header).to be_visible
    end

    it "License Key is correct" do 
    
      license_row = @system_content.system_component_row("licensekey")
      spans = license_row.spans
     
      expect(spans[0].text).to eql('License Key')
      expect(spans[1].text).to eql(@array.license)

    end

  end # context software section


  context "Hardware Section" do 

    before :all do 
      @hardware_section = @system_content.hardware_section
      @hardware_section.wd.location_once_scrolled_into_view
    end

    it "Array row has correct values - Part Number, Serial Number" do
      array_row = @system_content.hardware_array_row
      cells = array_row.divs(css: ".field_cell")
      expect(cells[0].text).to eql("Access Point")
      expect(cells[1].text).to eql(@array.model)
      expect(cells[2].text).to eql(@array.serial)
    end


  end # context software section


  context "Network Section" do 

    before :all do 
      @network_section = @system_content.network_section
      @network_section.wd.location_once_scrolled_into_view
    end

    it "IAP MAC address correct" do 
      expect(@system_content.network_iaps_row.text).to include(@array.iapmac)

    end

    it "Gig 1 MAC address correct" do 
      expect(@system_content.network_gig1_row.text).to include(@array.mac)
    end
      

  end # context network section

end # shared examples "info tab check"




shared_examples "verify ntp and network" do |test_profile|
no_activate = test_profile[:no_activate]
cdp = test_profile[:cdp] ? test_profile[:cdp].split(',') : nil
ntp = test_profile[:ntp] ? test_profile[:ntp].split(',') : nil
dns = test_profile[:dns] ? test_profile[:dns].split(',') : nil
mtu = test_profile[:mtu] ? test_profile[:mtu] : nil

unless RSpec.configuration.spec_settings[:telnet] == "false"
context "Array - Verify NTP and Network" do


    before :all do 
      
      expect(@array).to_not be_nil

     
      @dns = test_profile[:dns]
  
      @mtu = test_profile[:mtu]
      
      @ntp_array = ntp
      unless RSpec.configuration.spec_settings[:telnet] == "false"
       @telnet_session =  @telnet_session || @array.telnet_session 
      end
    end
  
      include_examples "activate"
   
  if ntp
    context "NTP" do 

      before :all do
        @telnet_session.configure
        @telnet_session.cmd('date-time')
        @ntp_output = @telnet_session.show 
        log("test data #{ntp}")
        log("array response:")
        @ntp_output.each{|ntpo| 
          log(ntpo)
         
        }
      end
  
      it "NTP State Enabled" do 
        
        verify_list(@ntp_output, "NTP State  Enabled")
        verify_list(@ntp_output, "DST Auto Adjust  Enabled")
        
      end


      it "NTP Primary server " do
        
        verify_list(@ntp_output,"NTP Primary server  #{@ntp_array[1]}")

      end

      it "NTP Primary server auth " do 

        verify_list(@ntp_output, "NTP Primary server auth  #{@ntp_array[2]}")

      end 


      it "NTP Primary server auth key ID" do 

        verify_list(@ntp_output, "NTP Primary server auth key ID  #{@ntp_array[3]}")

      end


      it "NTP Primary server auth key set" do

        verify_list(@ntp_output, "NTP Primary server auth key set")

      end

      
      if test_profile[:ntp].split(',')[5] == 'sec'
      it "NTP Secondary server" do 

        verify_list(@ntp_output, "NTP Secondary server  #{@ntp_array[6]}")

      end

      it "NTP Secondary server auth " do 

        verify_list(@ntp_output, "NTP Secondary server auth  #{@ntp_array[7]}")

      end 


      it "NTP Secondary server auth key ID" do 

        verify_list(@ntp_output, "NTP Secondary server auth key ID  #{@ntp_array[8]}")

      end


      it "NTP Secondary server auth key set" do

        verify_list(@ntp_output, "NTP Secondary server auth key set")

      end
      end # if secondary
    end # context NTP
   end # if ntp
 



   if cdp
    context "CDP" do 
   
      before :all do 
        @telnet_session.cmd('configure')
        @telnet_session.cmd('cdp')
        @cdp_output = @telnet_session.show 
        log_data_response(cdp,@cdp_output)

        @cdp_state = (cdp[0].downcase == "yes") ? "enabled" : "disabled"
        
      end

      it "State" do 

        verify_list(@cdp_output, "State  #{@cdp_state}")

      end


      it "Interval is #{cdp[1]}" do 

        verify_list(@cdp_output, "Interval   #{cdp[1]}  seconds")

      end


      it "Hold Time is #{cdp[2]}" do

        verify_list(@cdp_output, "Hold time  #{cdp[2]} seconds")

      end

    end
   end # if cdp


   if mtu
    context "MTU" do 

      before :all do 
 
        @telnet_session.cmd('configure')
        @telnet_session.cmd('interface gig1')
        @mtu_output = @telnet_session.show 
        log_data_response(mtu,@mtu_output)
      end

      it "MTU is #{test_profile[:mtu]}" do 

        mtu_line = @mtu_output.select{|line| line.gsub(16.chr,'').gsub("\u0010",'').start_with?"MTU"}
        expect(mtu_line[0]).to include(test_profile[:mtu].to_s)
        expect(mtu_line[0]).to include("MTU")
        expect(mtu_line[0]).to include("bytes")

      end

    end
   end # 

   if dns 
    context "Network" do 

        before :all do 
          @dns_output = @telnet_session.show_dns
          log_data_response(dns,@dns_output)
        end

        it "Hostname is still serial \#" do 
          hostname_line = @dns_output.select{|line| line.start_with?"Hostname "}.first
          expect(hostname_line).to include(@array.serial)

        end

        it "Domain is xirrus.com" do
          domain_line = @dns_output.select{|line| line.start_with?"Domain "}.first
       
          expect(domain_line).to include("xirrus.com")
        end

        it "DNS Server 1" do 

          verify_list(@dns_output, "Server  1  #{@dns.split(',')[0]}")

        end

        it "DNS Server 2" do 

          verify_list(@dns_output, "Server  2  #{@dns.split(',')[1]}")

        end


        it "Use DHCP off" do 

          verify_list(@dns_output, "Use DHCP off")

        end

    end # Network
   end


  end # main context
end # unless telnet false
end # shared ntp and network




shared_examples "verify ssids" do |test_profile|
unless RSpec.configuration.spec_settings[:telnet] == "false"
  ssids = test_profile[:ssids].split(',')

   context "Verify SSID in Array" do


      before :all do 
       
      expect(@array).to_not be_nil
        
      @telnet_session = @telnet_session || @array.telnet_session
        
      @ssid_output = @telnet_session.show_ssids

      log_data_response(ssids, @ssid_output)

      end
 
      include_examples "activate"
      
      ssids.each{|ssid|

        it "SSID #{ssid} is in Array" do
          output_line = @ssid_output.select{|line| line.gsub(16.chr,'').gsub("\u0010",'').start_with?("#{ssid} ")} 
          expect(output_line.length).to eql(1)
        end

      }


  end # context

end # unless telnet false


end # shared verify ssids






shared_examples "verify ssid bands" do |test_profile|
unless RSpec.configuration.spec_settings[:telnet] == "false"
   context "Verify SSID Bands" do

      before :all do 

        expect(@array).to_not be_nil
        @telnet_session = @telnet_session || @array.telnet_session
        @array_api_client = @array_api_client || @array.api_client

      end

      include_examples "activate"
  
      
        bands = test_profile[:ssid_bands]
        #@ssid_bands = { "pro4-1" => "5GHz", "pro4-2" => "2.4GHz", "pro4-3" => "2.4GHz"}
          bands.each{|key,value|
             it "SSID #{key} has band #{value}" do 
               output = @telnet_session.show_ssid(key)
               log_data_response(bands,output)
               verify_list(output,"Active Band #{value} only")
             end
          }
    

    end 
end 
end # verify ssid bands



shared_examples "verify vlan status and broadcast" do |test_profile|
unless RSpec.configuration.spec_settings[:telnet] == "false"
  vlans =  test_profile[:select_vlan] ? eval(test_profile[:select_vlan]) : nil
 
  broadcasts = test_profile[:broadcast_status] ? eval(test_profile[:broadcast_status]) : nil

  statuses  =  test_profile[:ssid_status] ? eval(test_profile[:ssid_status]) : nil


  context "Verify VLAN, SSID Status and Broadcast Status" do
   
    before :all do

      expect(@array).to_not be_nil
      if @array.model == "XR320"
        skip("NO XR320 Array Verification here yet..")
      else
        @telnet_session = @telnet_session || @array.telnet_session
        @array_api_client = @array_api_client || @array.api_client

      end
    end

      include_examples "activate"
      

      if vlans
     
        vlans.each{|key,value|
        
         it "VLAN in #{key} is #{value}" do 
           ssid_out = @telnet_session.show_ssid(key)
           log_data_response(vlans,ssid_out)
           verify_list(ssid_out,"VLAN Number  #{value}")
         end
        }
      end


      if statuses

        statuses.each{|key,value|
         status = value.downcase == "yes" ? "Enabled" : "Disabled"

         it "SSID #{key} Status/State is #{status}" do 
            ssid_out = @telnet_session.show_ssid(key)
            verify_list(ssid_out,"State   #{status}")
         
         end
           
        }
    
      end


      if broadcasts
      
        broadcasts.each{|key,value|
          broadcast = value.downcase == "yes" ? "On" : "Off"

          it "Broadcast for #{key} is #{broadcast}" do 

            expect(@telnet_session.config_ssid_show_ssid(key, "Broadcast   #{broadcast}")).to eql('Pass')

          end
        }

      end 
      
    
 
  end # main context
end
end # shared verify vlans, SSID status and Broadcast Status




shared_examples "basic profile integration" do |profile_test_setup|

  test_profile = profile_test_setup
  spec_settings = RSpec.configuration.spec_settings

  include_context "arrays"

  before :all do
    @profile = test_profile[:name]
    @dns = test_profile[:dns]
    @cdp = test_profile[:cdp]
    @mtu = test_profile[:mtu]
    @ntp = test_profile[:ntp]
    if @ntp
      @ntp_array = @ntp.split(',')
    end
    @ssids = test_profile[:ssids] # "Auto1,Auto2,Auto3,Auto4,Auto5,Auto6"
    @ssid_bands = test_profile[:ssid_bands] # { "Auto1" => "5GHz", "Auto2" => "2.4GHz" , "Auto3" => "2.4GHz"}
    @vlan_status = test_profile[:vlan_status] # "enable"
    @select_vlan = test_profile[:select_vlan] #  "{'Auto1'=>'10','Auto2'=>'500','Auto3'=>'2000'}"
    @ssid_status = test_profile[:ssid_status] # "{'Auto1'=>'No','Auto2'=>'No','Auto3'=>'Yes', 'Auto4'=>'No','Auto5'=>'No','Auto6'=>'Yes' }"
    @broadcast_status = test_profile[:broadcast_status] # "{'Auto1'=>'Yes','Auto2'=>'No','Auto3'=>'Yes','Auto6'=>'No'}"
    @admin_info = test_profile[:admin_info] # "Alex Janckila,alex.janckila@xirrus.com,444-888-1234"
    if @array  
      @admin_password = "yes,#{@array.password}"
      if @array.model == "XR320"
        # TODO
      else
        if !@use_telnet == false
          @telnet_session = @array.telnet_session
          @array_api_client = @array.api_client
        end
      end
    end
  end

  include_examples "create profile"

  if test_profile[:ntp]
    include_examples "configure ntp"
  end

  if (test_profile[:dns] || test_profile[:mtu] )
    include_examples "configure network"
  end

  if test_profile[:ssids]
    include_examples "create ssids"
  end

  if test_profile[:ssid_bands]
    include_examples "change ssid bands"
  end

  if test_profile[:select_vlan]
    include_examples "vlan, ssid status and broadcast status"
  end


  if spec_settings[:array_serial]

    context "Assign Array to Profile" do

      it "Assign Array to Profile" do
        sleep 2
        @browser.refresh
        sleep 10
        @ui.array_to_profile(@array.serial, @profile)
        sleep 1
        act_done = @telnet_session.activation_done?
        puts "activation done : #{act_done}"
      end
    end

    if (test_profile[:dns] || test_profile[:mtu] )

      include_examples "verify ntp and network", test_profile

    end

    if test_profile[:ssids]

      include_examples "verify ssids", test_profile
    end

    if test_profile[:ssid_bands]
      include_examples "verify ssid bands", test_profile
    end

    if test_profile[:select_vlan]
      include_examples "verify vlan status and broadcast", test_profile
    end



  end

end # shared basic profile ui integration





shared_examples "verify policy" do |type|

  type = eval(type)
 # puts "policy type: #{type}"
  name = "#{type["#{type.keys[0]}"][0]}"
  klass = "#{type["#{type.keys[0]}"][1]}"
  device_type = "#{type["#{type.keys[0]}"][2]}"

  context "Verify Policy in Array" do

    before :all do
      if @array.model == "XR320"
        skip("NO XR320 verifcation code here yet...")
      else
        if @telnet_session
        log("before verify rule")
        log(@telnet_session.cmd("show mem"))
        end
        @telnet_session.configure
        @telnet_session.cmd('filter')
        @policy = @telnet_session.show_policy(name)
      end
    end

    it "Policy #{name} in array" do 
      verify_list(@policy, "Filter List:  #{name},  State: enabled")
    end

  end 

end




shared_examples "verify policy rule" do |rules_string|
  if RSpec.configuration.spec_settings[:telnet] == true
    rules = eval(rules_string)# rules string then use eval to turn it into a hash
    # with one key and the value of that key is an array....

    internal_name = ''
    policy_name = rules.keys[0]
   
    policy_array = rules[policy_name]
    rule_type = policy_array[0]   
    name = policy_array[1]
    enable = policy_array[2]

    if rule_type == 'Application Control'
      puts "# #############"
      app_friendly_name = policy_array[3]
      puts "APP NAME: #{app_friendly_name}"
    end

    context "Verify Policy Rule" do 

      before :all do
        if @array.is_aos_light
          @ssh_session = @array.ssh_session
          @policies = @ssh_session.show_policies()
          @policy = @policies.select{ |p| policy_name.include?(p["name"]) }.first
          expect(@policy.nil?).to eql(false)

          if rule_type == 'Air Cleaner'
            @rules = @policy["filters"]["entries"].select{ |r| r["name"].include?("Air-cleaner-") }
            expect(@rules.empty?).to eql(false)
          else
            @rule = @policy["filters"]["entries"].select{ |r| name.include?(r["name"]) }.first
            expect(@rule.nil?).to eql(false)
          end

          log_data_response(rules_string, @policy)
          #skip("NO XR320 array verification code yet...")
        else
          @policy = @telnet_session.show_policy(policy_name)
          log_data_response(rules_string,@policy)
          @rule_line = @policy.select{|line| line.gsub("\u0010",'').gsub(16.chr,'').start_with?"#{name} "}.first
          expect(@rule_line.nil?).to eql(false)
          log(@rule_line)
          @rule_line_array = @rule_line.split(' ')
          @rule_line_array.each{|rl| log("Rule Line Item: #{rl.strip}")}
        end
      end

      case rule_type

        when 'Firewall'
          it "IP or MAC Address Match" do
            puts "firewall rule verification"

            # TODO should be changed, Both AOS and AOS light should be verified in the same way
            if @array.is_aos_light
              expect(@rule["source"]).to include(policy_array[7]) unless policy_array[7].nil?
              expect(@rule["destination"]).to include(policy_array[10]) unless policy_array[10].nil?
              expect(@rule["protocol"].downcase).to include(policy_array[4].downcase) unless policy_array[4].nil?
            else
              expect(@rule_line).to include(policy_array[7]) unless policy_array[7].nil?
              expect(@rule_line).to include(policy_array[10]) unless policy_array[10].nil?
            end
          end

        when 'Application Control'
          app_map = CSV.parse(File.open("#{XMS.fixtures_root}/data/csv/array_app_map.csv"))
          # ###########
          app_rows = app_map.select{ |row| row[1] == app_friendly_name.split(' ')[0] }
          clinames = app_rows.map{ |row| row[0]}
          #clinames = app_map

          it "Application Name #{app_friendly_name} Maps to App value in Array" do
            puts "Application Control rule verification"

            if @array.is_aos_light
              expect(@rule["name"]).to include(name)
              # TODO no specific expectations
            else
              expect((@rule_line_array & clinames).empty?).to eql(false)
            end
          end

        when 'Air Cleaner'
          it "Application Name #{app_friendly_name} Maps to App value in Array" do
            puts "Air Cleaner rule verification"

            if @array.is_aos_light
              expect(@rules.length).to eql(policy_array[1].to_i)
              # TODO
            else
              # TODO
            end
          end

        else
          # TODO
      end

    end # Context
  end # if telnet
end # verify policy rules


shared_examples "add and verify policy rule" do |policy_rule_string|

  rules = eval(policy_rule_string)# rules string then use eval to turn it into a hash
  # with one key and the value of that key is an array....
  # puts "rules: #{rules}"
  
  internal_name = ''
  policy_name = rules.keys[0]
  policy_array = rules[policy_name]
  rule_type = policy_array[0]   
  name = policy_array[1]
  enable = policy_array[2]
  #puts policy_rule_string
  
  context "Add Policy Rule" do

    it "Add #{rule_type} Rule - #{name} - #{policy_array[3]}" do
      if @telnet_session
        log("before add rule")
        log(@telnet_session.cmd("show mem"))
      end
      sleep 5
      @browser.refresh
      sleep 15
      @ui.get(:div, {id: "profile_config_policies"}).wait_until_present
      @page.add_rule policy_rule_string
      sleep 2
      #@browser.div(:id => 'new_rule_modal').wait_while_present
      pcv.save_all
      sleep 5
    end

    include_examples "activate"

  end

  if (RSpec.configuration.spec_settings[:array_serial] && (RSpec.configuration.spec_settings[:telnet] == true) )

    include_examples "verify policy rule", policy_rule_string

  end
 

end

shared_examples "add and verify policy rule with screenshots" do |policy_rule_string|

  rules = eval(policy_rule_string)# rules string then use eval to turn it into a hash
  # with one key and the value of that key is an array....
  # puts "rules: #{rules}"

  internal_name = ''
  policy_name = rules.keys[0]
  policy_array = rules[policy_name]
  rule_type = policy_array[0]   
  name = policy_array[1]
  enable = policy_array[2]

  context "Add Policy Rule - with screenshots" do

    it "Add #{rule_type} Rule - #{name} - #{policy_array[4]}" do
      if @telnet_session
        log("before add rule")
        log(@telnet_session.cmd("show mem"))
      end

      sleep 5
      @browser.refresh
      sleep 15
      @ui.get(:div, {id: "profile_config_policies"}).wait_until_present
      @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{policy_name}_#{name}_before_add_rule.png")
      @page.add_rule policy_rule_string
      sleep 1
      @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{policy_name}_#{name}_after_add_rule.png")
      @browser.div(:id => 'new_rule_modal').wait_while_present
      pcv.save_all
      sleep 1
      @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{policy_name}_#{name}_after_save_add_rule.png")
      sleep 5
    end

    include_examples "activate"

  end

  
  if (RSpec.configuration.spec_settings[:array_serial] && (RSpec.configuration.spec_settings[:telnet] == true) )
    include_examples "verify policy rule", policy_rule_string
  end
 

end






shared_examples "verify ssid encryption" do |ssid , args|

  context "Verify SSID: '#{ssid}' Encryption Settings" do

    before :all do 
      @ssid_output = @telnet_session.show_ssid(ssid)
      log_data_response(args,@ssid_output)
    end
 

   it "Verify Cipher TKIP/AES" do
     cipher = "Cipher  "
     if args[:encrypt_type] == "aes"
      cipher += "TKIP Off, AES  On"
     elsif args[:encrypt_type] == "tkip"
      cipher += "TKIP On, AES  Off"
     else

     end
     verify_list(@ssid_output,cipher)
   end

 if args[:auth_type] == "psk"
   it "PSK Passphrase Set" do
    psk_line = @ssid_output.select{|line| line.gsub("#{16.chr}",'').gsub("\u0010",'').start_with?"PSK Passphrase"}.first
    expect(psk_line).to include("Set")
   end
 end

 unless args[:auth_type] == "psk"
   it "Verify Primary Server" do 

     verify_list(@ssid_output,"Primary Server  #{args[:host]}")

   end

    
   it "Verify Primary Port" do 

     verify_list(@ssid_output,"Primary Port  #{args[:port]}")

   end


   it "Verify Primary Secret" do 

     if args[:share]
      verify_list(@ssid_output,"Primary Secret  Set")
     end

   end

  end # context


  if args[:add_secondary]

   it "Verify Secondary Server" do 

     verify_list(@ssid_output,"Secondary Server  #{args[:secondary_host]}")

   end

    
   it "Verify Secondary Port" do 

     verify_list(@ssid_output,"Secondary Port  #{args[:secondary_port]}")

   end

   if args[:secondary_share]
    it "Verify Secondary Secret" do 

     
      verify_list(@ssid_output,"Secondary Secret  Set")
    
    end
  end

      #add_secondary: true,
      #secondary_host: "11.11.11.11",      
      #secondary_port: "1812",
      #secondary_share: "123456",
      #secondary_share_confirm: "123456",
      #accounting: true,
      #alternate_accounting: true,
      #primary_accounting_host: "13.13.13.13",      
      #primary_accounting_port: "1812",
      #primary_accounting_share: "123456",
      #primary_accounting_share_confirm: "123456",
      #secondary_accounting: true,
      #secondary_accounting_host: "19.19.19.19",      
      #secondary_accounting_port: "1812",
      #secondary_accounting_share: "123456",
      #secondary_accounting_share_confirm: "123456",
      #accounting_radius_interval: "330"

  end # unless PSK



  end

end # shared ssid encryption


shared_examples "set ssid encryption" do |ssid, encryption_args, options = {}|

  it "Change Encryption/Auth for SSID #{ssid} " do
          sleep 2
          @browser.refresh 
          sleep 15

          profile_config_view = @ui.profile_config_view
         
          
          if options[:screenshots] == true
           @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{ssid}_before_change_encryption.png")
          end
          profile_config_view.ssid_grid_view.row(ssid).change_encryption(encryption_args[:auth_option], args = encryption_args) 
              
          if options[:screenshots] == true    
            @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{ssid}_after_change_encryption.png")
          end


          @ui.get(:div, {css: ".modal-overlay" }).wait_while_present
          @ui.get(:div, {id: "ssid_encrypt_auth_modal"}).wait_while_present
          @ui.profile_config_view.save_all
          sleep 1
          if options[:screenshots] == true
            @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{ssid}_after_save_change_encryption.png")
          end
          sleep 5
          @browser.refresh 
          sleep 15

  end
  
end


shared_examples "set ssid encryption v2" do |ssid, encryption_args, options = {}|

  it "Change Encryption/Auth for SSID #{ssid} " do
          sleep 2
          @browser.refresh 
          Watir::Wait.until(10,"Wait up to 10 seconds after refresh for profile_config_view before change_encryption"){ @ui.profile_config_view.present? }
          profile_config_view = @ui.profile_config_view
          profile_config_view.ssids_tile.wait_until_present
          profile_config_view.ssids_tile.click


          if options[:screenshots] == true
           @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{ssid}_before_change_encryption.png")
          end


          profile_config_view.ssid_grid_view.row(ssid).change_encryption(encryption_args[:auth_option], args = encryption_args) 
              
          if options[:screenshots] == true    
            @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{ssid}_after_change_encryption.png")
          end


          @ui.get(:div, {css: ".modal-overlay" }).wait_while_present
          @ui.get(:div, {id: "ssid_encrypt_auth_modal"}).wait_while_present
          profile_config_view.save_all
          sleep 1
          if options[:screenshots] == true
            @browser.screenshot.save("#{RSpec.configuration.spec_settings[:out_path]}_#{ssid}_after_save_change_encryption.png")
          end
          sleep 5
          @browser.refresh 
          Watir::Wait.until(10,"Wait up to 10 seconds after refresh for profile_config_view before change_encryption"){ @ui.profile_config_view.present? }

  end
  
end



shared_examples "set and verify ssid encryption" do |ssid,  encryption_args, options = {}|

   context "SSID Encryption Test" do

      include_examples "set ssid encryption", ssid, encryption_args, options

      if (RSpec.configuration.spec_settings[:array_serial] && (RSpec.configuration.spec_settings[:telnet] == true) )

      include_examples "activate"
     
      include_examples "verify ssid encryption", ssid, encryption_args

      end

   end

end # shared examples set and verify ssid encryption





shared_examples "verify software image" do |version, build|
   
   context "Software Image" do 

     before :all do 
       expect(@array).to_not be_nil
       @telnet_session = @telnet_session || @array.telnet_session
       @telnet_session.cmd('configure')
       @software_output = @telnet_session.cmd('show software-image')
       @version_line = @software_output.select{|line| line.start_with?"Current"}.first
     end


     it "Version is #{XMS.config[:aos]}" do 

       expect(@version_line).to include("version: #{version}")

     end


     it "Build is #{XMS.config[:aos_build]}" do 

       expect(@version_line).to include("Build: #{build}")

     end

   end
end # verify software image



shared_examples "set activation interval" do 

   it "set activation interval" do 
     
     @telnet_session.top
     @telnet_session.configure
     @telnet_session.cmd('activation stop')
     @telnet_session.cmd("activation interval #{@activation_interval}")
     @telnet_session.cmd('save')
     @telnet_session.cmd('activation start')
     @telnet_session.management
     output = @telnet_session.show
     expect(output[39]).to include("#{@activation_interval} minute")

   end

end
 

shared_examples "activation reset" do
 it "Activation Cycle" do 

    sleep 5
    @telnet_session.top
    @telnet_session.configure
   # @telnet_session.cmd("activation stop")
   # sleep 15
   # @telnet_session.cmd("activation start")
    sleep 150
  end
end


shared_examples "Stop AOS array cloud and activation" do
  it "Stop Activation" do
    @telnet_session.top
    @telnet_session.configure
    @telnet_session.management
    @telnet_session.cmd('cloud off')
    @telnet_session.cmd('activation stop')
    @telnet_session.cmd('save')
  end
end

shared_examples "Start AOS array cloud and activation" do
  it "Start Activation" do
    @telnet_session.activate(@env)
  end
end


shared_examples "activate" do
  if (RSpec.configuration.spec_settings[:array_serial] && (RSpec.configuration.spec_settings[:telnet] == true) )

    it "Activation Cycle" do
      @session = @array.is_aos_light ? @array.ssh_session : @array.telnet_session
      is_activated = @session.activation_done?
      puts "Act Done : #{is_activated}"
      expect(is_activated).to eql(true)
    end

  end
end # shared activate

shared_examples "move to unassigned" do 

    it "Move to Unassigned Access Points" do 
       sleep 2
       @browser.refresh
       sleep 15
       @ui.id("header_mynetwork_link").wait_until_present
       @ui.id("header_mynetwork_link").click
       @ui.id("mynetwork_tab_arrays").wait_until_present
       @ui.id("mynetwork_tab_arrays").click
       sleep 2
       @ui.array_grid.wait_until_present
       # 
       @ui.array_grid.row(@array.serial).wait_until_present
       row = @ui.array_grid.row(@array.serial)

       row.select_column.label.click
       sleep 2
       @ui.id("mynetwork_arrays_moveto_btn").wait_until_present
       @ui.id("mynetwork_arrays_moveto_btn").click
       sleep 2
       @browser.nav(css: '.move_to_nav.drop_menu_nav').wait_until_present
       unassigned_item = @browser.nav(css: '.move_to_nav.drop_menu_nav').div(css: ".items").a(text: "Unassigned Access Points")
       unassigned_item.wait_until_present
       unassigned_item.click
       sleep 2
       confirm_modal = @ui.div(css: ".dialogBox.confirm")
       expect(confirm_modal.text).to include("Assign Access Points?")
       buttons = confirm_modal.div(id: "confirmButtons")
       buttons.links[1].click
       sleep 1

     end

end

shared_examples "get application map" do |policy, rule|
      it "Get Application Map" do 

        @telnet_session.configure
        @telnet_session.cmd('no more')
        @telnet_session.cmd('filter')
        @telnet_session.cmd('edit-list "#{policy}"')
       # @telnet_session.cmd('show')
        app_array = @telnet_session.cmd("edit #{rule} application ?")
        CSV.open("#{Dir.pwd}/app_map.csv", "a") do |file|
        app_array.each_with_index{|app_line,index|
         
          ar = app_line.split(" ")
          unless (index < 3 || ar[0].nil? || ar[1].nil?)
            file << [ar[0].strip, ar[1].strip]
          end
         }
       end
      end
end

shared_examples "assign and monitor array activation" do 

  it "assign array to different profile" do 
    
    goto_profile(@profile)
    @page = UserPage.new(@browser)
    @page.goto_tab "Access Points"
    sleep 3

    @page.add_arrays "#{@from_profile},#{@array_serial}"
    @browser.close
  end

  it "start activation" do 
    status = 0
    array = array_telnet_session(ARRAY_IP, ARRAY_USER, @from_profile_password)
    array.cmd('configure') { |c| print c }
    array.cmd('no more') { |c| print c }
    array.cmd('configure') { |c| print c }
    array.cmd('management') { |c| print c }
    output = array.cmd('show') {|c| print c}
    output = output.split(/\n/)
    if output[ACTIVATION_STATUS_INDEX.to_i].match(/(.*)Activation          running(.*)/)
      status = 'Pass'
    end
    status.should == 'Pass'
    sleep 1100
    array.close

  end

  
end


shared_examples "verify basic array configurations" do 

  
    
  before :each do
    @telnet_session.top
  end


  it 'verify cloud settings' do
    
    if @telnet_session.show_management[CLOUD_STATUS_INDEX.to_i].match(/(.*)Cloud   Management  enabled(.*)/)
      status = 'Pass'
    end
    status.should == 'Pass'
    
  end


  it 'verify DNS settings' do
       
    if @telnet_session.show_dns[6].match(/(.*)Server 1            #{DNS_SERVER_1}(.*)/)
      status = 'Pass'
    end
    status.should == 'Pass'
   
  end


  it 'verify contact information' do
    output = @telnet_session.show_contact_info
    
    #output[5].should include("Office")
    output[6].should include(@admin_info[0])
    output[7].should include(@admin_info[1])

 #   output[5].match(/(.*)Array Location      Office(.*)/).should be_true  
    output[6].match(/(.*)Contact Name        #{@admin_info[0]}(.*)/).should be_true 
    output[7].match(/(.*)Contact E-Mail      #{@admin_info[1]}(.*)/).should be_true      
  
  end


  it 'verify ntp settings' do

    @telnet_session.configure
    @telnet_session.cmd('show clear-text')
    @telnet_session.cmd('date-time') 
    output = @telnet_session.show  

    output[9].should include(@ntp[1])
    output[10].should include(@ntp[2])
    output[11].should include(@ntp[3]) 
    output[12].should include(@ntp[4]) 
    # @ntp[5] is not checked, it is used as a parameter in the profile UI test
    output[13].should include(@ntp[6]) 
    output[14].should include(@ntp[7]) 
    output[15].should include(@ntp[8]) 
    output[16].should include(@ntp[9])  

    output[9].match(/(.*)NTP Primary server                 #{@ntp[1]}(.*)/).should be_true
    output[10].match(/(.*)NTP Primary server auth            #{@ntp[2]}(.*)/).should be_true
    output[11].match(/(.*)NTP Primary server auth key ID     #{@ntp[3]}(.*)/).should be_true 
    output[12].match(/(.*)NTP Primary server auth key        #{@ntp[4]}(.*)/).should be_true 
    output[13].match(/(.*)NTP Secondary server               #{@ntp[6]}(.*)/).should be_true 
    output[14].match(/(.*)NTP Secondary server auth          #{@ntp[7]}(.*)/).should be_true 
    output[15].match(/(.*)NTP Secondary server auth key ID   #{@ntp[8]}(.*)/).should be_true 
   # output[16].match(/(.*)NTP Secondary server auth key      #{@ntp[9]}(.*)/).should be_true

       
   
  end



  it 'verify cdp settings' do
   
    output = @telnet_session.cmd('show cdp')

    output[5].should include(@cdp[1])
    output[6].should include(@cdp[2]) 

    output[5].match(/(.*)Interval            #{@cdp[1]}  seconds(.*)/).should be_true
    output[6].match(/(.*)Hold time           #{@cdp[2]} seconds(.*)/).should be_true
      
      
  end



  it 'verify mtu settings' do
    
    output = @telnet_session.cmd('show ethernet') 
    output[7].should include(" #{@mtu} ")
   
  end



  it 'verify aos version' do
   
   
    output = @telnet_session.show_software_image
    position = [2]
    expect = [@aos_expect]

    for i in 0..position.length-1

      if output[position[i]].match(/(.*)#{expect[i]}(.*)/)
        status = 'Pass'
      else
        status = 'Fail'
        puts "Fail: Not able to match #{output[position[i]]} with #{expect[i]} "
        break
      end

    end

    status.should == 'Pass'
    
  end

 

end # shared_examples verify


shared_examples "Verify Array Activation Status via API" do |data|
  it "Check Activation status to be #{data[:status]}" do
    number_of_attempts = 0
    done = false
    while (number_of_attempts <= data[:number_of_attempts] && !done) do
      res = @ng.global_by_serial(@array.serial)
      if (res.body["xirrusArrayDto"]["onlineStatus"] == data[:status])
        done = true
      end

      number_of_attempts = number_of_attempts + 1
      puts "Activation status: #{res.body["xirrusArrayDto"]["onlineStatus"]}.  attempt: #{number_of_attempts}. wait 20 seconds..."
      sleep 20
    end

    expect(done).to be true
  end
end

shared_context "Check 'Get /arrays.json/global' sorting option" do |property|
  context "Check sorting for Array Type: #{property[:type]}" do
    before :all do
      puts "Select API/Get /arrays.json/global - List Arrays for all Tenants"
      puts "Choose 'sortBy = #{property[:name]}'. Try it out"
      @list_arrays_for_all_tenants = @ng.list_arrays_for_all_tenants({sortBy: property[:name]}).data.map{|ap| ap["xirrusArrayDto"]}

      helper_cleanup_for_sortOrder(property)
    end

    it "Check by serial number that arrays are found and listed in sorted order in multiple tenant" do
      is_ascending = XMS::Utilities.is_array_ascending_by?(property[:value], @list_arrays_for_all_tenants)
      expect(is_ascending).to be(true)
    end

    it "Change sortOrder by 'desc'. And Verify that sorted in descending order" do
      @list_arrays_for_all_tenants = @ng.list_arrays_for_all_tenants({sortBy: property[:name], sortOrder: "desc"}).data.map{|ap| ap["xirrusArrayDto"]}

      helper_cleanup_for_sortOrder(property)

      is_ascending = XMS::Utilities.is_array_descending_by?(property[:value], @list_arrays_for_all_tenants)
      expect(is_ascending).to be(true)
    end
  end
end

shared_context "Check 'GET /tenants.json/{tenantId}/arrays' sorting option" do |property|
  context "Check sorting for Array Type: #{property[:type]}" do
    before :all do
      puts "Select API/GET /tenants.json/{tenantId}/arrays - List Arrays for specific Tenants"
      puts "Choose 'sortBy = #{property[:name]}'. Try it out"
      @list_arrays_for_all_tenants = @ng.arrays_for_tenant(@tenant_id, {sortBy: property[:name]}).data

      helper_cleanup_for_sortOrder(property)
    end

    it "Check by serial number that arrays are found and listed in sorted order in multiple tenant" do
      is_ascending = XMS::Utilities.is_array_ascending_by?(property[:value], @list_arrays_for_all_tenants)
      expect(is_ascending).to be(true)
    end

    it "Change sortOrder by 'desc'. And Verify that sorted in descending order" do
      @list_arrays_for_all_tenants = @ng.arrays_for_tenant(@tenant_id, {sortBy: property[:name], sortOrder: "desc"}).data

      helper_cleanup_for_sortOrder(property)

      is_ascending = XMS::Utilities.is_array_descending_by?(property[:value], @list_arrays_for_all_tenants)
      expect(is_ascending).to be(true)
    end
  end
end

# TODO move to proper place
def helper_cleanup_for_sortOrder(property)
  # Remove all AP s with "_" in case of 'arrayModel' name
  if property[:value] == "arrayModel"
    @list_arrays_for_all_tenants = @list_arrays_for_all_tenants.reject {|ap| ap[property[:value]].include?("_")}
  end
  # Remove All undefined values
  @list_arrays_for_all_tenants = @list_arrays_for_all_tenants.reject {|ap| ap[property[:value]].nil?}
end