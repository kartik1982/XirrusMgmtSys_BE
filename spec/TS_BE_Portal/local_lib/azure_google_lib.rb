shared_examples "Verify GAP Localization" do |opt, gap_name|
  context "#{opt[:name]} Localization" do

    before :all do
      puts "Configure a Localization"
      update_gap_option({locale: opt[:locale]}, gap_name)

      puts "ARRAY SERIAL: #{@array_serial}"
      @browser = new_device_splash(@array_mac)
      sleep 8
    end

    after :all do @browser.quit unless @browser.nil? end

    it "Verify Splash page prompts user for OneClick authentication title text in English" do
      text = @browser.text
      expect(text).to include(opt[:splash_page_prompt_text][:title])
    end

    it "Verify Splash page prompts user for OneClick authentication connect button text in French" do
      text = @browser.input({id: "connect_submit"}).value
      expect(text).to include(opt[:splash_page_prompt_text][:connect_btn])
    end

    it "Verify Splash page prompts user for OneClick authentication footer text in Spanish" do
      text = @browser.div(css: ".poweredbyxirrus").text
      expect(text).to include(opt[:splash_page_prompt_text][:footer])
    end

  end
end

shared_examples "Verify GAP Expiration" do |opt, gap_name|
  context "#{opt[:name]} Expiration" do

    before :all do
      puts "Configure a Localization"
      update_gap_option({locale: opt[:locale]}, gap_name)

      puts "ARRAY SERIAL: #{@array_serial}"
      @browser = new_device_splash(@array_mac)
      sleep 8
    end

    after :all do @browser.quit unless @browser.nil? end

    it "When session expires the user is presented with an expiration page in French" do
      text = @browser.div(class: "session_expired").text
      expect(text).to eql(opt[:splash_page_prompt_text][:expiration_text])
    end

    it "When the same user tries to log in again he is presented with expiration page in French" do
      text = @browser.div(class: "reentry").text
      expect(text).to eql(opt[:splash_page_prompt_text][:reentry_text])
    end
  end
end

shared_examples "Verify GAP Expiration Forever" do |opt, gap_name|
  context "#{opt[:name]} Expiration" do

    before :all do
      puts "Configure a Localization"
      update_gap_option({locale: opt[:locale]}, gap_name)

      puts "ARRAY SERIAL: #{@array_serial}"
      @browser = new_device_splash(@array_mac)
      sleep 8
    end

    after :all do @browser.quit unless @browser.nil? end

    it "When session expires the user is presented with an expiration page in French" do
      text = @browser.div(class: "session_expired").text
      expect(text).to eql(opt[:splash_page_prompt_text][:expiration_text])
    end

    it "When the same user tries to log in again he is presented with expiration page in French" do
      el = @browser.div(class: "reentry")
      expect(el.visible?).to be false
    end
  end
end

