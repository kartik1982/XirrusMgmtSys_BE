## 
# all of these shared examples assume a '@profile' instance variable in the before :all block of test for the profile - see /spec/profiles_regression_spec.rb

shared_examples "create profile" do
   
    it "Create Profile from Header Button" do
  
      @ui.id("header_left_nav").span(text:"Profiles").click
      header_btn = @ui.get(:element,{id: "header_new_profile_btn"})
      header_btn.wait_until_present
      header_btn.click
      sleep 1
      @ui.set_text_field_by_id("profile_name_input", @profile )
      nb = @ui.get(:button,{id: "newprofile_create"})
      nb.wait_until_present
      nb.click
      sleep 5
      @browser.refresh
      sleep 15
      expect(@browser.text).to include( @profile )
      @ui.profile_config_view.save_all
    end
  
end


shared_examples "create read only profile" do |profile_hash|
  name = profile_hash[:name]
  description = profile_hash[:description] || "Read Only Profile Createdin RSpec shared examples"

  it "Create Read Only Profile" do 

    @ui.id("header_left_nav").span(text:"Profiles").click
    header_btn = @ui.get(:element,{id: "header_new_profile_btn"})
    header_btn.wait_until_present
    header_btn.click
    sleep 1
    new_profile_modal = @ui.id("profiles_newprofile")

    @ui.set_text_field_by_id("profile_name_input", name )
    description_textarea = @ui.textarea(id: "guestprofile_new_description_input")
    description_textarea.send_keys description

    show_advanced_link = new_profile_modal.a(text: "Show Advanced")
    show_advanced_link.click
    sleep 1

    @ui.ng_toggle_set("profile_readonly_switch_switch", true)
    sleep  1
  
    nb = @ui.get(:button,{id: "newprofile_create"})
    nb.wait_until_present
    nb.click
    sleep 5
    @browser.refresh
    sleep 15
    expect(@browser.text).to include( name )
    # expect only two tabs Arrays and Clients NO Configuration tab

    tabs = @browser.element(id: "profile_tabs").links
    expect(tabs.length).to eql(2)
    expect(tabs[0].attribute_value("id")).to eql("profile_tab_arrays")
    expect(tabs[1].attribute_value("id")).to eql("profile_tab_clients")
  end

end # create read only profile



shared_examples "create profiles" do |array_of_new_profile_names|

  array_of_new_profile_names.each do |name|
   
    it "Create Profile '#{name}' from Header Button" do
  
      @ui.id("header_left_nav").span(text:"Profiles").click
      header_btn = @ui.get(:element,{id: "header_new_profile_btn"})
      header_btn.wait_until_present
      header_btn.click
      sleep 1
      @ui.set_text_field_by_id("profile_name_input", name )
      nb = @ui.get(:button,{id: "newprofile_create"})
      nb.wait_until_present
      nb.click
      sleep 5
      @browser.refresh
      sleep 15
      expect(@browser.text).to include( name )
      @ui.profile_config_view.save_all
      
    end

  end
  
end

shared_examples "default profile network settings" do |profile_name|

  it "turn DHCP off" do 

    goto_profile(profile_name)
    sleep 3
    @ui.get(:div, {id: "profile_config_container"}).wait_until_present
    @ui.get(:ul, {id: "profile_config_tabs"}).wait_until_present
    
    network_tile = @ui.profile_config_view.tile("network")
    network_tile.wait_until_present
    network_tile.click
    @browser.div(text: "DNS (Domain Name System)").wait_until_present
   
    @ui.profile_config_view.set_network_ip_address_settings("set")
    @ui.profile_config_view.save_all
  end


  it "Set DNS Settings" do 
    @browser.execute_script('$("#suggestion_box").hide()')
    @ui.profile_config_view.set_dns
    @ui.profile_config_view.save_all
  end


end




