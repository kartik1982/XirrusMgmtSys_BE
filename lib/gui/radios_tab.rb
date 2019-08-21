module GUI
    class UI
        class ProfileArrayDetailsSlideout
            # Array Details Slideout Radios Content
            class RadiosContent < SlideoutTab
               
              def initialize(browser)
                 super(browser, "Radios")                 
              end

              def radios_list
                el.div(css: ".arraydetails_radios_list")
              end

              def radio_list_items
                radios_list.div(css: ".radios_list").divs(css: ".radio_item_container")
              end

              def select_all_link
                el.a(css: '.select_all_radios')
              end

              def deselect_all_link
                el.a(css: ".deselect_all_radios")
              end

              def select_all
                if select_all_link.present?
                  select_all_link.click 
                end
              end

              def deselect_all
                if deselect_all_link.present?
                  deselect_all_link.click                  
                end
              end

              def enable_btn
                el.element(xpath: ".//div[@class='button blue' and text() = 'Enable'][1]")
              end

              def disable_btn
                el.element(xpath: ".//div[@class='button blue' and text() = 'Disable'][1]")
              end

              def edit_multiple_btn
                el.element(xpath: ".//div[@class='button blue' and text() = 'Edit Multiple'][1]")
              end 

              def multi_edit_div
                el.div(css: '.radios_multiEdit')
              end

              def multi_edit_item
                RadioItem.new(multi_edit_div, @browser)
              end


              def radio_item(name)
                _el = radios_list.div(xpath: ".//div[@class='iapName' and text() = '#{name}']").parent.parent.parent
                #div(css: ".radio_item_container").div(css: ".radio_item").div(css: ".general.column").div(css: ".iapName")
                RadioItem.new(_el, @browser)
              end

              def disable_btn
                el.div(text: "Disable")
              end
              
              # Radio Item
              #  
              #
              #
              class RadioItem < GUI::View
        
                def initialize(_el, browser)
                  super(browser)
                  @el = _el
                end

                def inner
                  el.div(css: ".radio_item")
                end

                def header
                  el.div(css: '.header')
                end

                def you_are
                  get_column("youAreEditing")
                end

                def tag(name)
                  get_column("tags").span(css: ".tag").span(text: name).parent
                end

                def tags
                  get_column("tags").elements(css: ".tag")
                end

                def delete_tag(name)
                  t = tag(name)
                  t.span(css: '.delete').click 
                end

                def multi_cancel
                  el.div(xpath: "//div[@class='button fl_right' and text() = 'Cancel']")
                end

                def multi_apply
                  el.div(xpath: "//div[@class='button orange fl_right' and text() = 'Apply']")
                end

                def description_input
                  get_column("general").text_field(css: ".description.small")
                end

                def cell_size
                  d = open_drop("cellSize")

                  this_size = d.li(css: ".selected").text.dup 
                  l = d.li(text: this_size)
                  l.wd.location_once_scrolled_into_view
                  l.wait_until_present

                  l.click 
                  sleep 1
                  this_size
                end


                def set_cell_size(size)
                  set_drop("cellSize",size)
                end

                def set_drop(drop,value)
                  d = open_drop(drop) 
                  sleep 2
                  l = d.li(text: value)
                  #l.wd.location_once_scrolled_into_view
                  l.wait_until_present
                  l.scroll.to
                  l.click 
                end

                def current_drop(drop)
                  ul =  open_drop(drop)
                  c = ul.li(css: ".selected").text
                  ul.li(text: c).wd.location_once_scrolled_into_view
                  ul.li(text: c).wait_until_present
                  ul.li(text: c).click
                  c
                end

                def set_channel(chan)
                  set_drop("channel", chan)
                end

                def current_channel
                  # current_drop("channel")
                  el.div(css: '.column.channel').text.gsub("Channel\n","")
                end


                def input(name)
                  get_column(name).div(css: ".#{name}InputContainer").text_field(css: ".small.spinner")
                end

                def set_transmit(value)
                  i = input("tx")
                  i.wait_until_present
                  i.clear
                  i.send_keys(value)
                end

                def current_transmit
                  input("tx").value
                end

                def set_receive(value)
                  input("rx").clear
                  input("rx").value = value
                end 

                def current_receive
                  input("rx").value 
                end

                def band5ghz
                  get_column("band").div(css: ".band_50ghz")
                end

                def band24ghz
                  get_column("band").div(css: ".band_24ghz")
                end

                def current_band
                  get_column("band").div(css: ".active").text 
                end             

                def edit_mode
                  #puts "Begin: radio edit mode"
                  unless inner.attribute_value("class").include?"inEdit"
                    attempts = 0

                    while(attempts < 20 && !el.div(css: ".editIcon").present?)
                      inner.hover
                      puts "hover row on attempt #{attempts}"
                      attempts = attempts + 1
                      sleep 3
                    end

                    el.div(css: ".editIcon").click
                  end
                  sleep 1
                  #puts "End: radio edit mode"
                end

                def get_column(name)
                  el.div(css: ".#{name}.column")
                end

                def checkbox_column
                  get_column("radio_checkbox")
                end

                def checkbox
                  checkbox_column.div(css:".macCheckbox")
                end
                # cannot click actual checkbox input it is hidden
                # click sibling span
                def click_checkbox
                  checkbox_column.span(css: ".customInput")
                end

               

                def checked?
                  checkbox.attribute_value("checked").nil? ? false : true
                end

                def general_column
                  get_column("general")
                end

                def iap_name_div
                  general_column.div(css: ".iapName")
                end

                def iap_name
                  iap_name_div.text 
                end

                def desc_div
                  general_column.div(css: ".description")
                end

                def description
                  desc_div.text 
                end

                def info_column
                  get_column("information")
                end

                def click_drop_btn(list_el)
                  a = list_el.a(css: ".ko_dropdownlist_button")
                  a.wait_until_present
                  a.click
                  sleep 3
                end

                #return ul..
                def open_drop(name)
                 
                  css_string = ".#{name}Ddl"
                
                  e = @browser.span(css: css_string)
                                  
                  click_drop_btn(e)
                  dd_active.wait_until_present
                  dd_active.ul
                end

                def channels
                 
                  ul = open_drop("channel")
                  c = ul.li(css: ".selected")
                  channels = ul.lis.map{ |l| l.text }
                  c.click
                  channels
                end

                def cell_sizes
                 
                  ul = open_drop("cellSize")
                  current = ul.li(css: ".selected")
                  cell_sizes = ul.lis.map{ |l| l.text }
                  current.click
                  cell_sizes
                end

                def wifi_modes
                 
                  ul = open_drop("wifi")
                  current = ul.li(css: '.selected')
                  modes = ul.lis.map{ |l| l.text }
                  current.click
                  modes
                end

                def current_wifi_mode
                  ul = open_drop("wifi")
                  current = ul.li(css: '.selected')
                  current_mode = current.text.dup
                  current.click
                  current_mode
                end

                def wifi_24ghz_modes
                  wifi_modes.slice(1,6)
                end

                def wifi_5ghz_modes
                  wifi_modes.slice(8,9)
                end

                def wifi_both_modes
                  wifi_modes[-1]
                end

                def current_bonded_channel
                   get_column("channel").div(css: ".bonded").span.text
                end

                
              end # RadioItem



            end # Radios Content

        end # ProfileArrayDetailsSlideout
    end # UI
end # GUI