#######################
### AZURE && GOOGLE ###
#######################
shared_examples "Authorise Azure GAP" do |opt|

  # Authorize Azure GAP and check Authorization
  context "Authorise" do

    before :all do
      @ui.goto_guestportal(opt[:gap_name])

      container = @ui.css(".azure-container")
      container.wait_until_present
      sleep 5
      @browser.send_keys(:control, :subtract)
      @browser.send_keys(:control, :subtract)
      authorize_btn = container.button(text: "Authorize")
      #@browser.scroll.to authorize_btn
      sleep 3
      #authorize_btn.click
      if @browser.button(:value,"Authorize").present?
        @browser.button(:value,"Authorize").click
      else
        puts "Failed to click the Authorize button".to_yaml
      end
      
      sleep 15
      if @ui.id("confirmButtons").present?
        @browser.a(text: "Yes").click
        sleep 8
      end
    end

    it "Switch to newly opened Azure login window" do
      @browser.windows.last.use do
      puts "Expect new Browser was opened for Azure login"
      expect(@browser.title).to include("Sign in to your account")
      sleep 3
      @browser.div(text: "Sign in").wait_until_present
      sleep 2
      @browser.text_field(name: "loginfmt").set(opt[:special_azure_account_credentials][:email])
      sleep 2
      btn = @ui.id("idSIButton9")
      btn.wait_until_present
      btn.click
      sleep 3
      @browser.text_field(name: "passwd").set(opt[:special_azure_account_credentials][:password])
      sleep 3
      @browser.button(text: "Sign in").click
      sleep 3
      accept_btn = @browser.input(value: "Accept")
      accept_btn.wait_until_present
      accept_btn.click
      sleep 3
      end
    end

    it "Switch back to original browser and save Azure GAP configurations" do
      @browser.windows.first.use do
      @ui.save_guestportal
      end
    end

    it "Verify Microsoft Azure Authorization is successfull" do
      max_attempts = 15
      attempt = 0
      while attempt < max_attempts
        text = @browser.text
        if text.include?("Successfully integrated with Azure by")
          attempt = max_attempts
        else
          puts " - On Attempt: #{attempt}"
          sleep 4
          attempt = attempt + 1
        end
      end

      expect(text).to include("Successfully integrated with Azure by:\n#{opt[:special_azure_account_credentials][:email]}")
    end
    it "Save Changes" do
      save_btn = @ui.id("guestportal_config_save_btn")
      #@browser.scroll.to save_btn
      save_btn.click
      sleep 8
    end

    if opt[:allowed_org_units]
      it "Restrict access to specific groups" do
        gap_config_res = @ng.gap_configuration(@gap_id)
        new_gap_config = gap_config_res.body
        new_gap_config['allowedGroups'] = opt[:allowed_org_units]

        update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
        expect(update_gap_config_res.body).to include("Portal Configuration updated")
      end
    end

  end

end

shared_examples "Authorise Google Login GAP" do |opt|

  # Authorize Google Login GAP and check Authorization
  context "Authorise" do

    before :all do
      @ui.goto_guestportal(opt[:gap_name])
      sleep 6

      # TODO Select section by ID as soon as it's added.
      switch_el = @browser.div(text: "Directory Synchronization").parent.div(class: "togglebox").div(css: ".fl_right.switch").checkbox
      @browser.scroll.to switch_el
      @ui.set_inlineblock_switch(switch_el, true)
      sleep 2

      authorize_btn = @browser.button(text: "Authorize")
      authorize_btn.wait_until_present
      @browser.scroll.to authorize_btn
      authorize_btn.click

      sleep 15
      if @ui.id("confirmButtons").present?
        @browser.a(text: "Yes").click
        sleep 8
      end
    end

    it "Switch to newly opened Google Login window" do
      @browser.windows.last.use

      puts "Expect new Browser was opened for Goole login"
      expect(@browser.title).to include("Sign in - Google Accounts")

      sleep 3
      @ui.id("view_container").wait_until_present
      sleep 2

      attempt = 0
      max_attempts = 10

      while attempt < max_attempts
        el = @browser.text_field(id: "identifierId")
        if el.present?
          el.set(opt[:special_google_account_credentials][:email])
          @browser.span(text: "Next").click
          sleep 4
          attempt = max_attempts
          puts "Email for Google Login is set"
        else
          puts "Trying to Login to Google. On attempt: #{attempt}"
          @browser.refresh
          sleep 8
          attempt = attempt + 1
        end
      end

      attempt = 0

      while attempt < max_attempts
        el = @browser.text_field(name: "password")
        if el.present?
          el.send_keys(opt[:special_google_account_credentials][:password])
          sleep 8
          @browser.span(text: "Next").click
          sleep 4
          attempt = max_attempts
        else
          puts "Trying to enter the password for Login Via Google Login Gap splash. On attempt: #{attempt}"
          @browser.refresh
          sleep 8
          attempt = attempt + 1
        end
      end

      sleep 3
    end

    it "Switch back to original browser and save Google Login GAP configurations" do
      @browser.windows.first.use
      @ui.save_guestportal()
    end

    it "Verify Google Login Authorization is successfull" do
      max_attempts = 15
      attempt = 0
      while attempt < max_attempts
        text = @browser.text
        if text.include?("Google Directory Administrator")
          attempt = max_attempts
        else
          puts " - On Attempt: #{attempt}"
          sleep 4
          attempt = attempt + 1
        end
      end

      expect(text).to include("Google Directory Administrator: #{opt[:special_google_account_credentials][:email]}")
    end

    it "Save Changes" do
      save_btn = @ui.id("guestportal_config_save_btn")
      @browser.scroll.to save_btn
      save_btn.click
      sleep 8
    end

    it "Add Organization units for Google directory" do
      gap_config_res = @ng.gap_configuration(@gap_id)
      new_gap_config = gap_config_res.body
      new_gap_config['allowedOrgUnits'] = opt[:allowed_org_units]

      update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
      expect(update_gap_config_res.body).to include("Portal Configuration updated")
    end

  end
