module GUI
  class UI
        def active_list
          dd_active #@browser.dd(css: ".ko_dropdownlist_list.active")
        end

      	def profile_config_view
      	  ProfileConfigView.new(@browser)
      	end
        alias_method :pcv, :profile_config_view
        
        def ssid_row(ssid_name)
          profile_config_view.ssid_grid_view.row(ssid_name)
        end

        def vlan_modal
          if @browser.div(id: "vlan_modal").present?
            @browser.div(id: "vlan_modal")
          else
            false
          end
        end

        def goto_policies(profile_name)
          goto_profile(profile_name)
          pcv.policies_tile.wait_until_present
          pcv.policies_tile.click
          get(:div, {id: "profile_config_policies"}).wait_until_present
        end

      	class ProfileConfigView
          def initialize(browser)
            @browser = browser
            @el = get(:div, {id: "profile_config_view"})
            @el.wait_until_present
          end

        def get(watir_browser_method, args = {})
          @browser.send(watir_browser_method.to_sym, args)
        end
          def el
            #get(:div, {id: "profile_config_view"})
            @el
          end

          def wait_until_present
            el.wait_until_present
          end

          # if method is called on the ProfileConfigView class that does not exist
          # see if the el = Watir::Element will handle it - this does have a performance cost
          def method_missing(name, *args)
           # puts "method_missing being called in #{self} is being sent to 'el' - #{name} with args #{args.to_s}"
            as_sym = name.to_sym 
            as_string = name.to_s
            if el.respond_to?(as_string, include_private = false)# this is experimental
              el.send(as_string,*args)
            else
              puts "#{self} does not respond_to #{name}"
              super # You *must* call super if you don't handle the
                # method, otherwise you'll mess up Ruby's method
                # lookup.
            end
          end


          def profile_menu_btn
            id("profile_menu_btn")
          end

          # valid choices "duplicate", "delete", "default"
          def select_profile_menu(choice)
            profile_menu_btn.wait_until_present
            profile_menu_btn.click
            sleep 1
            
            choice_btn = @browser.send(:a, {id: "profile_#{choice}_btn"})
            choice_btn.click
            sleep 1
          end

          def make_default
            select_profile_menu("default")
            modal = @browser.send(:div, { css: ".dialogBox.confirm" })
            modal.wait_until_present
            set_btn = modal.div(id: "confirmButtons").links[1]
            set_btn.click 
          end


          def save_all_button
            el.a(id: "profile_config_save_btn")
          end

          def save_all
            # save_all_button.wait_until_present
            # save_all_button.fire_event("onclick")
            @browser.button(:id, "profile_config_save_btn").click
            @browser.button(:value, "Push Now").click
          end

          def tile(icon_name)
            el.div(css: ".icon.#{icon_name}").wait_until_present
          	el.div(css: ".icon.#{icon_name}").parent
          end