shared_examples "delete profile" do |profile_name|

  context "Delete Profile #{profile_name}" do 

      before :all do 
       # @array = build(array_serial)
        @profile = profile_name
        goto_profile(@profile)
      end

    
      include_context "profiles"
    
    
      it "Click delete profile option in settings dropdown" do
          @ui.id("profile_menu_btn").wait_until_present
          @ui.id("profile_menu_btn").click
          sleep 1

          btn = @browser.a(text: "Delete Profile")
          btn.wait_until_present
          btn.click
          sleep 1
      end



      it "Confirm Delete Profile?" do 
          @ui.div(css: ".dialogBox.confirm").wait_until_present
          confirm_modal = @ui.div(css: ".dialogBox.confirm")
          confirm_modal.span(text: "Delete Profile?").wait_until_present
       
          @ui.div(id: "confirmButtons").wait_until_present
          @ui.div(id: "confirmButtons").a(text: "Cancel").wait_until_present
          @ui.div(id: "confirmButtons").links[1].click
         # @browser.a(text: "DELETE PROFILE").wait_until_present
         # @browser.a(text: "DELETE PROFILE").click
         # sleep 2
      end

   
    
      it "Verify does not have a tile in the UI" do
          view_all_profiles
          sleep 2
          expect(@ui.span(text: @profile)).to_not be_present
      end


  end

end







shared_examples "configure ntp" do

  context "NTP" do

    before :all do
      @browser.refresh
      sleep 15
      goto_profile(@profile)
      sleep 5
      @ui.id("profile_config_container").wait_until_present
      @ui.id("profile_config_tabs").wait_until_present
      
      tile = @ui.profile_config_view.tile("general")
      tile.wait_until_present
      tile.click
      @browser.div(text: "Give your profile a name and description.").wait_until_present

    end

   it "Configure NTP" do 
    
      @page.config_ntp @ntp
      sleep 8
      @ui.profile_config_view.save_all
      sleep 5
   end

  end

end

######################################
#
#  CONFIGURE NETWORK
#
# Set, DNS, CDP, MTU and NTP

shared_examples "configure network" do

  context "Network Tile - DNS, CDP, MTU" do

    before :all do
      @browser.refresh
      sleep 15
      goto_profile(@profile)
      sleep 10
      @ui.get(:div, {id: "profile_config_container"}).wait_until_present
      @ui.get(:ul, {id: "profile_config_tabs"}).wait_until_present
      
      network_tile = @ui.profile_config_view.tile("network")
      network_tile.wait_until_present
      network_tile.click
      @browser.div(text: "DNS (Domain Name System)").wait_until_present
    end

    before :each do
      sleep 5
    end

    after :all do
      sleep 10
     
    end

    
   it "UI - DHCP to 'Set on Array'" do 

     @ui.profile_config_view.set_network_ip_address_settings(dhcp_option = "set")
     @ui.profile_config_view.save_all
   end

   it "UI - DNS set Domain and servers" do 
     if @dns.nil?
       skip("DNS not defined for this test")
     else
      dns_domain = "xirrus.com"
      dnses = @dns.split(',')
      server1 = false
      server2 = false
      server3 = false
      if dnses[0]
        server1 = dnses[0] 
      end
      if dnses[1]
        server2 = dnses[1] 
      end
      if dnses[2]
        server3 = dnses[2] 
      end
      @ui.profile_config_view.set_dns({domain: dns_domain, server1: server1, server2: server2, server3: server3})
      @ui.profile_config_view.save_all
    end 
   end

   it "Configure CDP" do 
    if @cdp.nil?
      skip("NO CDP Defined for this test")
    else
     @page.network_cdp @cdp 
     @ui.profile_config_view.save_all
    end
   end

   it "Configure MTU" do 
     @page.network_mtu @mtu
     @ui.profile_config_view.save_all
    
   end


  
   it "Verify CDP, MTU" do 

    dns_as_array = @dns.split(',')
    unless @cdp.nil?

     cdp_as_array = @cdp.split(',')

     if @cdp[0].strip == 'yes'
       @ui.get(:input, {id: "profile_config_network_cdpinterval"}).value.should eq(cdp_as_array[1].strip)
       @ui.get(:input, {id: "profile_config_network_cdphldtime"}).value.should eq(cdp_as_array[2].strip)
     end
    end
      @ui.get(:input, {id: "profile_config_network_mtu"}).value.should eq(@mtu)
   end

  end # describe DNS, NTP, Network 
end # shared network


#########################################
#
#  Create SSIDs
#
#  @params = comma delimited lsit of ssid names to create
# 'auto1, auto2, auto3'
#
#  will first check the profile in context that none of the ssids exist
#  then will create each ssid, save then refresh the browser and check that the ssids are there

