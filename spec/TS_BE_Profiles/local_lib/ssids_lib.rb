shared_examples "add profile ssid" do |profile_name, ssid_name|
   describe "Add profile ssid" do
      before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
      end

      it "add an ssid" do
            @ui.click('#profile_ssid_addnew_btn')

            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.set_input_val("#profile_ssids_grid_ssidName_inline_edit_"+tr.id, ssid_name)
            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            name_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(2) .inner span')
            name_val.wait_until_present
            expect(name_val.title).to eq('ssid')
      end
   end
end

shared_examples "edit profile ssid" do |profile_name|
    describe "Edit profile ssid" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "edit an ssid and change band" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(3) .inner span')

            @ui.set_dropdown_entry('profile_ssids_grid_band_select_'+tr.id, '5GHz')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            band = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(3) .inner span')
            band.wait_until_present
            expect(band.title).to eq('5GHz')
        end

        it "edit an ssid and disable" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(5) .inner span') 

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(5) .inner .switch .switch_label')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            enable_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(5) .inner span')
            enable_val.wait_until_present
            expect(enable_val.title).to eq('No')
        end

        it "edit an ssid and turn broadcast off" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present
            
            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(6) .inner span')
            sleep 1

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(6) .inner .switch .switch_label')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            broadcast_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(6) .inner span')
            broadcast_val.wait_until_present
            expect(broadcast_val.title).to eq('No')
        end

        
    end
end

