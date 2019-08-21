require_relative "../context.rb"
require_relative "./local_lib/profiles_lib.rb"
require_relative "./local_lib/bonjour_lib.rb"
require_relative "../TS_BE_Array/local_lib/array_lib.rb"
################################################################################################################
##############TEST CASE: Profile Configuration - Advanced Optimization#############################################
################################################################################################################

profile_name = UTIL.random_title


describe "*************TEST CASE: Profile Configuration - Advanced Optimization******************" do 

  before :all do 
    ssid = UTIL.random_title
    @profile = profile_name
    @ssids = "#{ssid}"
  end

  include_examples "create profile"

  include_examples "default profile network settings", profile_name

  include_examples "create ssids"

  context "Make Optimizations in UI and then verify in Array" do 

  	before :all do
      @multicast_ip = "224.0.0.0"
      @invalid_multicast_ip = "10.100.23.168"
      @multicast_note = "Multicast Note added in RSpec"
      @telnet_session = @array.telnet_session
  	end

  	let(:view){ @ui.div(id: "profile_config_optimization_view") }
    
    it "Assign Array to Profile - #{profile_name}" do
      @ui.array_to_profile(@array.serial, profile_name)
    end

    include_examples "activate"

    it "Go back to profile" do
      goto_profile(profile_name)
    end

    it "Click Show Advanced to make Optimization tile visible" do
      @ui.id("profile_config_advanced").click
      sleep 1
      @ui.div(css: ".icon.optimization").wait_until_present
    end

    it "Click Optimization Tile" do
      @ui.profile_config_view.tile('optimization').click
    end

    it "Optimization header and subtitle" do
      expect(@ui.div(id: "profile_config_optimization_view").div(css: ".commonTitle").text).to eql("Optimization")
      expect(@ui.div(id: "profile_config_optimization_view").div(css: ".commonSubtitle").text).to eql("The system can automatically optimize your profile's characteristics to maximize performance and availability.")
    end

    it "Client and Traffic Sections Present" do
      @browser.div(css: ".optContainer").wait_until_present
      @browser.div(id: "optimize_client").wait_until_present
      @browser.div(id: "optimize_traffic").wait_until_present
      opt_client_div = @browser.div(id: "optimize_client")
      expect(opt_client_div.div(css: ".opt_icon.client")).to be_visible
      expect(opt_client_div.span(css: ".opt_title").text).to eql("Client")
      expect(opt_client_div.span(css: ".opt_desc").text).to eql("Help clients optimize their wireless connection for signal strength and speed.")
      opt_traffic_div = @browser.div(id: "optimize_traffic")
      expect(opt_traffic_div.div(css: ".opt_icon.traffic")).to be_visible
      expect(opt_traffic_div.span(css: ".opt_title").text).to eql("Traffic")
      expect(opt_traffic_div.span(css: ".opt_desc").text).to eql("Optimize your network environment for handling multicast traffic.")
    end

    context "Optimize Client Area" do

      before :all do
        # Expand Client Area
        @ui.div(id: "optimize_client").a.click
      end

      let(:area){ @ui.div(id: "optimize_client") }

      it "Roaming Section" do

        roaming_div = area.span(text: "Roaming").parent.parent.parent

        roaming_div.div(css: ".opt_icon.roaming").wait_until_present
        expect(roaming_div.span(css: ".opt_title").text).to eql("Roaming")
        expect(roaming_div.span(css: ".opt_desc").text).to eql("Select how you would like the system to help clients roam from one Access Point to another Access Point.")
        expect(roaming_div.div(css: '.opt_fields').div(css: '.opt_field_heading').text).to eql('Fast Roam Times')
        roaming_opt_field = roaming_div.div(css: '.opt_fields').div(css: '.opt_field')
        expect(roaming_opt_field.span(css: ".opt_field_label").text).to eql("Would you like to optimize roam times?")
        expect(roaming_opt_field.div(css: ".opt_info").text).to eql("802.11k beacon support allows a client to quickly identify nearby Access Points that are available for roaming.  When the signal strength of the current Access Point weakens and the client needs to roam to a new Access Point, it will already know the best candidate Access Point with which to connect.")
       # expect(roaming_opt_field.input(id: "optimization_fastroam_switch_switch")).to be_visible
      end

      it "Fast Roam Switch Default is 'Yes'" do
        is_checked = @ui.checkbox(id: "optimization_fastroam_switch_switch").attribute_value("checked")
        expect(is_checked).to eql("true")
        @ui.ng_toggle_set("optimization_fastroam_switch_switch", false)
        @ui.ng_toggle_set("optimization_fastroam_switch_switch", true)
        @ui.profile_config_view.save_all
        sleep 4
        @telnet_session.activation_done?

      end

      it "Array Fast Roaming is On in Array" do
        global_iap_settings = @telnet_session.global_iap_settings
        k_support_line = global_iap_settings.get_line "dot11k-support"
        expect(k_support_line).to include('on')
      end

      it "Set Fast Roam to 'No'" do
        @ui.ng_toggle_set("optimization_fastroam_switch_switch", false)
        @ui.profile_config_view.save_all
      end

      include_examples "activate"

      it "Verify Fast Roaming is Off" do
        global_iap_settings = @telnet_session.global_iap_settings
        k_support_line = global_iap_settings.get_line "dot11k-support"
        expect(k_support_line).to include('off')
      end

      it "Load Balancing Section" do
        load_balancing_div = area.span(text: "Load Balancing").parent.parent.parent

        load_balancing_div.div(css: ".opt_icon.loadbalancing").wait_until_present
        expect(load_balancing_div.span(css: ".opt_title").text).to eql("Load Balancing")
        expect(load_balancing_div.span(css: ".opt_desc").text).to eql("Selected how clients on your network should be distributed across multiple radios on one Access Point.")
        expect(load_balancing_div.div(css: '.opt_fields').div(css: '.opt_field_heading').text).to eql('acXpress™ & Load Balancing')
        load_opt_field = load_balancing_div.div(css: '.opt_fields').div(css: '.opt_field')
        expect(load_opt_field.span(css: ".opt_field_label").text).to eql("Would you like to enable acXpress™ & Load Balancing?")
        expect(load_opt_field.div(css: ".opt_info").text).to eql("This feature places 802.11ac clients on 802.11ac radios and places 802.11a/b/g/n clients on other radios thereby optimizing throughput for 802.11ac capable clients.  This features also encourages clients to evenly associate across the radios on an Access Point.")
      end

      it "Load Balancing Switch Default is 'Yes'" do
        is_checked = @ui.checkbox(id: "optimization_loadbalancing_bond_switch_switch").attribute_value("checked")
        expect(is_checked).to be_nil
      end

      it "Verify Load Balancing is ON in Array" do
        global_iap_settings = @telnet_session.global_iap_settings
        verify_line = global_iap_settings.get_line "load-balancing"
        expect(verify_line).to include('off')
      end


      it "Set Load Balancing to 'No'" do
        @ui.ng_toggle_set("optimization_loadbalancing_bond_switch_switch", false)
        @ui.profile_config_view.save_all
      end

      include_examples "activate"

      it "Verify Load Balancing is Off" do
        global_iap_settings = @telnet_session.global_iap_settings
        verify_line = global_iap_settings.get_line "load-balancing"
        expect(verify_line).to include('off')
      end

    end # Optmize Client

    context "Optimize Traffic Area" do
      before :all do
        # Scroll to optimize_traffic button
        optimize_traffic_btn = @ui.div(id: "optimize_traffic").a
        optimize_traffic_btn.scroll.to
        optimize_traffic_btn.click
      end

      let(:area){ @ui.div(id: "optimize_traffic")}

      it "Multicast Section" do
        multicast_div = area.span(text: "Multicast").parent.parent.parent
        sleep 10
        el = multicast_div.span(css: ".opt_title")
        el.wait_until_present
        txt = el.text

        expect(txt).to eql("Multicast")
        expect(multicast_div.span(css: ".opt_desc").text).to eql("Access Points can optimize the total available wireless network bandwidth by handling IP multicast traffic in different ways.")
        expect(multicast_div.div(css: '.opt_fields').divs(css: '.opt_field_heading').first.text).to eql('Multicast Isolation')
        expect(multicast_div.div(css: '.opt_fields').divs(css: '.opt_field_heading').last.text).to eql('Multicast Optimization')
      end

      it "Aggresive Optimization is selected by default" do
        aggressive_radio_div = @ui.id("profile_config_optimization_multicast_high").parent
        is_checked = aggressive_radio_div.radio.attribute_value("checked")
        expect(is_checked).to be_nil
      end

      it "Array has aggresive optimization on by default" do
        global_iap_settings = @telnet_session.global_iap_settings
        verify_line = global_iap_settings.get_line("multicast")
        expect(verify_line).to include('standard')
      end

      it "Change to Moderate Traffic Optimization" do
        moderate_radio_div = @ui.id("profile_config_optimization_multicast_mode").parent
        moderate_radio_div.label.click
        @ui.profile_config_view.save_all
      end

      include_examples "activate"

      it "Verify Moderate Traffic Optimization in Array" do
        global_iap_settings = @telnet_session.global_iap_settings
        verify_line = global_iap_settings.get_line("multicast")
        expect(verify_line).to include('convert+snoop')
        expect(verify_line).to_not include('prune')
      end

      it "Change to Light Traffic Optimization" do
        light_radio_div = @ui.id("profile_config_optimization_multicast_light").parent
        light_radio_div.label.click
        @ui.profile_config_view.save_all
      end

      include_examples "activate"

      it "Verify Light Traffic Optimization in Array" do
        global_iap_settings = @telnet_session.global_iap_settings
        verify_line = global_iap_settings.get_line("multicast")
        expect(verify_line).to include('convert')
        expect(verify_line).to_not include('snoop')
        expect(verify_line).to_not include('prune')
      end

      it "Change to Aggressive Traffic Optimization" do
        radio_div = @ui.id("profile_config_optimization_multicast_high").parent
        radio_div.label.click
        @ui.profile_config_view.save_all
      end

      include_examples "activate"

      it "Verify Aggresive Traffic Optimization in Array" do
        global_iap_settings = @telnet_session.global_iap_settings
        verify_line = global_iap_settings.get_line("multicast")
        expect(verify_line).to include('convert+snoop+prune')
      end
    end

    ##################################
    ## Hidden  MULTICAST IP Section ##
    ##################################
    context "Hidden MULTICAST IP Section" do

      before :all do
        @session = @array.is_aos_light(@array.model) ? @array.ssh_session : @array.telnet_session
      end

      it "Multicast Exclude Add IP" do
        @ui.id("profile_config_optimization_multicast_high").parent.label.click

        # Scroll to profile_config_optimization_multicast_toggle_showexclude button
        multicast_toggle_showexclude_btn = @ui.id("profile_config_optimization_multicast_toggle_showexclude")
        multicast_toggle_showexclude_btn.scroll.to
        multicast_toggle_showexclude_btn.click
        sleep 3
        @ui.set_text_field_by_id("profile_config_optimization_multicast_exclude_id", @multicast_ip)
        @ui.set_text_field_by_id("profile_config_optimization_multicast_exclude_desc", @multicast_note)
        @ui.a(id: "profile_config_optimization_multicast_exclude_add").click
        sleep 1
        @ui.profile_config_view.save_all

        sleep 1
        @ui.refresh
        @ui.div(id: "optimize_traffic").a.click

        sleep 1
        # Scroll to profile_config_optimization_multicast_toggle_showexclude button
        multicast_toggle_showexclude_btn = @ui.id("profile_config_optimization_multicast_toggle_showexclude")
        multicast_toggle_showexclude_btn.scroll.to
        multicast_toggle_showexclude_btn.click
        sleep 1

        multicast_list_items = @ui.div(css: ".multicast_exclude_list").div(css: '.select_list.scrollable').ul.lis
        new_item = multicast_list_items[1]

        expect(new_item.span(css: '.address').text).to eql(@multicast_ip)
        expect(new_item.span(css: '.description').text).to eql("(#{@multicast_note})")
        sleep 8
      end

      include_examples "activate"

      it "Verify Multicast Exclude IP in Array" do
        global_iap_settings = @session.global_iap_settings
        multicast_ip_lines = global_iap_settings.select{|line| line.strip.start_with?("multicast")}
        multicast_all_ip_lines = multicast_ip_lines.join
        expect(multicast_all_ip_lines).to include(@multicast_ip)
      end
     it "Multicast Remove Excluded IP" do 
        multicast_list_section = @ui.div(css: ".multicast_exclude_list")
        sleep 1
        multicast_list_section.scroll.to
        multicast_list_items = multicast_list_section.div(css: '.select_list.scrollable').ul.lis
        new_item = multicast_list_items[1]
        
        expect(new_item.span(css: '.address').text).to eql(@multicast_ip)
        
        end

        include_examples "activate"

        it "Verify Excluded IP Removed from Access Point" do 
          global_iap_settings = @telnet_session.global_iap_settings
          multicast_ip_line = global_iap_settings.select{|line| line.strip.start_with?"multicast"}[1]
          expect(multicast_ip_line).to_not include(@multicast_ip)

        end
      it "Set 'Do Not Optimize' for Traffic Optimization" do
        sleep 2
        none_radio_div = @ui.id("profile_config_optimization_multicast_none").parent
        none_radio_div.scroll.to
        none_radio_div.label.click
        @ui.profile_config_view.save_all
        sleep 8
      end

      include_examples "activate"

      it "Verify 'Do Not Optimize' Traffic in Access Point" do
        global_iap_settings = @session.global_iap_settings
        verify_line = global_iap_settings.get_line "multicast"
        expect(verify_line).to include('standard')
        expect(verify_line).to_not include('convert')
        expect(verify_line).to_not include('snoop')
        expect(verify_line).to_not include('prune')
      end
    end
  end

  context "Clean Up" do
    it "Delete Random Profile" do
      @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
      @ng = API::ApiClient.new(token: @token)
      ng = @ng
      profiles_response = ng.get("/profiles.json/", {count: "1000"})

      profile_res = profiles_response.body["data"].select{|pro|
        pro["name"] == profile_name
      }.first

      puts ng.delete_profile(profile_res['id']).body
    end
  end
end