shared_examples "create ssids" do 

  context "create SSIDs" do 

    before :each do
     
      @ui.fresh_ssid_grid_by_profile(@profile)
      @ui.profile_config_view.ssid_grid.wait_until_present      
    end   
  
    after :each do
      sleep 3      
    end

    let(:pcv){@ui.profile_config_view}

    it "Create SSIDs" do 
       
      pcv.ssids_tile.click
      pcv.ssid_grid_view.el.wait_until_present
      sleep 1
      @ssids.split(',').each { |ssid|
   
        pcv.ssid_grid_view.el.text.should_not include(ssid)

        sleep 1
      }

      @ui.add_ssid @ssids 
      sleep 3
      pcv.save_all

      sleep 10
      @browser.refresh
      sleep 15

      pcv2 = @ui.profile_config_view
      pcv2.ssids_tile.wait_until_present

      @ssids.split(',').each { |ssid|
      
        pcv2.ssid_grid_view.el.text.should include(ssid)
      
      }

    end # create x SSIDS...

  end # end describe create ssid

end # end shared create ssid

#################################
#
#  SSID Change Bands
#
# 

shared_examples "change ssid bands" do 

  describe "change ssid bands" do 
    
    before :each do
      @browser.refresh
      sleep 4
      @ui.fresh_ssid_grid_by_profile(@profile)
      sleep 2
      @ui.profile_config_view.ssid_grid.wait_until_present      
    end   
  
    after :each do
      sleep 3      
    end

    let(:pcv){@ui.profile_config_view}

    it "change ssid bands" do

      @ssid_bands.each { |ssid, band|

        @ui.profile_config_view.ssid_grid_view.wait_until_present

        row = @ui.profile_config_view.ssid_grid_view.row(ssid).change_band(band)
        pcv.save_all 
        sleep 4
        @browser.refresh
        sleep 5
      }

      #pcv.save_all 

      #sleep 5
      

      @ui.fresh_ssid_grid_by_profile(@profile)

      pcv2 = @ui.profile_config_view 
      pcv2.ssid_grid.wait_until_present

      @ssid_bands.each { |ssid, band|

        pcv2.ssid_grid_view.row(ssid).band.should eq(band)

      }      

    end
  end # describe change bands

end # shared change bands

##################################
#
#
#  VLAN status
#
#

shared_examples "vlan, ssid status and broadcast status" do 
  describe "vlan, ssid status and broadcast status" do 
    
        include_context "vlan hooks"

        it "Enable VLAN" do
        
          @page.change_vlan_status(@vlan_status) # needs to be defined in let block in profile[x]_spec
         # pcv.save_all
          sleep 2
        
        end

        it "Select Vlan Status - Contingent on select VLAN status being enabled" do

         unless @vlan_status.nil?
          @page.select_vlan @select_vlan
         # pcv.save_all
          sleep 2
         end       

        end
  
        it "Set SSID statuses - enabled = Yes/No" do
        
          @page.ssid_status @ssid_status
         # pcv.save_all
          sleep 2

        end
  
        it "Set SSID Broadcast Status - Yes/No" do
        
          @page.broadcast_status @broadcast_status
         # pcv.save_all
          sleep 2

        end

  end # describe vlan, status pro 1
end # shared 

shared_examples "full profile setup" do 

    include_context "profiles"

    include_examples "create profile"

    include_examples "configure ntp"

    include_examples "configure network"

    include_examples "create ssids"
   
    include_examples "change ssid bands"

    include_examples "vlan, ssid status and broadcast status"
    
    include_examples "change ssid encryption profile 2"

    include_examples "admin settings"


end


def goto_profile(profile)
    view_all_profiles
    sleep 3
    @ui.get(:span,{title: profile}).wait_until_present
    @ui.get(:span,{title: profile}).click
    @ui.id("profile_general_container").wait_until_present
    sleep 2
  end
def header_profiles_link
    ln = @ui.id("header_left_nav")
    ln.wait_until_present
    ln.span(text:"Profiles")
  end

  def header_new_profile_btn
    @ui.get(:element,{id: "header_new_profile_btn"})
  end

  def header_view_all_profiles_link
    ni = @ui.id("view_all_nav_item")
    ni.wait_until_present
    ni.span(text: "View All Profiles")
  end

  def profiles_context_method
     puts "profiles_context_method"
  end

  def profile_tile(profile)
    @ui.get(:span,{title: profile})
  end

  def view_all_profiles
    header_profiles_link.click
    sleep 1
    header_view_all_profiles_link.wait_until_present
    header_view_all_profiles_link.click
    sleep 3
    #@ui.id("profiles_search_input").wait_until_present
  end
