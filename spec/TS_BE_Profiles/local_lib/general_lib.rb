shared_examples "update profile general settings" do |profile_name, profile_description|
  describe "Update profile general settings" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
    end

    it "Update the profile name and save" do
      @ui.set_input_val("#profile_config_basic_profilename", profile_name + " update")

      @ui.save_profile
      sleep 1

      pn = @ui.get(:text_field, {id: "profile_config_basic_profilename"})
      pn.wait_until_present
      expect(pn.type).to eq("text")
      expect(pn.attribute_value("maxlength")).to eq("255")
      expect(pn.value).to eq(profile_name + " update")
    end

    it "Update the profile description and save" do
      @ui.set_textarea_val('#profile_config_basic_description', profile_description + " update")

      @ui.save_profile
      sleep 1

      pd = @ui.id('profile_config_basic_description')
      pd.wait_until_present
      expect(pd.attribute_value("maxlength")).to eq("1000")
      expect(pd.value).to eq(profile_description + " update")
    end

    it "Update the profile country and save" do
      @ui.set_dropdown_entry('profile_config_basic_country', 'Canada')
      sleep 1

      @ui.save_profile
      sleep 1

      expect(@ui.css('#profile_config_basic_country .ko_dropdownlist_button .text').text).to eq('Canada')
    end

    it "Update the time zone and save" do
      @ui.set_dropdown_entry('profile_config_basic_timezone', '(GMT) Greenwich Mean Time: Dublin, Lisbon, London')
      sleep 1

      @ui.save_profile
      sleep 1

      expect(@ui.css('#profile_config_basic_timezone .ko_dropdownlist_button .text').text).to eq('(GMT) Greenwich Mean Time: Dublin, Lisbon, London')
    end

    it "Reset profile general settings field values" do
      @ui.set_input_val("#profile_config_basic_profilename", profile_name)
      @ui.set_input_val("#profile_config_basic_description", profile_description)
      @ui.set_dropdown_entry('profile_config_basic_country', 'United States')
      @ui.set_dropdown_entry('profile_config_basic_timezone', '(GMT - 08:00) Pacific Time (US & Canada); Tijuana')

      @ui.save_profile
      sleep 1

      pn = @ui.get(:text_field, {id: "profile_config_basic_profilename"})
      pn.wait_until_present
      expect(pn.value).to eq(profile_name)
      pd = @ui.get(:textarea, {id: "profile_config_basic_description"})
      pd.wait_until_present
      expect(pd.value).to eq(profile_description)
      expect(@ui.id('profile_config_basic_country').element(:css => ".ko_dropdownlist_button .text").text).to eq('United States')
      expect(@ui.id('profile_config_basic_timezone').element(:css => ".ko_dropdownlist_button .text").text).to eq('(GMT - 08:00) Pacific Time (US & Canada); Tijuana')
    end

  end
end