# Tiles / Sections

          ##
          ## GENERAL Settings
          ##

          def general_tile
            tile :general
          end
          
          def profile_config_general_view
            div(id: "profile_config_general_view")
          end

          def general_settings_show_advanced_link
            a(id: "general_show_advanced")
          end

          def current_general_advanced_status
            adv_text = general_settings_show_advanced_link.text
            (adv_text == "Show Advanced") ? "hidden" : "visible"
          end

          def show_advanced_general_settings
            if current_general_advanced_status == "hidden"
              general_settings_show_advanced_link.click 
            end
          end

          def hide_advanced_general_settings
            if current_general_advanced_status == "visible"
              general_settings_show_advanced_link.click
            end
          end

          def toggle_led_switch(turn_off = false)
            ng_toggle_set("ledoff_switch", turn_off)
          end

          def led_on
            toggle_led_switch(false)
          end

          def led_off
            toggle_led_switch(true)
          end

          def toggle_syslog_switch(sys_on = false)
            ng_toggle_set("enableSyslogSwitch_switch",sys_on)
          end

          def syslog_on
            toggle_syslog_switch(true)
          end

          alias_method :turn_syslog_on, :syslog_on

          def syslog_off
            toggle_syslog_switch(false)
          end

          def syslog?
            checked_val = el.checkbox(id: "enableSyslogSwitch_switch").attribute_value("checked")
            val_to_return = (checked_val == "true") ? true : false
            val_to_return
          end

          def set_syslog_host(val)
            set_text_field_by_id("profile_config_general_syslogIp",val)
          end

          def current_syslog_host
            @browser.text_field(id: "profile_config_general_syslogIp" ).value
          end

          def set_syslog_port(val)
            set_text_field_by_id("profile_config_general_syslogPort",val)
          end

          def current_syslog_port
            @browser.text_field(id: "profile_config_general_syslogPort" ).value
          end

          def  set_syslog_level(level = "Info")
            click_drop_btn(@browser.span(id: "profile_config_general_syslogLevel"))
            sleep 1
            select_open_drop_item(level)
          end

          def current_syslog_level
            @browser.span(id: "profile_config_general_syslogLevel").span(css: ".text").text
          end


            #parent should be <a> tag
          def ssids_tile
          	t = tile :ssids
            t.wait_until_present
            t
          end

          ##
          ## Network Settings
          ##

          def network_tile
            tile :network
          end

          def profile_config_network_view
            @browser.div(id: "profile_config_network_view")
          end

          def network_settings_show_advanced_link
            @browser.a(id: "network_show_advanced")
          end

          def current_network_advanced_status
            adv_link_text = network_settings_show_advanced_link.text
            (adv_link_text == "Show Advanced") ? "hidden" : "visible"
          end

          def show_advanced_network_settings
            if current_network_advanced_status == "hidden"
              network_settings_show_advanced_link.click
            end
          end

          def label_for_click(for_val)
            profile_config_network_view.label(:for => "#{for_val}").click
          end

          def set_network_ip_address_settings(dhcp_option = "set")
            label_base = "profile_config_network_useDhcpIP"
            case dhcp_option.downcase
            when "dhcp"
              label_for_click("#{label_base}0")
            when "set"
              label_for_click("#{label_base}1")
            when "static"
              label_for_click("#{label_base}2")
            else
              false
            end
          end


          def set_dns_switch(dns_option = "set")
            label_base = "useDhcpSwitch"
            case dns_option.downcase
            when "dhcp"
              label_for_click("#{label_base}0")
            when "set"
              label_for_click("#{label_base}1")
            when "static"
              label_for_click("#{label_base}2")
            else
              false
            end
          end

        
          # Network Tile DNS Settings 
          def set_dns(dns = {domain: "xirrus.com", server1: "208.67.222.222", server2: "208.67.220.220", server3: "208.67.222.222" })
            
            dns_box = get(:div, {text: "DNS (Domain Name System)"})
            dns_box.wait_until_present
            set_dns_switch("static")
            @browser.span(:text => 'Search Domain:').wait_until_present

            unless dns[:domain] == false
              set_text_field_by_id("profile_config_network_domain", dns[:domain])
            end

            unless dns[:server1] == false
              set_text_field_by_id("profile_config_network_dns1", dns[:server1] )
            end

            unless dns[:server2] == false
              set_text_field_by_id('profile_config_network_dns2', dns[:server2] )
            end

            unless dns[:server3] == false
              set_text_field_by_id('profile_config_network_dns3', dns[:server3] )
            end

          end # Network Tile DNS Settings




          def toggle_320_uplink(tagged = true)
            ng_toggle_set("profile_config_network_xr320uplink_switch", tagged)
          end

          def uplink_togglebox
            @browser.div(id: "profile_config_network_xr320uplink").parent
          end

          def uplink_vlan_spinner_input
            uplink_togglebox.text_field(id: "profile_config_xr320vlanid")
          end

          def uplink_vlan_spinner_container
            uplink_vlan_spinner_input.parent
          end

          def uplink_vlan_up_arrow
            uplink_vlan_spinner_container.span(css: '.spinner_up.up_arr')
          end

          def uplink_vlan_down_arrow
            uplink_vlan_spinner_container.span(css: '.spinner_down.down_arr')
          end

          def uplink_vlan_error
            uplink_vlan_spinner_container.span(css: ".xirrus-error")
          end

          def uplink_overrides_field
            uplink_togglebox.div(css: ".togglebox_contents").div(css: ".field.tag_overrides")
          end

          def uplink_tagname_dropdown_input
            uplink_overrides_field.text_field(css: ".ko_dropdownlist_combo_input")
          end

          def uplink_tagname_dropdown_btn
            uplink_overrides_field.span(css: ".ko_dropdownlist_combo_btn")
          end

          def vlan_spinner(parent_element)
            parent_element.send(:text_field,{css: ".vlan_input.spinner"})
          end

          def uplink_overrides_vlan_spinner
            vlan_spinner(uplink_overrides_field)
          end

          def uplink_add_vlan_override_btn
            uplink_overrides_field.a(id: "profile_config_network_xr320_override_add")
          end

          def uplink_overrides_list
            @browser.div(id: "profile_config_network_xr320_overrides_list")
          end

          def vlan_tag_items(parent_element)
            parent_element.send(:spans, {css: ".tag.withDelete"})
          end

          def uplink_overrides_listitems
            vlan_tag_items(uplink_overrides_list)
          end

          def delete_tag_item(item)
            item.span(css: ".delete").fire_event("onclick")
            sleep 2
            modal = @browser.span(text: "Remove VLAN Override?").parent.parent 
            conf_btns = modal.div(id: "confirmButtons").links
            conf_btns[1].fire_event("onclick")
          end
        
          def enable_lan_ports
            ng_toggle_set("profile_config_network_xr320vlan_switch",true)
          end

          def disable_lan_ports
            ng_toggle_set("profile_config_network_xr320vlan_switch",false)
          end
 
          def lan_port_togglebox(lan_port)
            @browser.div(id: "profile_config_network_xr320enablelan#{lan_port}")
          end

          def toggle_lan_port(lan_port, enabled = true)
            #puts lan_port_togglebox(lan_port).html
            switch = lan_port_togglebox(lan_port).inputs[0]
            switch_id = switch.attribute_value('id')
            @browser.element(id: switch_id).wd.location_once_scrolled_into_view
            ng_toggle_set(switch_id, true)
          end

          def lan_port_mode_switch_container(lan_port)
            @browser.div(id: "profile_config_network_xr320portmode#{lan_port}")
          end

          def lan_port_fields_container(lan_port)
            lan_port_mode_switch_container(lan_port).parent.parent.parent
          end

           # access or trunk
          def toggle_lan_port_mode(lan_port = 1, _mode = "access")
           
            mode_switch = lan_port_mode_switch_container(lan_port).inputs[0]
            mode_switch.wd.location_once_scrolled_into_view
            type_switch_id = mode_switch.attribute_value('id')
            mode = (_mode == "access") ? true : false
            ng_toggle_set(type_switch_id, mode)
          end

          def set_lan_port_pvid(lan_port, pvid)
            lan_port_fields_container(lan_port).text_field(id: "profile_config_xr320pvid#{lan_port}").set pvid
            @browser.send_keys :tab
          end

          def enter_lan_port_pvid_vlan_tagname(lan_port,vlan_tagname)
            lan_port_fields_container(lan_port).span(id: "profile_config_network_xr320_override_tag_input").text_field(css: ".ko_dropdownlist_combo_input").set vlan_tagname
            @browser.send_keys :tab
          end

          def enter_lan_port_pvid_vlan_id(lan_port,vlan_id)
            lan_port_fields_container(lan_port).text_field(id: "profile_config_network_xr320_override_pvid_input").set vlan_id
            @browser.send_keys :tab
          end

          def lan_port_add_pvid_vlan_btn(lan_port)
            lan_port_fields_container(lan_port).a(id: "profile_config_network_xr320_override_add")
          end

          def lan_port_add_new_pvid_vlan(lan_port,tagname,vlan_id)
            enter_lan_port_pvid_vlan_tagname(lan_port,tagname)
            enter_lan_port_pvid_vlan_id(lan_port,vlan_id)
            lan_port_add_pvid_vlan_btn(lan_port).hover
            lan_port_add_pvid_vlan_btn(lan_port).fire_event("onclick")
          end

          def enter_lan_port_vid(lan_port, vid)
            lan_port_second_fieldset(lan_port).text_field(id: "profile_config_xr320vid1").set vid 
            @browser.send_keys :tab 
          end

          def lan_port_add_vid_btn(lan_port)
            lan_port_fields_container(lan_port).a(id: "profile_config_xr320vid_add#{lan_port}")
          end

          def add_lan_port_vid(lan_port, vid)
            enter_lan_port_vid(lan_port,vid)
            lan_port_add_vid_btn(lan_port).hover
            lan_port_add_vid_btn(lan_port).fire_event("onclick")
          end

          def lan_port_second_fieldset(lan_port)
            lan_port_fields_container(lan_port).div(css: ".bottomdash.second.active")
          end

          def enter_lan_port_vid_vlan_tagname(lan_port, vid)
            lan_port_second_fieldset(lan_port).span(id: "profile_config_network_xr320_override_tag_input").text_field(css: ".ko_dropdownlist_combo_input").set vid
            @browser.send_keys :tab
          end

          def enter_lan_port_vid_vlan_id(lan_port, vlan_id)
            lan_port_second_fieldset(lan_port).text_field(id: "profile_config_network_xr320_override_allowed_input").set vlan_id
            @browser.send_keys :tab
          end

          def lan_port_add_vid_vlan_btn(lan_port)
            lan_port_second_fieldset(lan_port).a(id: "profile_config_network_xr320_override_add")
          end

          def lan_port_add_new_vid_vlan(lan_port, tagname, vlan_id)
            enter_lan_port_vid_vlan_tagname(lan_port, tagname)
            enter_lan_port_vid_vlan_id(lan_port, vlan_id)
            lan_port_add_vid_vlan_btn(lan_port).hover
            lan_port_add_vid_vlan_btn(lan_port).fire_event("onclick")
          end

          def hide_advanced_network_settings
            if current_network_advanced_status == "visible"
              network_settings_show_advanced_link.click
            end
          end

         
          ###########
          ## POLICIES

          def policies_tile
            tile :policies
          end

          def bonjour_tile
            tile :bonjour
          end

          def admin_tile
            tile :admin
          end

          def change_country(country)

            @browser.span(text: "Country:").wait_until_present
            cbc = id("profile_config_basic_country")
            cbc.a(css: ".ko_dropdownlist_button").wait_until_present
            cbc.a(css: ".ko_dropdownlist_button").click
            sleep 2
            li = @browser.li(text: country)
            li.wd.location_once_scrolled_into_view
            sleep 1
            li.wait_until_present
            li.click

          end

          def ssid_grid
          	@browser.send(:div,{id:"profile_config_ssids_view"})
          end
          
          def goto_ssid_view
          	ssids_tile.click
          end

          def ssid_grid_view
          	SsidGridView.new( get( :div, {id: "profile_config_ssids_view"} ), @browser)
          end
