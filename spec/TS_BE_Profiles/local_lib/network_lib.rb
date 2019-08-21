shared_examples "update profile network settings" do |profile_name|
  describe "Update profile network settings" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      @ui.click('#profile_config_tab_network')
    end

    it "Update the ip address to set on AP and save" do
      @ui.click('#profile_config_network_useDhcpIP1_label')
      sleep 1

      @ui.save_profile
      sleep 1

      expect(@ui.get(:radio, { id: 'profile_config_network_useDhcpIP1' }).set?).to eq(true)
      expect(@ui.get(:radio, { id: 'useDhcpSwitch1' }).set?).to eq(true)
    end

    it "Update the ip address to static and save" do
      @ui.click('#profile_config_network_useDhcpIP2_label')
      sleep 1

      @ui.set_input_val('#profile_config_network_domain', 'xirrus.com')
      @ui.set_input_val('#profile_config_network_dns1', '1.1.1.1')
      @ui.set_input_val('#profile_config_network_dns2', '1.1.1.2')
      @ui.set_input_val('#profile_config_network_dns3', '1.1.1.3')

      @ui.save_profile
      sleep 1

      expect(@ui.get(:radio, {id: 'profile_config_network_useDhcpIP2' }).set?).to eq(true)
      expect(@ui.get(:radio, {id: 'useDhcpSwitch2' }).set?).to eq(true)

      expect(@ui.css('#profile_config_network_domain').value).to eq("xirrus.com")
      expect(@ui.css('#profile_config_network_dns1').value).to eq("1.1.1.1")
      expect(@ui.css('#profile_config_network_dns2').value).to eq("1.1.1.2")
      expect(@ui.css('#profile_config_network_dns3').value).to eq("1.1.1.3")
    end

    it "Update the ip address to DHCP and save" do
      @ui.click('#useDhcpSwitch0_label')
      sleep 1

      @ui.save_profile
      sleep 1

      expect(@ui.get(:radio, {id: 'useDhcpSwitch0' }).set?).to eq(true)
      expect(@ui.get(:radio, {id: 'profile_config_network_useDhcpIP0' }).set?).to eq(true)
    end

    it "Show advanced options" do
      adv = @ui.id("network_show_advanced")
      adv.wait_until_present
      if(adv.text=="Show Advanced")
        @ui.click('#network_show_advanced')
      end
      sleep 1
    end

    it "Update CDP and save" do
      @ui.click('#profile_config_network_enableCDP .switch_label')
      @ui.set_input_val('#profile_config_network_cdpinterval', '90')
      @ui.set_input_val('#profile_config_network_cdpholdtime', '160')

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "profile_config_network_enableCDP_switch"}).set?).to eq(true)
      expect(@ui.css('#profile_config_network_cdpinterval').value).to eq("90")
      expect(@ui.css('#profile_config_network_cdpholdtime').value).to eq("160")
    end

    it "Update LLDP and save" do
      @ui.click('#profile_config_network_enableLLDP .switch_label')
      @ui.set_input_val('#profile_config_network_lldpinterval', '90')
      @ui.set_input_val('#profile_config_network_lldpholdtime', '160')
      @ui.click('#profile_config_network_ethernet_lldp .switch_label')

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "profile_config_network_enableLLDP_switch"}).set?).to eq(true)
      expect(@ui.css('#profile_config_network_lldpinterval').value).to eq("90")
      expect(@ui.css('#profile_config_network_lldpholdtime').value).to eq("160")
      expect(@ui.get(:checkbox, {id: "profile_config_network_ethernet_lldp_switch"}).set?).to eq(true)
    end

    it "Update auto negotiate and save" do
      @ui.click('#profile_config_network_ethernet_autonegotiate .switch_label')
      @ui.click('#profile_config_network_ethernet_duplex .switch_label')
      @ui.set_dropdown_entry('profile_config_networks_ethernetspeed', '100 Megabit')

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "profile_config_network_ethernet_autonegotiate_switch"}).set?).to eq(false)
      expect(@ui.get(:checkbox, {id: "profile_config_network_ethernet_duplex_switch"}).set?).to eq(false)
      expect(@ui.css('#profile_config_networks_ethernetspeed .ko_dropdownlist_button .text').text).to eq('100 Megabit')
    end

    it "Update MTU and save" do
      @ui.set_input_val('#profile_config_network_mtu', '1600')

      @ui.save_profile
      sleep 1

      expect(@ui.css('#profile_config_network_mtu').value).to eq("1600")
    end

    it "Enable VLAN support, add a vlan and save" do
      @ui.click('#profile_config_network_enableVLAN .switch_label')
      @ui.set_input_val('#profile-config-network-vlans-input', '222')
      @ui.click('#profile-config-network-vlans-btn')

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "profile_config_network_enableVLAN_switch"}).set?).to eq(true)
      expect(@ui.css('.profile-config-network-vlans .tagControlContainer').spans(:class => 'tag').length).to eq(1)
    end

    it "Disable VLAN support and save" do
      @ui.click('#profile_config_network_enableVLAN .switch_label')
      @ui.confirm_dialog
      sleep 1

      @ui.save_profile
      sleep 1

      expect(@ui.get(:checkbox, {id: "profile_config_network_enableVLAN_switch"}).set?).to eq(false)
    end

  end
end 