###################################
############ CONSTANTS ############
###################################
RADIUS_BASIC_CONF = {
  "acctEnabled" => true,
  "acctInterval" => "335",
  "primaryServerHostname" => "25.12.10.10",
  "primaryServerPort" => "1813",
  "secondaryServerHostname" => "72.72.72.72",
  "secondaryServerPort" => "1814",
  "acctPrimaryServerHostname" => "45.45.145.45",
  "acctPrimaryServerPort" => "1812",
  "acctSecondaryServerHostname" => "167.59.19.19",
  "acctSecondaryServerPort" => "1812",
  "primaryServerSecret" => {"isSet" => true, "value" => "123456"},
  "secondaryServerSecret" => {"isSet" => true, "value" => "123456"},
  "acctPrimaryServerSecret" => {"isSet" => true, "value" => "123456"},
  "acctSecondaryServerSecret" => {"isSet" => true, "value" => "123456"},
}
PASSPHRASE_BASE_CONF = {
  "isSet" => "true",
  "value" => "9999999999"
}
GENERAL_P_CONFIG = {
  "kbpsPerArray" => nil,
  "kbpsPerStation" => nil,
  "maxStations" => nil,
  "rules" => []
}

###################################
########## END CONSTANTS ##########
###################################


#########################################
###### NEW API BASED SHARED EXAMPLES ####
#########################################

shared_examples "API: set and verify ssid encryption" do |encryption_args|

  context "SSID Encryption Context" do

    before :all do
      # Set Tags to match Array Overrides
      if encryption_args["vlanOverrides"] && !encryption_args["vlanOverrides"].empty?
        update_array_tags(encryption_args)
        sleep 50
      end

      update_encryption(encryption_args)

      sleep 20
    end

    include_examples "activate"

    include_examples "AP: Verify ssid encryption", encryption_args

  end

end