# SSID GRID
          class SsidGridView
            def initialize(ssid_grid_div, browser)
              @browser = browser
              @browser.div(css: ".commonSubtitle").click
              sleep 1
              # el = ssid_grid_div # possible failure - Selenium::WebDriver::Error::StaleElementReferenceError
              # http://docs.seleniumhq.org/exceptions/stale_element_reference.jsp
              @el = ssid_grid_div#get(:div,{id:"ssid_grid"})
              @el.wait_until_present
              
            end

            def el
              #get(:div,{id:"ssid_grid"})
              @el
            end

            def new_btn
              @browser.a(id: "ssid_addnew_btn")
            end
     
            def new_ssid(name)
              new_btn.click
            ######
            #
            # TODO 
            # add_ssid method exists in /lib/user_page and works for now
            #

            end


            def row(ssid_name)
              Row.new(ssid_name,@browser)
            end
# SSID ROW
            class Row
              attr_reader :name

              def initialize(ssid_name, browser)
               # puts "initializing SSID ROW"
                @name = ssid_name
              	@browser = browser
                @browser.div(css: ".commonSubtitle").click
                sleep 1
                title_span = @browser.send(:span,{title: @name})
                title_span.wait_until_present
              	@el = @browser.send(:span,{title: @name}).parent.parent.parent
              end

              def el
              	#get(:span, {title: @name}).parent.parent.parent
                @el
              end

              def this_id
                el.attribute_value("id")
              end

              def name_column
                el.send(:td, {css: '.ssidName'})
              end

              def current_name
                name_column.div(css: ".inner").span.text 
              end

              def change_name(new_name)
                el.click
                sleep 1
                name_column.div(css: ".inner").span.click 
                tf = name_column.text_field
                tf.wait_until_present
                tf.clear
                tf.value = new_name
              end

              def band_column
              	el.send(:td,{css: ".band"})
              end

              def band
                band_column.div(css: ".inner").text
              end

              def band_dropdown_button
              	band_column.a(css: ".ko_dropdownlist_button")
              end

              def band_dropdown_list
              	band_column.ul 
              end

              def band_listitem(band)
                active_list = dd_active # @browser.dd(css: ".ko_dropdownlist_list.active")
                active_list.li(text: band)
              end             	

              def change_band(band)
                puts "changing band to #{band}"
              	valid_bands = ["2.4GHz & 5GHz", "5GHz", "2.4GHz"]
              	raise(ArgumentError, "Band must be one of :  #{valid_bands.to_s}") unless valid_bands.include?(band)
              	el.click
               	band_column.div(css: ".inner").span.click
              	band_dropdown_button.click
              	sleep 1
                band_listitem(band).click

              end

              def vlan_column
                el.send(:td, {id: "#{this_id}_vlanOverrides"})
              end

              def set_vlan_spinner(vlan_value)
                el.click
                puts "Wait for SSID Grid Reload"
                sleep 1
                @el = @browser.send(:span,{title: @name}).parent.parent.parent
                @browser.input(css: ".spinner").send_keys(vlan_value)
              end # set_vlan_spinner

              def edit_vlan_btn
                vlan_column.a(text: "Edit VLANs")
              end

              def edit_vlans(args = {})
                el.click         
                if(vlan_column.a(text: "Edit VLANs").visible?)
                              
                  edit_vlan_btn.focus
                  edit_vlan_btn.send(:click)
                  sleep 10
                else
                  puts "Called ProfileConfigView::SSIDGridView::Row.edit_vlans but no NO PREVIOUS VLAN"
                end
              end

              def encryption_column
                el.send(:td, {id: "#{this_id}_encryptionAuth"})
              end

              def current_encryption
                encryption_column.send(:div, {css: ".inner"}).span.attribute_value('title')
              end             

              def encryption_dropdown_list
                encryption_column.ul
              end

              def encryption_dropdown_button
                encryption_column.a({css: ".ko_dropdownlist_button"})
              end

              def encryption_listitem(option_text)
                active_list = dd_active #@browser.dd({css: ".ko_dropdownlist_list.active"})
                active_list.li(text: option_text)
              end

              def change_enc_dropdown(enc)
                puts "change enc"
                encryption_column.div(css: ".inner").span.fire_event("onclick")
                encryption_dropdown_button.fire_event("onclick")
                sleep 1
                encryption_listitem(enc).fire_event("onclick")
              end

              def encrypt_auth_modal
                @browser.send(:div, { id: "ssid_encrypt_auth_modal"})
                #id("ssid_encrypt_auth_modal")
              end              

              def encryption_tabs
                @browser.nav(id: "encryption_tabs")
              end

              def encryption_tab
                @browser.a(id: "ssid_modal_tab_encrypt")
              end

              def authentication_tab
                @browser.a(id: "ssid_modal_tab_auth")
              end

              def encryption_modal
                @browser.div(id: "encryption_modal")
              end

              def aes_radio
                @browser.radio(id: "aes")
              end

              def tkip_radio
                @browser.radio(id: "tkip")
              end

              def aes_tkip_radio
                @browser.radio(id: "aes_tkip")
              end

              def encrypt_radio(enc_type)
                @browser.radio(id: enc_type)
              end

              def wep_authentication_modal
                @browser.div(id: "wep_authentication_modal")
              end
              
              # User for all three WAP options as well as RADIUS
              def authentication_modal 
                get(:div, {id: "authentication_modal"}) 
              end

              def authentication_modal_field_heading
                @browser.p(css: ".field_heading")
              end

              def eap_psk_switch
                authentication_modal.send(:div,{ id: "eapPskSwitch" })
              end
             
              

              def secondary_radius_button
                @browser.a(id: "ssid_modal_addsecnd_sec_btn")
              end

             

              def accounting_option
                parent_label = get(:label, {text: "Accounting:"})
                accounting_field_parent = parent_label.parent 
                accounting_field_parent.div(css: ".inlineblock.switch").checkbox(css: ".switch_checkbox")
              end

              def alternate_accounting_button
                @browser.a(id: "ssid_modal_use_altaccount")
              end

              def secondary_accounting_button
                @browser.a(id: "ssid_modal_addsecnd_auth_btn")
              end

              def ssid_modal_cancel_btn
                @browser.a(id: "ssid_modal_cancel_btn")
              end

              def ssid_modal_save_btn
                @browser.a(id: "ssid_modal_save_btn")
              end
          

              # toggles the eap_psk switch
              # eap to toggle to eap
              # all other values should set it to psk
              def switch_eap_psk(value)
                eap_psk_switch.wait_until_present
                eap_value = eap_psk_switch.checkbox(id: "eapPskSwitch_switch").attribute_value('checked')
                if eap_value.nil?
                  eap_value = false
                end
            
                  if(eap_value.to_s != value.to_s)
                     eap_psk_switch.div(css: ".middle").div(css:".toggle").click
                  else 
                   
                  end
              end   


              def switch_accounting_radio(value)
                
                accounting_label = authentication_modal.send(:label, { text: "Accounting:" } )
                accounting_switch_wrapper = accounting_label.parent
                accounting_toggle = accounting_switch_wrapper.send(:div, {css: ".toggle"} )
                accounting_toggle_value = accounting_switch_wrapper.checkbox.attribute_value('checked')
                # true = 'Yes' in UI
                if (accounting_toggle_value.to_s != value.to_s)
                  accounting_toggle.click
                else
                  
                end

              end