shared_examples "update profile advanced settings" do |profile_name|
  describe "Update profile advanced settings" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
    end

    it "Select show advanced toggle - show" do
      adv = @ui.click("#general_show_advanced")

      dls = @ui.id('daylightswitch')
      dls.wait_until_present
      ntp = @ui.id('general_ntp_toggle')
      ntp.wait_until_present
      led = @ui.id('ledoff')
      led.wait_until_present
      sys = @ui.id('enableSyslogSwitch')
      sys.wait_until_present

      expect(dls).to be_visible
      expect(ntp).to be_visible
      expect(led).to be_visible
      expect(sys).to be_visible
    end

    it "Update the DST and save" do
      @ui.click("#daylightswitch .switch_label")

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "daylightswitch_switch"}).set?).to eq(false)
    end

    it "Update NTP primary and save" do
      @ui.set_input_val("#profile_config_basic_primaryserver", "ntp.custom.com")
      @ui.set_dropdown_entry('profile_config_basic_primaryauthentication', 'SHA1')
      sleep 1

      @ui.set_input_val("#profile_config_basic_primaryauthenticationkeyid", "111")
      @ui.set_input_val("#profile_config_basic_primaryauthenticationkey", "12345678")

      @ui.save_profile
      sleep 1

      primary = @ui.get(:text_field, {id: "profile_config_basic_primaryserver"})
      primary.wait_until_present
      expect(primary.type).to eq("text")
      expect(primary.attribute_value("maxlength")).to eq("256")
      expect(primary.value).to eq("ntp.custom.com")

      expect(@ui.id('profile_config_basic_primaryauthentication').element(:css => ".ko_dropdownlist_button .text").text).to eq('SHA1')

      keyid = @ui.get(:text_field, {id: "profile_config_basic_primaryauthenticationkeyid"})
      keyid.wait_until_present
      expect(keyid.type).to eq("text")
      expect(keyid.attribute_value("maxlength")).to eq("5")
      expect(keyid.value).to eq("111")

      key = @ui.get(:text_field, {id: "profile_config_basic_primaryauthenticationkey"})
      key.wait_until_present
      expect(key.type).to eq("password")
      expect(key.attribute_value("maxlength")).to eq("20")
      expect(key.value).to eq("--------")
    end

    it "Update NTP secondary and save" do
      @ui.set_input_val("#profile_config_basic_secondaryserver", "ntp.custom.com")
      @ui.set_dropdown_entry('profile_config_basic_secondaryauthentication', 'SHA1')
      sleep 1

      @ui.set_input_val("#profile_config_basic_secondaryauthenticationkeyid", "222")
      @ui.set_input_val("#profile_config_basic_secondaryauthenticationkey", "22345678")

      @ui.save_profile
      sleep 1

      secondary = @ui.get(:text_field, {id: "profile_config_basic_secondaryserver"})
      secondary.wait_until_present
      expect(secondary.type).to eq("text")
      expect(secondary.attribute_value("maxlength")).to eq("256")
      expect(secondary.value).to eq("ntp.custom.com")

      expect(@ui.id('profile_config_basic_secondaryauthentication').element(:css => ".ko_dropdownlist_button .text").text).to eq('SHA1')

      keyid = @ui.get(:text_field, {id: "profile_config_basic_secondaryauthenticationkeyid"})
      keyid.wait_until_present
      expect(keyid.type).to eq("text")
      expect(keyid.attribute_value("maxlength")).to eq("5")
      expect(keyid.value).to eq("222")

      key = @ui.get(:text_field, {id: "profile_config_basic_secondaryauthenticationkey"})
      key.wait_until_present
      expect(key.type).to eq("password")
      expect(key.attribute_value("maxlength")).to eq("20")
      expect(key.value).to eq("--------")
    end

    it "Update NTP (off) and save" do
      ntp = @ui.click("#has_NTPswitch .switch_label")

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "has_NTPswitch_switch"}).set?).to eq(false)
    end

    it "Turn on syslog and save" do
      @ui.click("#enableSyslogSwitch .switch_label")
      @ui.set_input_val("#profile_config_general_syslogIp", "1.2.3.4")
      @ui.set_input_val("#profile_config_general_syslogPort", "555")
      @ui.set_dropdown_entry('profile_config_general_syslogLevel', 'Debug')

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "enableSyslogSwitch_switch"}).set?).to eq(true)
      sysip = @ui.get(:text_field, {id: "profile_config_general_syslogIp"})
      sysip.wait_until_present
      expect(sysip.value).to eq("1.2.3.4")
      sysport = @ui.get(:text_field, {id: "profile_config_general_syslogPort"})
      sysport.wait_until_present
      expect(sysport.value).to eq("555")
      expect(@ui.id('profile_config_general_syslogLevel').element(:css => ".ko_dropdownlist_button .text").text).to eq('Debug')
    end

    it "Turn on LED off toggle and save" do
      @ui.click("#ledoff .switch_label")

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "ledoff_switch"}).set?).to eq(true)
    end

    it "Reset profile advanced settings field values" do
      @ui.click("#ledoff .switch_label")
      @ui.click("#enableSyslogSwitch .switch_label")
      @ui.click("#has_NTPswitch .switch_label")
      @ui.click("#daylightswitch .switch_label")

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "daylightswitch_switch"}).set?).to eq(true)
      expect(@ui.get(:checkbox, {id: "has_NTPswitch_switch"}).set?).to eq(true)
      expect(@ui.get(:checkbox, {id: "enableSyslogSwitch_switch"}).set?).to eq(false)
      expect(@ui.get(:checkbox, {id: "ledoff_switch"}).set?).to eq(false)
    end
  end
end 