shared_examples "AP: Verify ssid encryption" do |args|

  context "Verify SSID: '#{args["ssidName"]}' Encryption Settings" do

    before :all do
      @ssid_name = args["ssidName"]
      @telnet_session.show_passwords_enable()
      @ssid_output = @telnet_session.show_json_ssids()
      expect(@ssid_output).not_to be_empty

      @ssid = @ssid_output.find {|s| s["ssid"] == @ssid_name}
      expect(@ssid).not_to be_empty
      log_data_response(args, @ssid_output)
    end

    it "Verify General" do
      expect(args["broadcast"]).to eql(@ssid["broadcast"])  if args["broadcast"]
      expect(args["enabled"]).to eql(@ssid["enabled"]) if args["enabled"]
    end

    it "Verify Band" do
      if args["band"].eql?("BOTH")
        expect(@ssid["bands"].downcase).to include(args["band"].downcase)
      elsif args["band"].eql?("DOT11BG")
        expect(@ssid["bands"].downcase).to include("2.4ghz")
      elsif args["band"].eql?("DOT11A")
        expect(@ssid["bands"].downcase).to include("5ghz")
      else
        throw("Not Allowed Band")
      end
    end

    if args["vlan"] && !(args["vlanOverrides"] && !args["vlanOverrides"].empty?)
      it "Verify Primary Vlan" do
        expect(args["vlan"]["vlanNumber"].to_s).to eql( @ssid["vlanName"].to_s )
      end
    end

    if args["vlanOverrides"] && !args["vlanOverrides"].empty?
      it "Verify Primary Vlan by Vlan Overrides" do
        max_attempts = 5
        attempt = 0
        while attempt < max_attempts
          @ssid = @telnet_session.show_json_ssids().find {|s| s["ssid"] == @ssid_name}

          if args["vlanOverrides"].first["vlan"]["vlanNumber"].to_s == @ssid["vlan"].to_s
            attempt = max_attempts
          else
            sleep 15
            attempt = attempt + 1
          end
        end

        expect(args["vlanOverrides"].first["vlan"]["vlanNumber"].to_s).to eql( @ssid["vlan"].to_s)
      end
    end

    # Case PSK - Verify Passfraze Configurations
    if args["wpaPassphrase"] && args["wpaPassphrase"]["value"]
       it "Verify Radous Configurations" do
          expect(args["wpaPassphrase"]["value"].to_s).to eql(@ssid["security"]["wpaPassphrase"].to_s)
       end
    end

    # Case EAP - Verify Radius Configurations
    if args["radius"]
      it "Verify Radous Configurations" do
        r = args["radius"]

        expect(r["acctEnabled"]).to eql(@ssid["radiusAcct"]["enabled"])
        expect(r["acctInterval"].to_s).to eql(@ssid["radiusAcct"]["interval"].to_s)
        expect(r["primaryServerHostname"]).to eql(@ssid["radius"]["priServer"])
        expect(r["primaryServerPort"].to_s).to eql(@ssid["radius"]["priPort"].to_s)
        expect(r["secondaryServerHostname"]).to eql(@ssid["radius"]["secServer"])
        expect(r["secondaryServerPort"].to_s).to eql(@ssid["radius"]["secPort"].to_s)
        expect(r["acctPrimaryServerHostname"]).to eql(@ssid["radiusAcct"]["priServer"])
        expect(r["acctPrimaryServerPort"].to_s).to eql(@ssid["radiusAcct"]["priPort"].to_s)
        expect(r["acctSecondaryServerHostname"]).to eql(@ssid["radiusAcct"]["secServer"])
        expect(r["acctSecondaryServerPort"].to_s).to eql(@ssid["radiusAcct"]["secPort"].to_s)
        expect( r["primaryServerSecret"]["value"].to_s ).to eql( @ssid["radius"]["priSecret"].to_s ) if r["primaryServerSecret"]
        expect( r["secondaryServerSecret"]["value"].to_s ).to eql( @ssid["radius"]["secSecret"].to_s ) if r["secondaryServerSecret"]
        expect( r["acctPrimaryServerSecret"]["value"].to_s ).to eql( @ssid["radiusAcct"]["priSecret"].to_s ) if r["acctPrimaryServerSecret"]
        expect( r["acctSecondaryServerSecret"]["value"].to_s ).to eql( @ssid["radiusAcct"]["secSecret"].to_s ) if r["acctSecondaryServerSecret"]
      end
    end

    it "Verify Encryption" do
      expect(args["encryption"].downcase.gsub(/_/, "-")).to eql(@ssid["encryptionType"].downcase)
    end

    it "Verify Security" do
      if args["encryption"].downcase == 'none'
        expect(args["authentication"].downcase.gsub(/_/, "-")).to eql(@ssid["authentication"].downcase)
      elsif args["encryption"].downcase == 'wep'
        # TODO
      else
        expect(@ssid["security"]["wpaEnabled"]).to be true

        expect(args["wpaAesEnabled"]).to eql(@ssid["security"]["wpaAesEnabled"])
        expect(args["wpaTkipEnabled"]).to eql(@ssid["security"]["wpaTkipEnabled"])

        # Check for Authentication dot1xType
        if args["authentication"] == "DOT1X"
          expect(@ssid["security"]["wpaEapEnabled"]).to eql(args["dot1xType"] == "EAP")
          expect(@ssid["security"]["wpaPskEnabled"]).to eql(args["dot1xType"] == "PSK" ? "on" : "off")

          # NOT sure about "Active Directory Case"
          unless args["dot1xType"] == "EAP" || args["dot1xType"] == "PSK"
            throw("Handle this case: dot1xType = #{args["dot1xType"]} as well")
          end
        else
          # TODO  define case   It seems this is the case called  UPSK
          throw("Handle this case: when dot1xType is not defined")
        end
      end
    end

  end

end # shared ssid encryption


#######################
###### POLICIES #######
#######################
shared_examples "API: set and verify policies" do |policies|

  context "Policies Context" do

    before :all do
      policies.each do |policy|
        add_update_policy(policy)
      end

      sleep 20
    end

    include_examples "activate"

    include_examples "AP: Verify Policies", policies

  end

end

