require_relative "../context.rb"
require_relative "./local_lib/profiles_lib.rb"
require_relative "./local_lib/bonjour_lib.rb"
require_relative "../TS_BE_Array/local_lib/array_lib.rb"
################################################################################################################
##############TEST CASE: Profile Configuration Bonjour#############################################
################################################################################################################

profile_name = UTIL.random_title

test_profile = {

  name: profile_name ,
  cdp: "yes,56,178 ",
  mtu: "1643",
  dns: "10.100.1.10,10.100.2.10,8.8.8.8",
  ntp: "yes,msn.com,MD5,65432,65432,sec,face.com,SHA1,45678,45678",
  admin_info: "Sqa Admin,sqa-sqa@xirrus.com,424-828-1224",
  admin_password: "no,admin"

}

describe "Profile #{test_profile[:name]} - Bonjour" do

    before :all do 
      test_profile_setup(test_profile)
      @profiles_view = @ui.profiles_view
      @profile =  test_profile[:name]
      @cdp = test_profile[:cdp] # "yes,56,178 "
      @mtu = test_profile[:mtu] # "1643"
      @dns = test_profile[:dns] # "#{DNS_SERVER_1},#{DNS_SERVER_2}"
      @ntp = test_profile[:ntp] # "yes,msn.com,MD5,65432,65432,sec,face.com,SHA1,45678,45678"

      @admin_info = test_profile[:admin_info] # "Sqa Admin,sqa-sqa@xirrus.com,424-828-1224"
      @admin_password = test_profile[:admin_password] # "yes,#{ARRAY_PASSWORD_PROFILE6}"
      if @array
        @telnet_session = @array.telnet_session # telnet_session(@array.ip,@array.username, @array.password)
        @array_api_client = @array.api_client
      end
    end

    after :all do 
      ng = @ng || ngapi
      profiles_response = ng.get("/profiles.json/", {count: "1000"})
   
      profile_res = profiles_response.body["data"].select{|pro| 
        pro["name"] == profile_name
      }.first
   
      ng.delete_profile(profile_res['id']).body
    end

    context "**********Bonjour Director*******************" do

    it "Go to Profile and configure VLAN for Bonjour Director" do 
      sleep 1
      goto_profile(@profile)
      sleep 5
      @ui.profile_config_view.tile('bonjour').wait_until_present
      @ui.profile_config_view.tile('bonjour').click
      sleep 10
      if @ui.div(css: ".vlan_disabled").present?
        @ui.div(css: ".vlan_disabled").a(text: "enable VLAN").wait_until_present
        @ui.div(css: ".vlan_disabled").a(text: "enable VLAN").click
        sleep 2
      end  
    end

    it "Configure Bonjour Settings" do
      @browser.execute_script('$("#suggestion_box").hide()')
      bonjour_config '{:bonjour_status=>["yes"], :services=>["iPhoto", "iTunes"], :vlan=>["345", "331", "790"], :vlan_overrides=>[:Biology_202_62735=>["232", "432"],:Employee_24_23179=>["99","98","97"]]}'
      sleep 1
      @ui.profile_config_view.save_all
      sleep 3
    end
    include_examples "activate"
  end 
  include_examples "admin settings"
end

