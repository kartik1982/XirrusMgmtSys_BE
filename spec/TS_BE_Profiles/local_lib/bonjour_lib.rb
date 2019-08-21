 def bonjour_config(config)
    config = eval(config)
    sleep 2
    if config[:bonjour_status][0] == 'yes'
      if @browser.div(:class => 'field_title',:text => 'Services').present?
        puts 'Bonjour forwarding is already enabled'
      else
        @browser.div(:id => 'profile_config_bonjour_enableForwarding').label(:class => 'switch_label').click
      end
      if config[:services] != nil

        if @browser.a(:id => 'profile_config_bonjour_service_deselect_all').present?
          @browser.a(:id => 'profile_config_bonjour_service_deselect_all').click
        end

        if config[:services] != 'Select All' && config[:services] != 'Deselect All'

          for k in 0..config[:services].length-1 do

            for serv in 0..@browser.div(:class => 'select_list scrollable').ul(:class => 'services_list').lis.length-1  do

              if @browser.div(:class => 'select_list scrollable').ul(:class => 'services_list').lis[serv].text == config[:services][k]
                @browser.div(:class => 'select_list scrollable').ul(:class => 'services_list').lis[serv].input(:type => 'checkbox').click
              end

            end

          end
        else
          @browser.a(:id => "profile_config_bonjour_service_#{config[:services].downcase.split(' ')[0]}_all").click
        end

      end

      if config[:vlan] != nil

        if @browser.div(:class => 'vlans_list tagControlContainer').span.present?

          for u in 0..@browser.div(:class => 'vlans_list tagControlContainer').spans(:class => 'tag withDelete').length-1 do
            @browser.div(:class => 'vlans_list tagControlContainer').spans(:class => 'tag withDelete')[0].span(:class => 'delete').click
            @browser.div(:id => 'confirmButtons').a(:id => '_jq_dlg_btn_1').wait_until_present
            @browser.div(:id => 'confirmButtons').a(:id => '_jq_dlg_btn_1').click
            sleep 1
          end

        end

        for m in 0..config[:vlan].length-1 do

          @browser.input(:id => 'profile_config_bonjour_add_default_vlan_input').click
          @browser.send_keys ["#{config[:vlan][m]}", :enter]
          @browser.a(:id=> 'profile_config_bonjour_add_default_vlan_btn').click

        end

      end

      if config[:vlan_overrides] != nil

        for o in 0..@browser.div(:class => 'override_list tagControlContainer ko_container ui-sortable').spans(:class => 'tag withDelete').length-1 do
          @browser.div(:class => 'override_list tagControlContainer ko_container ui-sortable').spans(:class => 'tag withDelete')[0].span(:class => 'delete').click
          @browser.div(:id => 'confirmButtons').a(:id => '_jq_dlg_btn_1').wait_until_present
          @browser.div(:id => 'confirmButtons').a(:id => '_jq_dlg_btn_1').click
          sleep 1
        end

        for n in 0..config[:vlan_overrides][0].length-1 do

          @browser.div(:id => 'profile_config_bonjour_default_overrides').input(:class => 'ko_dropdownlist_combo_input').click

          input_length = @browser.div(:id => 'profile_config_bonjour_default_overrides').input(:class => 'ko_dropdownlist_combo_input').value.length

          for z in 1..input_length
            @browser.send_keys :backspace
            @browser.send_keys :delete
          end

          @browser.send_keys ["#{config[:vlan_overrides][0].keys[n]}",:enter]

          @browser.input(:id => 'profile_config_bonjour_override_vlan_input').click

          for t in 0..config[:vlan_overrides][0].values[n].length-1 do
            @browser.send_keys ["#{config[:vlan_overrides][0].values[n][t]}",","]
          end

          @browser.a(:id => 'profile_config_bonjour_override_add').click
        end

      end

      if config[:add_custom] != nil
        @browser.div(:class=> 'add_items').input(:id => 'profile_config_bonjour_service_input').wait_until_present


        for y in 0..config[:add_custom].length-1 do
          @browser.div(:class=> 'add_items').input(:id => 'profile_config_bonjour_service_input').click
          @browser.send_keys "#{config[:add_custom][y]}"
          @browser.a(:id => 'profile_config_bonjour_service_add').wait_until_present
          @browser.a(:id => 'profile_config_bonjour_service_add').click
        end

      end

    end

    if config[:bonjour_status][0] == 'no' && @browser.div(:class => 'field_title', :text=> 'Services').present?
        @browser.span(:class => 'middle').click

    end
  end