shared_examples "AP: Verify Policies" do |policies|

  context "Verify Policiies:" do

    before :all do
      sleep 10
      @policies = @telnet_session.show_json_policies()
      @policies_details = @telnet_session.show_json_policies("groupCfg")

      expect(@policies.length).to be >= policies.length
      expect(@policies_details.length).to be >= (policies.find_all{|p| p["policyType"] != "SSID"}).length
    end

    policies.each do |policy|

      it "Verify Policy: #{policy["name"]}" do
        _p = @policies.find { |p| p["name"] == policy["name"] }
        expect(_p).not_to be_nil
      end

      it "Verify Policy: #{policy["name"]} Details" do
        unless policy["policyType"] == "SSID"
          _p_d = @policies_details.find { |p| p["group"] == policy["name"] }
          expect(_p_d).not_to be_nil

          expect(_p_d["deviceId"]).to eql(policy["deviceClassification"]) if policy["deviceClassification"]
          expect(_p_d["radiusId"]).to eql(policy["radiusFilterId"]) if policy["radiusFilterId"]
        end
      end

    end

  end

end # shared policies

####################
###### RULES #######
####################
shared_examples "API: set and verify rules" do |rules|

  context "Rules Context" do

    before :all do
      rules.each do |rule|
        add_update_rule(rule)
      end
    end

    include_examples "activate"

    include_examples "AP: Verify Rules", rules

  end

end

shared_examples "AP: Verify Rules" do |rules|

  context "Verify Rules:" do

    before :all do
      @policies = @telnet_session.show_json_policies()
      @policies_details = @telnet_session.show_json_policies("groupCfg")

      rule_count = 0
      @total_filters = []

      @policies.each do |p|
        rule_count = rule_count + p["numFilters"]
        (@total_filters = @total_filters + p["filters"]["entries"]) if p["filters"]
      end

      expect(rule_count).to be >= rules.length
      expect(@total_filters.length).to be >= rules.length
    end

    rules.each do |rule|

      context "\n -- > Veryfy Rule:    #{rule["name"]}\n\n" do

        before :all do
          @filter = @total_filters.find { |filter| filter["name"] == rule["name"] }
          expect(@filter).not_to be_nil
        end

        it "Verify Filter: #{rule["name"]} properties" do
          expect(@filter["type"].downcase).to eql(rule["action"].downcase) if rule["action"]
          expect(@filter["application"].downcase).to eql(rule["applicationId"].downcase) if rule["applicationId"]
          expect(@filter["enabled"].to_s).to eql(rule["enabled"].to_s) if rule["enabled"]
          expect(@filter["set"].to_s).to include(rule["qos"].to_s) if rule["qos"]

          if rule["protocolLayer"]
            expect(rule["protocolLayer"].to_s).to include(@filter["layer"].to_s)
          else
            expect(@filter["layer"].to_s).to eql("3")
          end

          if rule["protocol"]
            expect( @filter["protocol"].downcase.gsub(/-/,"_") ).to eql(rule["protocol"].downcase)
          else
            expect(@filter["protocol"].downcase).to eql("any")
          end

          if rule["source"]
            expect(@filter["source"]).to include( (rule["source"]["macAddress"] || rule["source"]["ipAddress"] || rule["source"]["vlanNumber"]).to_s )
          else
            expect(@filter["source"].downcase).to eql("any")
          end

          if rule["destination"]
            expect(@filter["destination"]).to include( (rule["destination"]["macAddress"] || rule["destination"]["ipAddress"] || rule["destination"]["vlanNumber"]).to_s )
          else
            expect(@filter["destination"].downcase).to eql("any")
          end

        end

      end

    end

  end

end # shared rules

shared_examples "admin settings" do 

  describe "Change Admin Settings" do
    it "Change Admin Settings" do
      @browser.refresh
      sleep 10
      goto_profile(@profile)
      admin_tile = @ui.profile_config_view.tile('admin')
      admin_tile.wait_until_present
      admin_tile.click
      sleep 2
      admin_info_array = @admin_info.split(',')
      @ui.set_text_field_by_id("profile_config_admin_name", admin_info_array[0])
      @ui.set_text_field_by_id("profile_config_admin_email", admin_info_array[1])
      sleep 1
      @browser.execute_script('$("#suggestion_box").hide()')
      @ui.profile_config_view.save_all
      sleep 3
    end
  end
end


#########################################
###### NEW API BASED SHARED METHODS #####
#########################################

