################################################################################################################
##############TEST CASE: Profile Configuration Policy Scheduling#############################################
################################################################################################################

describe "*************TEST CASE: Profile Configuration Policy Scheduling*************" do
  #veriable used duding test
  profile_name = UTIL.random_building_title
  test_profile = {  
    name: profile_name,    
    ssids: "tagA,tagB",
    ssid_bands: { "tagA" => "2.4GHz", "tagB" => "5GHz"},
    vlan_status: "enable",
    ssid_status: "{'tagA'=>'Yes','tagB'=>'Yes'}",
    broadcast_status: "{'tagA'=>'Yes','tagB'=>'No'}"  
    }

  before :all do
    @profile = test_profile[:name]  
    test_profile_setup(test_profile)    
    @profile_config = @ng.get_profile_configuration(profileId: @profile_id).body
    expect(@profile_config['ssids'].length).to eql(@ssids.length)
    
    @serial = @array.serial
    @ssid_policy = @ssids[0].dup
    @each_sleep = 1
    @firewall_rule_name = XMS.random_title[0..19]
    @app_rule_name = XMS.random_title[0..19]
  end    

  context "*******Schedule Policy and Rules***********" do 
    
    it "API - Create Policy" do 
      profile_config = @ng.get_profile_configuration(profileId: @profile_id).body
      ssidId = profile_config['ssids'].select{|ssid| ssid['ssidName'] == @ssids[0]}.first['id']
      new_policy = { policyType: "SSID", name: @ssid_policy , ssidId: ssidId }
      expect(profile_config['policies'].length).to eql(1)
      profile_config['policies'] << new_policy
      #puts profile_config.to_json
      add_ssid_policy = @ng.update_profile_configuration(@profile_id, profile_config)
      expect(add_ssid_policy.code).to eql(200)
      sleep 2
      updated_policies_config = @ng.get_profile_configuration(profileId: @profile_id).body["policies"]
      expect(updated_policies_config.length).to eql(2)
      # filter global policy
      updated_policies_config.reject! { |c| c["name"] == "Global Policy" }
      expect(updated_policies_config[0]['name']).to eql(@ssid_policy)
      sleep 3
    end

    it "API - Add Firewall Rule to Policy" do 

      existing_config = @ng.get_profile_configuration(profileId: @profile_id).body
      existing_config_policies = existing_config['policies']
      
      update_policies = existing_config_policies.clone
      
      new_rule = XMS.load_json("#{XMS.nfixtures_root}/json/profiles/firewall_rule.json")

      new_rule['name'] = @firewall_rule_name
      update_policies.each{|policy|
        
        if (policy['name'] == @ssid_policy )
          policy['rules'] << new_rule
          break
        end
      }
     
      existing_config['policies'] = update_policies
      add_policy_rule_res = @ng.update_profile_configuration(@profile_id, existing_config)
      sleep 2
      updated_config = @ng.get_profile_configuration(profileId: @profile_id)
      #puts updated_config.pretty_json

    end


     it "API - Add Application Rule to Policy" do 
      existing_config = @ng.get_profile_configuration(profileId: @profile_id).body
      existing_config_policies = existing_config['policies']
      
      update_policies = existing_config_policies.clone
      
      new_rule = XMS.load_json("#{XMS.nfixtures_root}/json/profiles/app_rule.json")

      new_rule['name'] = @app_rule_name

      update_policies.each{|policy|
        
        if (policy['name'] == @ssid_policy )
          policy['rules'] << new_rule
          break
        end
      }
     
      existing_config['policies'] = update_policies
      add_policy_rule_res = @ng.update_profile_configuration(@profile_id, existing_config)
      sleep 2
      updated_config = @ng.get_profile_configuration(profileId: @profile_id)
      #puts updated_config.pretty_json

    end

    context "UI - Set Schedule on Policy" do 

      before :all do 
        @policy_name = @ssid_policy
        @ui.goto_policies(@profile)
        sleep 3
        @days = [1,2,3,4,5] # M,W
        @start_time = "7:30am"
        @end_time = "3:00pm"
        @rule_start = "12:00pm"
        @rule_end = "1:00pm"
        @rule_days = [1,2,3]
      end

     
      it "Set Schedule on Policy" do 
        policy_schedule = @ui.set_policy_schedule(@policy_name,@days,@start_time,@end_time)
        #puts policy_schedule
      end


      it "Set Firewall Rule Schedule on Policy" do 
        @browser.refresh
        sleep 8
        rule_schedule = @ui.set_rule_schedule(@policy_name, @firewall_rule_name, @rule_days, @rule_start, @rule_end)
        #puts rule_schedule
        @ui.policy_schedule_modal.wait_while_present
      end

      it "Set Application Rule Schedule on Policy" do 
        @browser.refresh
        sleep 8
        rule_schedule = @ui.set_rule_schedule(@policy_name, @app_rule_name, @rule_days, @rule_start, @rule_end)
        #puts rule_schedule
      end


      context "AP(Telnet) Verify" do

        before :all do 
          api_assign_array(@profile_id, @serial)
          sleep 2
          @telnet_session = @array.telnet_session
        end

        after :all do 
          @telnet_session.top 
          @telnet_session.cmd('exit')
          #@telnet_session.close
        end

        # include_examples "activate"



        it "Check SSID Time on/off and Days" do
          time_settings = @telnet_session.ssid_time_settings(@ssid_policy)
          
          ### Removing '0' at beginning of am times here (CLI show SSID does not have it, CLI show policy filter does)

          expect(time_settings[0]).to eql(XMS.to_24hour(@rule_start))

          expect(time_settings[1]).to eql(XMS.to_24hour(@rule_end))
          @days.each {|day|

            dayName = @rule_days.map{|day_num| Date::DAYNAMES[day_num%7]}

            expect(time_settings[2]).to include(dayName[0][0..2]) or include(dayName[1][0..2]) or include(dayName[2][0..2])
          }
        end


        it "Check Policy Rules(Filters) Scheduling" do 
          show_policy_output = @telnet_session.show_policy(@ssid_policy)

          firewall_rule_settings = show_policy_output.get_line(@firewall_rule_name)

          @rule_days.each { |day_int|
            
            expect(firewall_rule_settings.include?(@firewall_rule_name)).to be true
          }

        end

      end # AP(Telnet) Verify

    
    end # UI schedule SSID Policy 

  end # SSID policy and rules
 
  context "Clean Up" do 

    it "Delete Test Profile" do
      
      @ng = @ng || ngapi
        
      puts @ng.delete_profile(@profile_id).body
      
    end

  end

end