#############################################################
#
#  Changing the Encryption / Authentication setting for a SSID
#  
             

#
# WPA/WPA arguments
#
# Change the Encryption / Authentication settings for this SSID Row
# 
# == Parameters:
# 
# auth_option::
#   A String declaring the high level encryption/authentication protocol.
#   i.e. "WPA2/802.1x"
#   valid_options = ["None/Open", "WPA2/802.1x", "WPA & WPA2/802.1x", "WPA/802.1x", "WEP/Open", "None/RADIUS MAC"]
#
# args::
#   A Hash with all of the interior field values and options.
#   Options/Values will vary depending on auth_option.
#   WPA[x] vrs WEP vrs RADIUS
#
#   WPA args keys 
#   encrypt_type: "aes", "tkip", or "aes_tkip"
#   preshare: when encrypt_type = PSK
#   auth_type: "eap" will set as EAP, all other values or nil will set to PSK
#   host: String - usually IP address
#   port: String for port number - "1812"
#   share: String
#   share_confirm: String 
#   add_secondary: Boolean - Does not apply to WEP
#     if add_secondary = true
#   secondary_host: String - usually IP address
#   secondary_port: String for port number - "1812"
#   secondary_secret: String
#   secondary_share_confirm: String 
#   
#   accounting: Boolean 
#   alternate_accounting: Boolean
#   accounting_host: 
#   accounting_port:
#   accounting_secret:
#   accounting_share_confirm:
#   
#   secondary_accounting: Boolean
#   secondary_accounting_host:
#   secondary_accounting_port:
#   secondary_accounting_secret:
#   secondary_accounting_share_confirm:
#   accounting_radius_interval: 




              def change_encryption(auth_option, args = {})
   #             puts "starting change_encryption..."
                configure_previous = false
                valid_options = ["None/Open", "WPA2/802.1x", "WPA & WPA2/802.1x", "WPA/802.1x", "WEP/Open", "None/RADIUS MAC"]
                raise(ArgumentError, "Encryption/Authentication option must be one of : #{valid_options.to_s}") unless valid_options.include?(auth_option)
                ## 
                # No need to go through all the work if None/Open
              
                 primary_host_fields = %w[host port] # do not not need to use share or share confirm if row was previously confirgured
                 secondary_host_fields = %w[secondary_host secondary_port]
                 primary_accounting_fields = %w[primary_accounting_host primary_accounting_port]
                 secondary_accounting_fields = %w[secondary_accounting_host secondary_accounting_port]
                # el refers to this

             
                # CLICK THE CURRENT ROW  
                el.click         
                

              # Checking if SSID already had previously configured Encryption
              # This will change which elements you need WebDriver to click 

                # encryption_column.div(css: ".inner").span.click
                # if this SSID has already had encryption configured
                # selecting the auth_option will not bring up the modal
                # there should be a 'Configure' button

                if(encryption_column.a(text: "Configure").visible?)
                              
                  configure_button = encryption_column.a(title: "Configure") # changed to title
                  configure_previous = true
                
                # if this ssid row has already set the auth_option to the same then
                # you will need to click the configure button instead of just selecting the list item
                    if current_encryption.to_s == auth_option.to_s
              
                      configure_button.focus
                      configure_button.send(:click)
               
                    end
                  ################################################ 
          ##
          # POTENTIAL GOTCHA
                  # NOT A PREVIOUSLY CONFIGURED ROW
                  # APPEND SHARE AND SHARE_CONFIRM Fields 
                  # This is far from perfect solution as the configuration may want to create a secondary share for the first time
                  # after creating on original share
          ###################################################

                 else
                 # this SSID row was not previously configured with the same auth_option,
                 # changing of the dropdown will bring up the encryption/authentication config modal
               
                   sleep 1
                   change_enc_dropdown(auth_option)

            # these were separated out from the initial fields because of issues
            # inputing text in share and share_confirm(password) fields -
            # when SSIDS that already had encryption/authentication previously configured 

                  primary_host_fields << "share"
                  primary_host_fields << "share_confirm"

                  secondary_host_fields << "secondary_share"
                  secondary_host_fields << "secondary_share_confirm"

                  primary_accounting_fields << "primary_accounting_share"
                  primary_accounting_fields << "primary_accounting_share_confirm"

                  secondary_accounting_fields << "secondary_accounting_share"
                  secondary_accounting_fields << "secondary_accounting_share_confirm"
              ##                
                 end                             
          ##
          #  TODO: WEP MODAL
                if auth_option.include? "WEP"

                  
                  
                elsif  auth_option == "None/Open"


          ##
          # WPA auth_options: "WPA2/802.1x", "WPA & WPA2/802.1x", "WPA/802.1x"
                elsif auth_option.include? "WPA"

                  new_encrypt_auth_modal = id("ssid_encrypt_auth_modal")
                  new_encrypt_auth_modal.wait_until_present

                  enc_modal = new_encrypt_auth_modal.div(id: "encryption_modal")
                  enc_modal.wait_until_present

                  
                  id( args[:encrypt_type] ).parent.label.wait_until_present
                  id( args[:encrypt_type] ).parent.label.click
                  
                  authentication_tab.click
                  
                  auth_modal = new_encrypt_auth_modal.div(id: "authentication_modal")
                  auth_modal.wait_until_present

                  if args[:auth_type] == 'eap' 
                   new_eap_switch_value = 'true'
                  else 
                   new_eap_switch_value = 'false' 
                  end
                  switch_eap_psk(new_eap_switch_value)
            