###################################################################
############################# NOTE ################################
###################################################################
## ENCRYPTION            AUTHENTICATION  #  UI DROPDOWN OPTION   ##
## ------------------------------------  #  -------------------- ##
## NONE                  OPEN            #  None/Open            ##
## WPA2                  DOT1X           #  WPA2/802.1x          ##
## WPA_BOTH              DOT1X           #  WPA & WPA2/802.1x    ##
## WPA                   DOT1X           #  WPA/802.1x           ##
## WEP                   OPEN            #  WEP/Open             ##
## NONE                  RADIOS_MAC      #  None/RADIOS MAC      ##
## ------------------------------------  #  -------------------- ##
###################################################################
### DOT1X values are   ->  EAP, PSK, AD  ##########################
###################################################################

# Make sure @profile is defined before calling this function.
def update_encryption(args = {})
  args = XMS.api_based_default_ssid_encryption.merge(args)

  profile_config = _get_profile_config()

  profile_config["ssids"].each { |pc| pc.merge!(args) if pc["ssidName"] == args["ssidName"] }

  puts "Update Profile Configuration: -> Change Encryption for SSID: #{args['ssidName']}"
  res = @ng.update_profile_configuration(@profile_id, profile_config)
  expect(res.code).to eql(200)
  expect(res.body).to include("Profile Configuration updated")
end

# Make sure @profile is defined before calling this function.
def add_update_policy(args = {})
  profile_config = _get_profile_config()

  if args["policyType"] == "SSID" && args["ssidId"].nil?
    puts "  --- >  Get SSID ID to include it in args"
    ssid = profile_config["ssids"].find { |ssid| ssid["ssidName"] == args["ssidName"] }
    expect(ssid).not_to be_empty
    args["ssidId"] = ssid["id"]
  end

  # Add a new Policy or Override an existing one (with the same name and the type)
  policy_exist = false
  profile_config["policies"].each { |pc| policy_exist !!pc.merge!(args) if pc["name"] == args["name"] && pc["policyType"] == args["policyType"] }
  profile_config["policies"] << args unless policy_exist

  puts "Update Profile Configuration: -> Change Policy: #{args['name']}"
  res = @ng.update_profile_configuration(@profile_id, profile_config)
  expect(res.code).to eql(200)
  expect(res.body).to include("Profile Configuration updated")
end

# Make sure @profile is defined before calling this function.
def add_update_rule(args = {})
  profile_config = _get_profile_config()

  policy_name = args.delete("policy")
  policy = profile_config["policies"].find { |pc| pc["name"] == policy_name }
  expect(policy).not_to be_nil


  # Add a new Rule or Override an existing one (with the same name and the type)
  rule_exist = false
  policy["rules"].each { |rule| rule_exist !!rule.merge!(args) if rule["name"] == args["name"] }
  policy["rules"] << args unless rule_exist

  puts "Update Profile Configuration: -> Change Policy: #{policy_name} Rule: #{args['name']}"
  res = @ng.update_profile_configuration(@profile_id, profile_config)
  expect(res.code).to eql(200)
  expect(res.body).to include("Profile Configuration updated")
end

def _get_profile_config()
  unless (@profile_id)
    res = @ng.get_profile_by_name(@profile)
    expect(res.code).to eql(200)
    @profile_id = res.body["id"]
  end

  res = @ng.get_profile_configuration({profileId: @profile_id})
  expect(res.code).to eql(200)
  res.body
end

def update_array_tags(args)
  res = @ng.global_by_serial(@array.serial)
  expect(res.code).to eql(200)
  array = res.body["xirrusArrayDto"]

  array["tags"] = args["vlanOverrides"].map{|a| {"name" => a["tagName"]} }
  res = @ng.update_array_for_current_tenant(array["id"], array)
  expect(res.code).to eql(200)
  expect(res.body).to include("Array updated")
end

def remove_array_tags()
  res = @ng.global_by_serial(@array.serial)
  expect(res.code).to eql(200)
  array = res.body["xirrusArrayDto"]
  unless array["tags"].empty?
    puts "\n  -- >  Remove all Tags: #{array["tags"]} from \n Array: #{@array.serial}\n"
    array["tags"] = []
    res = @ng.update_array_for_current_tenant(array["id"], array)
    expect(res.code).to eql(200)
    expect(res.body).to include("Array updated")
  end
end
#####################
####### END #########
#####################