end


shared_examples "GAP Max Devices" do |opt, gap_name|

  # Authorize Azure GAP and check Authorization
  if opt[:portal_type] == "AZURE_AD"
    include_examples "Authorise Azure GAP", opt.merge({gap_name: gap_name, special_azure_account_credentials: SPECIAL_AZURE_ACCOUNT_CREDENTIALS})
  end

  context "Register and Verify Max Number of devises" do

    it "verify that the maximum number of devices is 3 by default" do
      gap_config = get_gap_option_by_name()
      expect(gap_config["maxDeviceCount"]).to eql(3)
    end

    it "Specify the maximum number of devices" do
      update_gap_option({maxDeviceCount: opt[:maxDeviceCount]}, gap_name)
    end

    it "Connect devices using the same username until you get to the maximum number specified" do
      opt[:maxDeviceCount].times do |index|
        puts "Adding new user #{index}"

        @browser = XMS.new_chrome_incognito()
        @browser.goto replace_splash_device_mac(XMS.update_mac_by_number(@device_mac, index))
        sleep 2
        gap_third_party_login(opt[:users].first.merge({type: opt[:portal_type]}))

        @browser.quit unless @browser.nil?
      end
    end

    it "Verify the number of registered devices" do
      res = @ng.list_users_azure_gap(@gap_id)
      expect(res.code).to eql(200)
      expect(res.body["data"].length).to eql(1)
      expect(res.body["data"].first["email"]).to eql(opt[:users].first[:email]) unless opt[:portal_type] == "VOUCHER"
      expect(res.body["data"].first["registeredDevices"]).to eql(opt[:maxDeviceCount])
    end

    it "Attempt to connect another device exceeding the maximum, The pop-up should appear indicating that the maximum number of devices has been reached and give you the option to delete a device" do
      @browser = XMS.new_chrome_incognito()
      @browser.goto replace_splash_device_mac(XMS.update_mac_by_number(@device_mac, opt[:maxDeviceCount] + 2))
      gap_third_party_login(opt[:users].first.merge({type: opt[:portal_type]}), "guest-#{@env}.cloud.xirrus.com")

      sleep 4
      puts "Expect max limit to exceed"
      el = @browser.div(id: "manage_devices_msg_req")
      el.wait_until_present
      device_list = @browser.div(id: "managedevices_select").divs(class: "device")
      connect_btn = @browser.input(id: "connect_device")

      expect(el.text).to eql("You can have up to #{opt[:maxDeviceCount]} devices registered. You must remove devices before you can connect with any new devices.")
      expect(device_list.length).to eql(opt[:maxDeviceCount])
      expect(connect_btn.enabled?).to be false

      @browser.quit unless @browser.nil?
    end
  end
  context "Register a new device after an old device has been deleted" do
    before :all do
      @browser = XMS.new_chrome_incognito()
      @browser.goto replace_splash_device_mac(XMS.update_mac_by_number(@device_mac, opt[:maxDeviceCount] + 3))
      gap_third_party_login(opt[:users].first.merge({type: opt[:portal_type]}), "guest-#{@env}.cloud.xirrus.com")
    end

    it "Remove and Verify devise has been succefully removed" do
      sleep 2
      el = @browser.div(id: "managedevices_select")
      el.wait_until_present
      device_rm_btn = el.divs(class: "device").first.div(class: "device-delete")
      device_rm_btn.click
      sleep 3

      dialog = @browser.div(id: "device-delete-confirm")
      dialog.wait_until_present

      txt = dialog.text
      expect(txt).to include("Confirm Removal?")
      expect(txt).to include("Please confirm that you want to remove:")

      puts "Remove specified devise"
      sleep 2
      confirm_btn = @browser.div(id: "confirmButtons").a(id: "_jq_dlg_btn_2")

      confirm_btn.click
      sleep 5
    end

    it "Verify the number of registered devices one less then Max: #{opt[:maxDeviceCount]}" do
      if opt[:portal_type] == "AZURE_AD"
        res = @ng.list_users_azure_gap(@gap_id)
      elsif opt[:portal_type] == "VOUCHER" || opt[:portal_type] == "GOOGLE_APPS"
        res = @ng.list_vouchers_for_voucher_access_portal(@gap_id)
      else
        throw "UNKNOWN GAP, Please define the new CASE explicitely"
      end

      expect(res.code).to eql(200)
      expect(res.body["data"].first["registeredDevices"]).to eql(opt[:maxDeviceCount] - 1)
    end

    it "Verify Connnect button is enabled" do
      connect_btn = @browser.input(id: "connect_device")
      connect_btn.wait_until_present
      expect(connect_btn.enabled?).to be true
    end

    it "register new device after an old device has been deleted" do
      @browser.input(id: "connect_device").click
      sleep 5
    end

    it "Verify the number of registered devices is Max: #{opt[:maxDeviceCount]}" do
      if opt[:portal_type] == "AZURE_AD"
        res = @ng.list_users_azure_gap(@gap_id)
      elsif opt[:portal_type] == "VOUCHER" || opt[:portal_type] == "GOOGLE_APPS"
        res = @ng.list_vouchers_for_voucher_access_portal(@gap_id)
      else
        throw "UNKNOWN GAP, Please define the new CASE explicitely"
      end

      expect(res.code).to eql(200)
      expect(res.body["data"].first["registeredDevices"]).to eql(opt[:maxDeviceCount])
    end

    after :all do
      #@browser.quit unless @browser.nil?
    end
  end

  unless opt[:portal_type] == "AZURE_AD" || opt[:portal_type] == "VOUCHER"
    context "Allowed domains validation" do
      before :all do
        @browser = XMS.new_chrome_incognito()
        @browser.goto replace_splash_device_mac(XMS.update_mac_by_number(@device_mac, opt[:maxDeviceCount] + 4))
      end

      after :all do @browser.quit unless @browser.nil? end

      it "Try to register a devise from not specified domain" do
        if opt[:portal_type] == "GOOGLE_APPS"
          update_gap_option({allowedDomains: ["macadamian.com"]}, gap_name)
        end
        sleep 3

        gap_third_party_login(opt[:users].last.merge({type: opt[:portal_type]}), "guest-#{@env}.cloud.xirrus.com")
        sleep 8

        attempt = 0
        max_attempts = 6
        while attempt < max_attempts
          el = @browser.div(text: "Login Failed")
          if el.present?
            attempt = max_attempts
          else
            puts "Trying to get Wrong domain Warrning. On attempt: #{attempt}"
            @browser.refresh
            sleep 8
            attempt = attempt + 1
          end
        end

        expect(el.present?).to be true
        expect(@browser.text.downcase).to include("Send a message to the administration for further assistance".downcase)
        expect(@browser.a(css: ".button.orange").text.downcase).to include("Login with a different account.".downcase) unless opt[:portal_type] == "GOOGLE_APPS"
      end

    end
  end
end