shared_examples "edit profile ssid encryption/auth" do |profile_name|
    describe "Edit profile ssid encryption/auth" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "edit an ssid and set encryption/auth to WEP/Open" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present
            
            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1

            @ui.set_dropdown_entry('profile_ssids_grid_encryptionAuth_select_'+tr.id, 'WEP/Open')
            sleep 1

            @ui.set_input_val('#wep_key_1', '1234567890')
            @ui.set_input_val('#confirm_wep_key_1', '1234567890')
            @ui.set_input_val('#wep_key_2', '2234567890')
            @ui.set_input_val('#confirm_wep_key_2', '2234567890')
            @ui.set_input_val('#wep_key_3', '3234567890')
            @ui.set_input_val('#confirm_wep_key_3', '3234567890')
            @ui.set_input_val('#wep_key_4', '4234567890')
            @ui.set_input_val('#confirm_wep_key_4', '4234567890')

            @ui.click('#ssid_modal_save_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1

            @ui.click('#profile_ssids_grid_encryptionAuth_action_btn_'+tr.id)

            wep1 = @ui.get(:text_field, {id: 'wep_key_1' })
            wep1.wait_until_present
            expect(wep1.value).to eq("--------")

            wep2 = @ui.get(:text_field, {id: 'wep_key_2' })
            wep2.wait_until_present
            expect(wep2.value).to eq("--------")

            wep3 = @ui.get(:text_field, {id: 'wep_key_3' })
            wep3.wait_until_present
            expect(wep3.value).to eq("--------")

            wep4 = @ui.get(:text_field, {id: 'wep_key_4' })
            wep4.wait_until_present
            expect(wep4.value).to eq("--------")

            @ui.click('#ssid_modal_cancel_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            eauth_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('WEP/Open')

            #reset
            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1
            @ui.set_dropdown_entry('profile_ssids_grid_encryptionAuth_select_'+tr.id, 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end

        it "edit an ssid and set encryption/auth to WPA2/802.1x PSK" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present
            
            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1

            @ui.set_dropdown_entry('profile_ssids_grid_encryptionAuth_select_'+tr.id, 'WPA2/802.1x')
            sleep 1

            @ui.click('#ssid_modal_tab_auth')
            sleep 1

            @ui.set_input_val('#preshare', '1234567890')
            @ui.set_input_val('#preshare_confirm', '1234567890')

            @ui.click('#ssid_modal_save_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1 

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1

            @ui.click('#profile_ssids_grid_encryptionAuth_action_btn_'+tr.id)

            @ui.click('#ssid_modal_tab_auth')
            sleep 1

            p = @ui.get(:text_field, {id: 'preshare' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            @ui.click('#ssid_modal_cancel_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            eauth_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('WPA2/802.1x')

            #reset
            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1
            @ui.set_dropdown_entry('profile_ssids_grid_encryptionAuth_select_'+tr.id, 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end

        it "edit an ssid and set encryption/auth to WPA2/802.1x EAP" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present
            
            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1

            @ui.set_dropdown_entry('profile_ssids_grid_encryptionAuth_select_'+tr.id, 'WPA2/802.1x')
            sleep 1

            @ui.click('#ssid_modal_tab_auth')
            sleep 1

            @ui.click('#eapPskSwitch .switch_label')
            @ui.click('#ssid_modal_addsecnd_sec_btn')
            @ui.click('#encryption_accountingSwitch .switch_label')
            @ui.click('#ssid_modal_use_altaccount')
            @ui.click('#ssid_modal_addsecnd_auth_btn')

            @ui.set_input_val('#host', '1.2.3.4')
            @ui.set_input_val('#port', '111')
            @ui.set_input_val('#share', '12345678')
            @ui.set_input_val('#share_confirm', '12345678')

            @ui.set_input_val('#secondary_host', '2.2.3.4')
            @ui.set_input_val('#secondary_port', '211')
            @ui.set_input_val('#secondary_share', '22345678')
            @ui.set_input_val('#secondary_share_confirm', '22345678')

            @ui.set_input_val('#primary_accounting_host', '3.2.3.4')
            @ui.set_input_val('#primary_accounting_port', '311')
            @ui.set_input_val('#primary_accounting_share', '32345678')
            @ui.set_input_val('#primary_accounting_share_confirm', '32345678')

            @ui.set_input_val('#secondary_accounting_host', '4.2.3.4')
            @ui.set_input_val('#secondary_accounting_port', '411')
            @ui.set_input_val('#secondary_accounting_share', '42345678')
            @ui.set_input_val('#secondary_accounting_share_confirm', '42345678')

            @ui.set_input_val('#accounting_radius_interval', '200')

            @ui.click('#ssid_modal_save_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1 

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1

            @ui.click('#profile_ssids_grid_encryptionAuth_action_btn_'+tr.id)

            @ui.click('#ssid_modal_tab_auth')
            sleep 1

            p = @ui.get(:text_field, {id: 'host' })
            p.wait_until_present
            expect(p.value).to eq("1.2.3.4")
            p = @ui.get(:text_field, {id: 'port' })
            p.wait_until_present
            expect(p.value).to eq("111")
            p = @ui.get(:text_field, {id: 'share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'secondary_host' })
            p.wait_until_present
            expect(p.value).to eq("2.2.3.4")
            p = @ui.get(:text_field, {id: 'secondary_port' })
            p.wait_until_present
            expect(p.value).to eq("211")
            p = @ui.get(:text_field, {id: 'secondary_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'primary_accounting_host' })
            p.wait_until_present
            expect(p.value).to eq("3.2.3.4")
            p = @ui.get(:text_field, {id: 'primary_accounting_port' })
            p.wait_until_present
            expect(p.value).to eq("311")
            p = @ui.get(:text_field, {id: 'primary_accounting_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'secondary_accounting_host' })
            p.wait_until_present
            expect(p.value).to eq("4.2.3.4")
            p = @ui.get(:text_field, {id: 'secondary_accounting_port' })
            p.wait_until_present
            expect(p.value).to eq("411")
            p = @ui.get(:text_field, {id: 'secondary_accounting_share' })
            p.wait_until_present
            expect(p.value).to eq("--------")

            p = @ui.get(:text_field, {id: 'accounting_radius_interval' })
            p.wait_until_present
            expect(p.value).to eq("200")

            @ui.click('#ssid_modal_cancel_btn')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            eauth_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            eauth_val.wait_until_present
            expect(eauth_val.title).to eq('WPA2/802.1x')

            #reset
            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1
            @ui.set_dropdown_entry('profile_ssids_grid_encryptionAuth_select_'+tr.id, 'None/Open')
            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "delete profile ssids" do |profile_name|
    describe "Delete profile ssids" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
            sleep 2
        end
        it "delete an ssid" do
            @ui.click('#profile_ssids_grid_header_select_all + .mac_chk_label')
            sleep 1
            @ui.click('#ssid_delete_btn')
            sleep 1
            @ui.confirm_dialog
            sleep 1

            grid = @ui.css('#profile_ssids_grid')
            grid.wait_until_present
            expect(grid.trs.length).to eq(1)
        end
    end
end

shared_examples "add honeypot ssid" do |profile_name|
   describe "Add honeypot ssid" do
      before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
      end

      it "add honeypot ssid" do
            @ui.click('#ssids_show_advanced');
            @ui.click('#ssid_honeypot_btn');

            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            name_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(2) .inner span')
            name_val.wait_until_present
            expect(name_val.title).to eq('honeypot')
      end
   end
end

shared_examples "edit honeypot ssid" do |profile_name|
   describe "Edit honeypot ssid" do
      before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
      end

      it "edit honeypot ssid and disable" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(5) .inner span') 

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(5) .inner .switch .switch_label')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            name_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(2) .inner span')
            name_val.wait_until_present
            expect(name_val.title).to eq('honeypot')

            enable_val = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(5) .inner span')
            enable_val.wait_until_present
            expect(enable_val.title).to eq('No')
        end
   end
end

shared_examples "delete honeypot ssid" do |profile_name|
   describe "Delete honeypot ssid" do
      before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
      end

      it "delete honeypot ssid" do
            @ui.click('#profile_ssids_grid_header_select_all + .mac_chk_label')
            sleep 1
            @ui.click('#ssid_delete_btn')
            sleep 1
            @ui.confirm_dialog
            sleep 1

            grid = @ui.css('#profile_ssids_grid')
            grid.wait_until_present
            expect(grid.trs.length).to eq(1)
        end
   end
end

shared_examples "toggle vlans from ssids" do |profile_name|
    describe "toggle vlans" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "toggle vlans" do
            vlan = @ui.id('toggle_vlan')
            vlan.wait_until_present

            if vlan.text.include?"Enable VLANs"
                  puts 'Turn on vlans'
                  @ui.click('#toggle_vlan')
            else
                  puts 'Turn off vlans'
                  @ui.click('#toggle_vlan')
                  @ui.confirm_dialog
            end
            
            
            sleep 1
            @ui.save_profile
        end
    end
end

shared_examples "profile ssids vlans" do |profile_name|
    describe "profile ssids vlans" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end
        it "set primary vlan" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span') 
            sleep 1

            @ui.set_input_val('#profile_ssids_grid_vlanOverrides_select_' + tr.id + ' .spinner input',"111")

            @ui.click("#profile_config_ssids_view .commonTitle")
            sleep 1

            @ui.save_profile
            sleep 1

            vlan = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner .tagWrapper .text')
            vlan.wait_until_present
            expect(vlan.text).to eq('Primary (VLAN 111)')            
        end

        it "set additional vlans - verify 32" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner .tagWrapper') 
            sleep 1

            @ui.click('#profile_ssids_grid_vlanOverrides_action_btn_' + tr.id)
            sleep 1.0

            $i = 200
            $num = 231
            while $i < $num do
                  name = "vlan" + $i.to_s
                  @ui.set_input_val('#vlan_name_field .ko_dropdownlist_combo_input', name)
                  @ui.click('#ko_dropdownlist_overlay')
                  @ui.set_input_val('#vlan_number_field', $i.to_s)
                  @ui.click('#ssid_vlan_add_btn')
                  sleep 1
                  $i += 1
            end

            @ui.click('#vlan_modal .buttons .orange')

            @ui.save_profile
            sleep 1

            expect(@ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner .tagWrapper .remainder').text).to eq('+31')

            @ui.click("#profile_config_ssids_view .commonTitle")
        end

        it "delete a vlan" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner .tagWrapper .remainder') 
            sleep 1

            tt = @ui.css('.tooltip')
            tt.wait_until_present

            @ui.click('.tooltip .withDelete .delete') 
            sleep 1

            @ui.confirm_dialog
            sleep 1

            @ui.save_profile
            sleep 1

            expect(@ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner .tagWrapper .remainder').text).to eq('+30')

            @ui.click("#profile_config_ssids_view .commonTitle")
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal splash page" do |profile_name|
    describe "Edit an ssid and change access control to captive portal splash page" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal splash page" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
            @ui.clear_mce
            @ui.insert_proceed

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('Splash')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal splash page external" do |profile_name|
    describe "Edit an ssid and change access control to captive portal splash page external" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal splash page external" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            sleep 1
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH .host .mac_chk_label')

            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1

            @ui.set_input_val('#landingpage1', 'http://xirrus-external.com')
            @ui.set_input_val('#externalsplash_redirect','12345678')
            @ui.set_input_val('#externalsplash_confirmredirect','12345678')

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('External Splash')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal login page" do |profile_name|
    describe "Edit an ssid and change access control to captive portal login page" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal login page" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LOGIN')
            @ui.click('#ssid_modal_captiveportal_btn_next')

            @ui.set_input_val('#captiveportal_radius_ip1','1.2.3.4')
            @ui.set_input_val('#captiveportal_radius_secret1','')
            @ui.set_input_val('#captiveportal_radius_secret1','12345678')
            @ui.set_input_val('#captiveportal_radius_confirmsecret1','12345678')

            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
            @ui.clear_mce
            @ui.insert_login

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('Login')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal login page external" do |profile_name|
    describe "Edit an ssid and change access control to captive portal login page external" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal login page external" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LOGIN')
            sleep 1
            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LOGIN .host .mac_chk_label')

            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1

            @ui.set_input_val('#landingpage2', 'http://xirrus-external.com')
            @ui.set_input_val('#externallogin_redirect','')
            @ui.set_input_val('#externallogin_redirect','12345678')
            @ui.set_input_val('#externallogin_confirmredirect','12345678')

            @ui.set_input_val('#captiveportal_radius_ip2','1.2.3.4')
            @ui.set_input_val('#captiveportal_radius_secret2','')
            @ui.set_input_val('#captiveportal_radius_secret2','12345678')
            @ui.set_input_val('#captiveportal_radius_confirmsecret2','12345678')

            @ui.click('#ssid_modal_addsecnd_cp_auth_btn2')
            sleep 1

            @ui.set_input_val('#captiveportal_secondary_radius_ip2','2.2.3.4')
            @ui.set_input_val('#captiveportal_secondary_radius_secret2','')
            @ui.set_input_val('#captiveportal_secondary_radius_secret2','22345678')
            @ui.set_input_val('#captiveportal_secondary_radius_confirmsecret2','22345678')

            @ui.click('#captiveportal_showadvanced')
            sleep 1

            @ui.click('#landing + .mac_radio_label')
            sleep 1

            @ui.set_input_val('#landingpage4', 'http://xirrus.com')

            @ui.click('#captiveportal_whitelist_switch .switch_label')
            sleep 1
            @ui.set_input_val('#captiveportal_new_whitelist_item', '*.xirrus.com')
            @ui.click('#captiveportal_add_whitelist_item')
            sleep 1

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('External Login')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal landing page" do |profile_name|
    describe "Edit an ssid and change access control to captive portal landing page" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal landing page" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_LANDING')
            @ui.click('#ssid_modal_captiveportal_btn_next')

            @ui.set_input_val('#landingpage3','http://langing_page.com')
            sleep 1

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('Landing')
        end
    end
end

shared_examples "edit an ssid and add an external image on the splash page" do |profile_name|
    describe "Edit an ssid and add an external image on the splash page" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and add an external image on the splash page" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
            @ui.clear_mce
            @ui.insert_proceed
            @ui.select_image_modal

            @ui.delete_existing_images_mce

            @ui.click('.mce-imagebrowser .mce-external')
            sleep 1
            @ui.set_input_val('.mce-window[aria-label="Add external image"] .mce-textbox','http://i.imgur.com/4VOBizw.jpg')
            @ui.click('.mce-window[aria-label="Add external image"] .mce-primary')
            sleep 2.0
            @ui.click('.mce-imagebrowser .mce-imagelist .mce-listitem')
            sleep 1
            @ui.click('.mce-imagebrowser .mce-primary')
            sleep 1


            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('Splash')
        end
    end
end

shared_examples "edit an ssid and add an internal image on the splash page" do |profile_name|
    describe "Edit an ssid and add an internal image on the splash page" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and add an internal image on the splash page" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_SPLASH')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            @ui.click('#ssid_modal_captiveportal_btn_next')
            sleep 1
            @ui.clear_mce
            @ui.insert_proceed
            @ui.select_image_modal

            @ui.delete_existing_images_mce

            file = Dir.pwd + "/xirrus.png"
            @browser.execute_script('$(\'input[type="file"]\').show().css({"top":"0px"})')
            sleep 1
            @browser.file_field(:css,"input[type='file']").set(file) 
            sleep 1 
            @browser.execute_script('$(\'input[type="file"]\').hide()')
            sleep 3.0

            @ui.click('.mce-imagebrowser .mce-imagelist .mce-listitem')
            sleep 1
            @ui.click('.mce-imagebrowser .mce-primary')
            sleep 1


            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('Splash')
        end
    end
end

shared_examples "edit an ssid and add a new captive portal gap" do |profile_name|
    describe "Edit an ssid and add a new captive portal gap" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and add a new captive portal gap" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')

            @ui.click('#captiveportal_new_gap')
            @ui.set_input_val('#guestportal_new_name_input', 'NEW_GAP')
            @ui.css('#guestportals_newportal .portal_type.guest').hover
            sleep 1
            @ui.click('#guestportals_newportal .portal_type.self_reg')
            sleep 1

            @ui.set_dropdown_entry('captiveportal_gaps_select', 'NEW_GAP')

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('EasyPass Portal')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal gap" do |profile_name|
    describe "Edit an ssid and change access control to captive portal gap" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal gap" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')

            @ui.set_dropdown_entry('captiveportal_gaps_select', 'self_registration')

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('EasyPass Portal')
        end
    end
end

shared_examples "edit an ssid and change access control to captive portal gap onboarding" do |profile_name|
    describe "Edit an ssid and change access control to captive portal gap onboarding" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to captive portal gap onboarding" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            dd = @ui.css('#profile_ssids_grid_accessControl_select_' + tr.id + ' .ko_dropdownlist_button .text')
            dd.wait_until_present

            if dd.text.include?"Captive Portal"
                  @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)
            else
                  @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'Captive Portal')
                  sleep 1
            end

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')

            @ui.set_dropdown_entry('captiveportal_gaps_select', 'onboarding')

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1
            @ui.confirm_dialog
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('EasyPass Portal')

            e = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            e.wait_until_present
            expect(e.title).to eq('WPA2/802.1x')
        end
    end
end

shared_examples "edit an ssid with onboarding and remove UPSK encryption" do |profile_name|
    describe "edit an ssid with onboarding and remove UPSK encryption" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid with onboarding and remove UPSK encryption" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            sleep 1

            @ui.set_dropdown_entry('profile_ssids_grid_encryptionAuth_select_'+tr.id, 'None/Open')
            sleep 1

            @ui.confirm_dialog
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1


            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('None')

            e = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            e.wait_until_present
            expect(e.title).to eq('None/Open')
        end
    end
end

shared_examples "edit an ssid with onboarding and change portal to self registration" do |profile_name|
    describe "edit an ssid with onboarding and change portal to self registration" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid with onboarding and change portal to self registration" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            @ui.click('#profile_ssids_grid_accessControl_action_btn_'+tr.id)

            @ui.click('#ssid_captiveportal_modal .CaptivePortalType_GAP')
            @ui.click('#ssid_modal_captiveportal_btn_next')

            @ui.set_dropdown_entry('captiveportal_gaps_select', 'self_registration')

            @ui.click('#ssid_modal_captiveportal_btn_save')
            sleep 1
            @ui.confirm_dialog
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('EasyPass Portal')

            e = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(4) .inner span')
            e.wait_until_present
            expect(e.title).to eq('None/Open')

            e = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(5) .inner span')
            e.wait_until_present
            expect(e.title).to eq('No')
        end
    end
end

shared_examples "edit an ssid and change access control to airwatch" do |profile_name|
    describe "edit an ssid and change access control to airwatch" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to airwatch" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'AirWatch')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('AirWatch')
        end
    end
end

shared_examples "edit an ssid and change access control to none" do |profile_name|
    describe "edit an ssid and change access control to none" do
        before :all do
            # make sure it goes to the profile 
            @ui.goto_profile profile_name
            @ui.click('#profile_config_tab_ssids')
        end

        it "edit an ssid and change access control to none" do
            tr = @ui.css('#profile_ssids_grid tbody tr:nth-child(1)')
            tr.wait_until_present

            @ui.click('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')

            @ui.set_dropdown_entry('profile_ssids_grid_accessControl_select_'+tr.id, 'None')
            sleep 1

            @ui.click("#profile_config_ssids_view .commonTitle")

            @ui.save_profile
            sleep 1

            cp = @ui.css('#profile_ssids_grid tbody tr:nth-child(1) td:nth-child(7) .inner span')
            cp.wait_until_present
            expect(cp.title).to eq('None')
        end
    end
end