#####################
####### OLD #########
#####################
shared_context "vlan hooks" do

  before :all do 
    fresh_ssid_grid_by_profile(@profile)
    @ui.profile_config_view.wait_until_present
    @ui.profile_config_view.ssid_grid_view.el.wait_until_present
  end

  after :all do
    sleep 2
    @ui.profile_config_view.save_all
    sleep 5
  end

  let(:pcv){@ui.profile_config_view}

end # vlan hooks

shared_context "change encryption hooks" do

  before :all do
   @browser.refresh()
   sleep 30
   goto_profile(@profile)
   @ui.profile_config_view.ssids_tile.wait_until_present
   @ui.profile_config_view.ssids_tile.click
   sleep 10
   @ui.id("profile_config_ssids_view").wait_until_present
  end

  before :each do
    @browser.refresh # incase previous test failed and modal did not go away
    sleep 15
    @ui.get(:div, {id: "profile_config_ssids_view"}).wait_until_present
    sleep 5
  end

  after :each do
    sleep 5
  end

  let(:default_auth_option){ "WPA2/802.1x"}

  # Used for SSID Auto2
  let(:default_wpa_args){
    {
      encrypt_type: "tkip",
      auth_type: "eap",
      host: "10.10.10.10",
      port: "1812",
      share: "123456",
      share_confirm: "123456",
      add_secondary: true,
      secondary_host: "11.11.11.11",
      secondary_port: "1812",
      secondary_share: "123456",
      secondary_share_confirm: "123456",
      accounting: true,
      alternate_accounting: true,
      primary_accounting_host: "13.13.13.13",
      primary_accounting_port: "1812",
      primary_accounting_share: "123456",
      primary_accounting_share_confirm: "123456",
      secondary_accounting: true,
      secondary_accounting_host: "19.19.19.19",
      secondary_accounting_port: "1812",
      secondary_accounting_share: "123456",
      secondary_accounting_share_confirm: "123456",
      accounting_radius_interval: "330"
    }
  }

  let(:pcv){@ui.profile_config_view}

end # encryption hooks

shared_context "add policy hooks" do 

  before :all do
    goto_profile(@profile)
    @ui.profile_config_view.tile('policies').wait_until_present
    @ui.profile_config_view.tile('policies').click
    @ui.get(:div, {id: "profile_config_policies"}).wait_until_present
  end

  before :each do
    sleep 5
    @browser.refresh
    sleep 30
    @ui.get(:div, {id: "profile_config_policies"}).wait_until_present
  end

  let(:pcv){@ui.profile_config_view}

end # add policy hooks

shared_context "profiles" do

  def header_profiles_link
    ln = @ui.id("header_left_nav")
    ln.wait_until_present
    ln.span(text:"Profiles")
  end

  def header_new_profile_btn
    @ui.get(:element,{id: "header_new_profile_btn"})
  end

  def header_view_all_profiles_link
    ni = @ui.id("view_all_nav_item")
    ni.wait_until_present
    ni.span(text: "View All Profiles")
  end

  def profiles_context_method
     puts "profiles_context_method"
  end

  def profile_tile(profile)
    @ui.get(:span,{title: profile})
  end

  def view_all_profiles
    header_profiles_link.click
    sleep 1
    header_view_all_profiles_link.wait_until_present
    header_view_all_profiles_link.click
    sleep 3
    #@ui.id("profiles_search_input").wait_until_present
  end

  def goto_profile(profile)
    view_all_profiles
    sleep 3
    @ui.get(:span,{title: profile}).wait_until_present
    @ui.get(:span,{title: profile}).click
    @ui.id("profile_general_container").wait_until_present
    sleep 2
  end

  def fresh_ssid_grid_by_profile(profile_name)
      goto_profile(profile_name)

      @ui.get(:div, {id: "profile_config_container"}).wait_until_present
      p = @ui.profile_config_view

      p.wait_until_present

      p.ssids_tile.click
      sleep 4
      p.ssid_grid.wait_until_present
  end

end

def expect_no_error
  expect(@ui.error_dialog).to_not be_present
  expect(@ui.div(css: ".temperror")).to_not be_present
end

def expect_error_dialog
  expect(@ui.error_dialog.present?).to eql(true)
end

def expect_temperror
  expect(@ui.div(css: ".temperror")).to be_present
end