shared_examples "update profile bonjour settings" do |profile_name|
  describe "Update profile bonjour settings" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_config_tab_bonjour')
    end

    it "Enable vlan" do
      box = @ui.css('.forwarding_options .togglebox')
      box.wait_until_present
      expect(box.attribute_value('class')).to eq("togglebox disabled")

      @ui.click('#profile_config_bonjour_enablevlan')

      @ui.save_profile
      sleep 1

      box.wait_until_present
      expect(box.attribute_value('class')).to_not eq("togglebox disabled")
    end

    it "Enable forwarding" do
      @ui.click('#profile_config_bonjour_enableForwarding .switch_label')

      @ui.save_profile
      sleep 1

      box = @ui.id('profile_config_bonjour_content_container')
      expect(box.attribute_value('class')).to eq("togglebox_contents active")
    end

    it "Add a service" do
      @ui.click('.services_list .service_item label')

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {css: ".services_list .service_item .mac_chk"}).set?).to eq(true)
    end

    it "Remove a service" do
      @ui.click('.services_list .service_item label')

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {css: ".services_list .service_item .mac_chk"}).set?).to eq(false)
    end

    it "Select all services" do
      @ui.click('#profile_config_bonjour_service_select_all')

      @ui.save_profile
      sleep 1

      p = @ui.css('.services_list')
      lis = p.lis(:css => '.service_item')
      checked = 0

      lis.each { |li|
        if(li.checkbox.set?)
              checked = checked + 1
        end
      }

      expect(lis.length).to eq(checked)
    end

    it "Deselect all services" do
      @ui.click('#profile_config_bonjour_service_deselect_all')

      @ui.save_profile
      sleep 1

      p = @ui.css('.services_list')
      lis = p.lis(:css => '.service_item')
      checked = 0

      lis.each { |li|
        if(li.checkbox.set?)
              checked = checked + 1
        end
      }

      expect(checked).to eq(0)
    end

    it "Add a vlan" do
      @ui.set_input_val('#profile_config_bonjour_add_default_vlan_input','111')
      @ui.click('#profile_config_bonjour_add_default_vlan_btn')

      @ui.save_profile
      sleep 1

      list = @ui.id('profile_config_bonjour_vlan_list')
      list.wait_until_present
      tag = list.span(:css => '.tag')
      tag.wait_until_present
      expect(tag.span(:css => '.text').text).to eq('(VLAN 111)')
    end

    it "Remove a vlan" do
      list = @ui.id('profile_config_bonjour_vlan_list')
      list.wait_until_present
      tag = list.span(:css => '.tag')
      tag.wait_until_present
      tag.span(:css => '.delete').click
      sleep 1
      @ui.confirm_dialog
      sleep 1

      @ui.save_profile
      sleep 1

      expect(list.spans(:css => '.tag').length).to eq(0)
    end

    it "Add a vlan override" do
      @ui.set_input_val('#profile_config_bonjour_override_tag_input input', 'TAG')
      @ui.click('#ko_dropdownlist_overlay')
      @ui.set_input_val('#profile_config_bonjour_override_vlan_input','111,222')
      @ui.click('#profile_config_bonjour_override_add')

      @ui.save_profile
      sleep 1

      list = @ui.id('profile_config_bonjour_overrides_list')
      list.wait_until_present
      tag = list.span(:css => '.tag')
      tag.wait_until_present
      expect(tag.span(:css => '.text').text).to include('TAG (VLAN')
      expect(tag.span(:css => '.text').text).to include('111')
      expect(tag.span(:css => '.text').text).to include('222')
    end

    it "Remove a vlan override" do
      list = @ui.id('profile_config_bonjour_overrides_list')
      list.wait_until_present
      tag = list.span(:css => '.tag')
      tag.wait_until_present
      tag.span(:css => '.delete').click
      sleep 1
      @ui.confirm_dialog
      sleep 1

      @ui.save_profile
      sleep 1

      expect(list.spans(:css => '.tag').length).to eq(0)
    end

    it "Disable VLAN" do
      @ui.click('#profile_config_tab_network')
      @ui.click('#profile_config_network_enableVLAN .switch_label')
      @ui.confirm_dialog
      sleep 1

      @ui.save_profile
      sleep 2

      expect(@ui.get(:checkbox, {id: "profile_config_network_enableVLAN_switch"}).set?).to eq(false)
      sleep 2

      @ui.click('#profile_config_tab_bonjour')

      box = @ui.css('.forwarding_options .togglebox')
      box.wait_until_present
      expect(box.attribute_value('class')).to eq("togglebox disabled")            
    end
  end
end