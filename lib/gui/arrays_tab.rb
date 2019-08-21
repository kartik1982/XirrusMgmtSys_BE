module GUI
  class UI
      	def profile_tab_arrays
      	 id("profile_tab_arrays")
      	end

        def array_grid
          puts "hard coded sleep hack , wait for array grid 5 seconds....."
          sleep 5
          ArrayGrid.new(@browser)
        end

        def profile_array_grid
          ProfileArrayGrid.new(@browser)
        end

        def profile_array_details_slideout
          ProfileArrayDetailsSlideout.new(@browser)
        end

        def array_slideout
          profile_array_details_slideout
        end
     
        def radio_content(slideout)

          slideout.wait_until_present
          radio_tab = slideout.radios_tab
          radio_tab.wait_until_present
          radio_tab.click
          rc = slideout.radios_content
          rc.wait_until_present
          rc
        end


        class ProfileArrayDetailsSlideout

        

        	def initialize(browser)
              @browser = browser
              @el = @browser.div(id: "profile_arrays_details_slideout")
            end

            def close_btn
              el.a(id: "arraydetails_close_btn")
            end

            def title_span
              el.span(css: '.title')
            end

            def title
              title_span.text
            end

            def description_div
              el.div(css: '.slideout_desc')
            end

            def description
              description_div.text
            end

            def section_title
              el.span(css: ".sectiontitle").text
            end

            def status_indicator
              @browser.div(css: ".slideout_title").span(css: '.status')
            end

            def status
              status_indicator.text
            end
            def el
              @el
            end
            def more_btn
              el.span(id: "arrays_more_btn")
            end

            def toggle_full_btn
              el.a(id: "arraydetails_togglefull")
            end

            def tabs
              el.div(css: '.arraydetails_tabs')
            end

            def tab(title)
              tabs.a(title: title)
            end

            def general_tab
              tab("General")
            end

            def system_tab
              tab("System")
            end

            def radios_tab
              tab(" Radios")
            end

            def bottom_buttons
              el.div(css: ".bottom_buttons")
            end


            def previous_btn
              bottom_buttons.a(id: 'arraydetails_prev_array')
            end

            def save_btn
              bottom_buttons.button(id: 'arraydetails_save')
            end

            def next_btn
              bottom_buttons.a(id: "arraydetails_next_array")
            end

            def general_content
              GeneralContent.new(@browser)
            end

            def goto_radio_content
              sleep 1
              radios_tab.wait_until_present
              radios_tab.click
              sleep 1
              radios_content.wait_until_present
              radios_content 
            end

            class SlideoutTab < GUI::View
              
              def initialize(browser, title)
                 super(browser)
                 @el = @browser.div(css: ".arraydetails_#{title.downcase}")
              end

              def info_block(title)
                 e = el.div(text: title).parent
                if e.attribute_value("class") == "info_block"
                  return e
                else
                  return nil
                end
              end

              def header
                el.div(css: ".arraydetails_header")
              end

              def subtitle
                header.div(css: ".subtitle").text 
              end

              def advanced_link
                header.a(css: ".commonAdvanced")
              end

              def advanced_showing?
                advanced_link.text.include?'Hide'
              end

              def show_advanced                
                unless advanced_showing?
                  advanced_link.click
                end
              end

              def hide_advanced
                unless !advanced_showing?
                  advanced_link.click
                end
              end



            end # SlideoutTab

            # Array Details Slideout General Content

            class GeneralContent < SlideoutTab

              def initialize(browser)
              	super(browser, "General")              	
              end

              def text_field_labels
                ["Hostname:", "Location:", "IP Address:", "Netmask:", "Gateway:"]
              end

              def text_field_by_label(label_text)
                el.label(text: label_text).parent.text_field
              end

              def profile_dropdown_field
                el.label(text: "Profile:").parent
              end

              def profile_dropdown_button
                profile_dropdown_field.a(css: '.ko_dropdownlist_button')
              end

              def get_profile_dropdown_list
                profile_dropdown_button.wait_until_present
                profile_dropdown_button.click
                dd_active.wait_until_present
                dd_active.ul
              end

              def profile_dropdown_items
                list = get_profile_dropdown_list
                items = list.lis 
              end

              def profile_list_item(text)
                get_profile_dropdown_list.li(text: text)
              end


              def hostname
                text_field_by_label("Hostname:")
              end

              def location
                text_field_by_label("Location:")
              end

              def add_tag_btn
                el.span(id: 'arrays_tag_btn')
              end

              def ip_address
                text_field_by_label("IP Address:")
              end

              alias_method :ip, :ip_address

              def netmask
                text_field_by_label("Netmask:")
              end

              def gateway
                text_field_by_label("Gateway:")
              end


            end # GeneralContent


            def system_content
              SystemContent.new(@browser)
            end

            # Array Details Slideout System Content

            class SystemContent < SlideoutTab
          
              def initialize(browser)
                super(browser, "System")
              end

            
              def software_section
                info_block("Software")
              end

              def hardware_section
                info_block("Hardware")
              end

              def network_section
                info_block("Network")
              end

              def software_section_header
                software_section.div(css: ".header_wrap")
              end

              def software_section_component_header
                software_section_header.span(text: "Component")
              end

              def software_section_version_header
                software_section_header.span(text: "Version")
              end

              def system_component_row(_component)
                software_section.span(data_bind: "localize: 'arrays.system.#{_component}'").parent
              end

              def hardware_section_header
                hardware_section.div(css: ".header_wrap")
              end

              def hardware_fields
                hardware_section.div(data_bind: "foreach: hardware").divs(css: ".field")
              end

              def hardware_array_row
                hardware_fields[0]
              end

              def hardware_controller_row
                hardware_fields[1]
              end

              def hardware_iap_rows
                hardware_fields[2..-1]
              end

              def network_section_header
                network_section.div(css: ".header_wrap")
              end

              def network_fields
                network_section.div(data_bind: "foreach: interfaces").divs(css: ".field")
              end

              def network_iaps_row
                network_fields[0]
              end

              def network_gig1_row
                network_fields[1]
              end

              def network_gig2_row
                network_fields[2]
              end



            end # System Content


            def radios_content
              RadiosContent.new(@browser)
            end

           

        end # ProfileArrayDetailsSlideout



        class ArrayGrid < GUI::Grid
          
          def initialize(browser)
          	super(browser)
            @el = @browser.div(css: '.arrays_tab')            
          end

          def row(name)
            Row.new(name, @browser)
          end
     def method_missing(name, *args)
        # puts "method_missing being called - #{name} with args #{args.to_s}"
        as_sym = name.to_sym
        as_string = name.to_s
        if el.respond_to?(as_string, include_private = false)# this is experimental
          el.send(as_string,*args)
        else
        super # You *must* call super if you don't handle the
        # method, otherwise you'll mess up Ruby's method
        # lookup.
        end
      end

        
          ##
          #
          #  ArrayGrid::Row
          #
          class Row < GUI::Grid::Row

            def initialize(name,browser)
              super(name,browser)
            end

            def view_row_icon
              el.element(css: '.view_row_icon')
            end

            def hostname_column
              column({data_field: "hostName"})
            end

            def status_column
              column({data_field: "activationStatus"})
            end

            def current_status
              status_column.div(css: ".inner").span(css: ".status").text
            end


            

          end # Row
          ##############################

          
          
        end # ArrayGrid
        ##################################



        ##
        #
        #  PROFILE ARRAY GRID
        #
        class ProfileArrayGrid < ArrayGrid

          def initialize(browser)
          	super(browser)
          	@el = browser.div(css: '.array_tab')
          end

          def row(name)
            Row.new(name, @browser)
          end

          class Row < GUI::Grid::Row

            def initialize(name,browser)
              super(name,browser)
              
            end

            def view_row_icon
              el.element(css: '.view_row_icon')
            end

          end # Row

        end        

  end
end