########
#
# PSK
                if args[:auth_type].downcase == 'psk' 
                   
                   psk_fields = %w[preshare preshare_confirm]
                   set_array_of_text_fields(psk_fields, args)
#########
#
# EAP
                else 

                     auth_modal.text_field(id: "host").wait_until_present
                    # setting primary host properties
                    #primary_host_fields = %w[host port share share_confirm]
                    set_array_of_text_fields(primary_host_fields,args)
                    
                    if(args[:add_secondary] == true)
                      if(secondary_radius_button.text.include?"Add") # if the button does not have Add then the fields should already be exposed
                        secondary_radius_button.click
#sleep 1
                      end
                      #secondary_host_fields = %w[secondary_host secondary_port secondary_secret secondary_secret_confirm]
                      set_array_of_text_fields(secondary_host_fields, args)
#sleep 1

                    else # add_secondary false, click the Remove button 
                      if(secondary_radius_button.text.include?"Remove")
                        secondary_radius_button.click
#sleep 1
                      end
                    end # add_secondary = true

                    if(args[:accounting] == true)

                      switch_accounting_radio(args[:accounting])

                      if(args[:alternate_accounting] == true)

                        if(alternate_accounting_button.text.include?"Use")
                          alternate_accounting_button.click
                          #sleep 1
                        end

                        #alternate_accounting_fields = %w[accounting_host accounting_port accounting_secret accounting_secret_confirm]
                        set_array_of_text_fields(primary_accounting_fields, args)
#sleep 1
                     
                        if(args[:secondary_accounting] == true)
                          if(secondary_accounting_button.text.include?"Add")
                            secondary_accounting_button.click
                            #sleep 1
                          end
                          #secondary_accounting_fields = %w[secondary_accounting_host secondary_accounting_port secondary_accounting_secret secondary_accounting_secret_confirm]
                          set_array_of_text_fields(secondary_accounting_fields, args)
#sleep 1
                        end

                        # enter radius interval for alternate accounting
                        if(args[:accounting_radius_interval])
                         set_text_field_by_id("accounting_radius_interval", args[:accounting_radius_interval])
#sleep 1
                        end


                      end # if alternate accounting  

                    end # accounting = true
                     
                  end # if pask else eap 


                  new_save = new_encrypt_auth_modal.a(text:"Save")
                  new_save.focus
                  unless get(:span, {css: ".errorBubbleRight"}).visible?
                    new_save.click
                  end



#puts "waiting for modal to disapeara after save"    
                  new_encrypt_auth_modal.wait_while_present
#puts "modal should be gone... sleep for 1."
                  sleep 1 # lets wait one second after modal disappears

                 #encrypt_auth_modal.wait_while_present
                 # puts "before modal-overlay wait_while_present"
                 # get(:div, {css: ".modal-overlay" }).wait_while_present
                 # puts "before modal-overlay wait_while_present"
            
            ##
            # TODO : RADIUS

                elsif auth_option.include? "RADIUS"

                   










                  

                else 
                # auth_option should equal 'None/Open' here

                end             

              end # change SSID Encryption

              def captive_column
                @el.td(data_field: 'accessControl')
              end

              def access_control_data_val
                captive_column.attribute_value("data-value")
              end

              def access_control_text
                captive_column.div(css: ".inner").text
              end

              # profile config -> SSID GRid -> SSID ROW -> check 'Access Control' column ( Captive Portal, AirWatch)
              # data = data-value attribute in html source
              # text = text of currently selected dropdown item
              # this verifies both match strings passed in - see boolean methods captiveportal?, airwatch? and none? below
              def verify_captive_portal(expected_data, expected_text)
                data_captive = (access_control_data_val == expected_data ? true : false )
                text_captive = (access_control_text == expected_text ? true : false )
                ((data_captive == true ) && (text_captive == true)) ? true : false
              end
              
              def captiveportal?
                verify_captive_portal("captiveportal", "Landing")
              end

              def easypass?
                verify_captive_portal("captiveportal", "EasyPass Portal")
              end

              def airwatch?
                verify_captive_portal("airwatch","AirWatch")
              end

              def access_none?
                verify_captive_portal("none", "None")
              end


              #return ul..
              def open_drop(_column)
                el.click
                sleep 2
                _column.div(css: ".inner").span.click
                sleep 2
                click_drop_btn(_column)
                dd_active.wait_until_present
                dd_active.ul
              end


              def open_captive_drop
                open_drop(captive_column)
              end


              def set_captive(_val)
                set_cap_list = open_drop(captive_column)
                sleep 1
                select_open_drop_item(_val)
              end





            end # Row
            


          end #SsidGridView

      	end # ProfileConfigView
      end #UI
end
