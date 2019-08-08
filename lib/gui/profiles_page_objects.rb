module GUI
  class UI

      	def profiles_view
      	  ProfilesView.new(@browser)
      	end

        def header_profiles_link
          ln = id("header_left_nav")
          ln.wait_until(&:present?)
          ln.span(text:"Profiles")
        end

        def header_profiles_menu_item_with_name(name)
            pi = id("profile_items")
            pi.wait_until(&:present?)
            pi.element(:class => /title/, :text => name)
            pi.parent
        end

        def header_new_profile_btn
          get(:element,{id: "header_new_profile_btn"})
        end

        def header_view_all_profiles_link
          ni = id("view_all_nav_item")
          ni.wait_until(&:present?)
          ni.span(text: "View All Profiles")
        end

        def profile_tile(profile)
          get(:span,{title: profile})
        end



        def view_all_profiles
          if (!@browser.url.end_with? "#profiles")
            header_profiles_link.click
            sleep 1
            header_view_all_profiles_link.wait_until(&:present?)
            header_view_all_profiles_link.click
            sleep 1
          end
        end
        def view_all_profiles_with_switch
          if (!@browser.url.end_with? "#profiles")
            header_profiles_link.click
            sleep 1
            css('#view_all_nav_item_left_aligned').click
            sleep 1
          end
        end
        def profiles_tiles_view_btn
          id("profiles_tiles_view_btn")
        end

        def profiles_list_view_btn
          id("profiles_list_view_btn")
        end

        def goto_profile(profile)
          # check to see if the profile is already opened
          if (@browser.url.match(/#profiles\/[a-z0-9]{8}(?:-[a-z0-9]{4}){3}-[a-z0-9]{12}\/[a-zA-Z]/i))
            # check the profile name
            pn = id("profile_name")
            pn.wait_until(&:present?)
            if (pn.text == profile)
              return "already in profile"
            end
          end

          view_all_profiles
          sleep 3
          get(:span,{title: profile}).wait_until(&:present?)
          get(:span,{title: profile}).click

        end

        def profile_tile_with_name(name)
            pt = id("profiles_list")
            pt.wait_until(&:present?)
            pt = pt.element(:css => ".tile span[title='" + name + "']")
            sleep 0.5
            pt.parent.parent
        end

        def profile_tile_with_name_new(name)
        profiles_list = get(:elements , {css: "#profiles_list .ko_container .tile"}).length
        while profiles_list > 0
          if css("#profiles_list .ko_container li:nth-child(#{profiles_list}) .title").text == name
            puts "#profiles_list .ko_container li:nth-child(#{profiles_list})"
            return "#profiles_list .ko_container li:nth-child(#{profiles_list})"
          end
          profiles_list -= 1
        end
      end

        def first_profile_tile
            pt = css("#profiles_list .tile_wrapper .ko_container .tile:first-child")
            pt.wait_until(&:present?)
            pt
        end

        def delete_all_profiles
          view_all_profiles
          sleep(2)

          # get the profile tiles and loop until they are all removed
          profile_tiles = get(:elements, {css: "#profiles_list .ui-sortable .tile"})
          while profile_tiles.any?
            tile = profile_tiles.first
            # hover to cause the overlay buttons to appear
            tile.hover

            #find th delete button and click, make sure it's visible
            delete_btn = tile.element(:css => ".overlay .deleteIcon")
            delete_btn.wait_until(&:present?)
            delete_btn.click

            #confirm the deletion
            confirm_dialog

            tile.wait_while_present
            profile_tiles = get(:elements, {css: "#profiles_list .ui-sortable .tile"})
          end
        end

        def fresh_ssid_grid_by_profile(profile_name)

            goto_profile(profile_name)

            get(:div, {id: "profile_config_container"}).wait_until(&:present?)

            p = profile_config_view

            p.wait_until(&:present?)

            p.ssids_tile.click

            p.ssid_grid.wait_until(&:present?)

        end

        ##
        # These methods assume you are at an individual profile view

        def open_profile_menu
          id("profile_menu_btn").wait_until(&:present?)
          id("profile_menu_btn").click
          @browser.nav(css: ".drop_menu_nav.active").wait_until(&:present?)
          sleep 1
        end



        def duplicate_profile
          open_profile_menu
          @browser.a(:text => 'Duplicate Profile').click
          #@browser.a(css: ".drop_menu_nav.active a:nth-child(1)").click
          #css('.drop_menu_nav.active a:nth-child(1)').click
          #id("profile_duplicate_btn").click
          sleep 1
          confirm_dialog
        end

        def cancel_duplicate_profile
          open_profile_menu
          @browser.a(:text => 'Duplicate Profile').click
          #@browser.a(css: ".drop_menu_nav.active a:nth-child(1)").click
          #id("profile_duplicate_btn").click
          sleep 1
          cancel_dialog
        end

        def delete_profile
          open_profile_menu
          @browser.a(:text => 'Delete Profile').click
          #@browser.a(css: ".drop_menu_nav.active a:nth-child(2)").click
          #id("profile_delete_btn").click
          sleep 1
          confirm_dialog
        end

        def cancel_delete_profile
          open_profile_menu
          @browser.a(:text => 'Delete Profile').click
          #@browser.a(css: ".drop_menu_nav.active a:nth-child(2)").click
          #id("profile_delete_btn").click
          sleep 1
          cancel_dialog
        end

        def assign_as_default
          open_profile_menu
          sleep 2
          if @browser.a(:text => 'Assign As Default').exists?
            @browser.a(:text => 'Assign As Default').click
          elsif @browser.a(:text => 'Clear Default').exists?
            @browser.a(:text => 'Clear Default').click
          else
            expect(@browser.a(:text => 'Clear Default')).to eq(@browser.a(:text => 'Assign As Default'))
          end
        end

        def save_profile
          id("profile_config_save_btn").click
          sleep 1
        end

      	class ProfilesView
      	  def initialize(browser)
      	  	@browser = browser
      	  end

          def profiles_list
            @browser.div(id: "profiles_list")
          end

          def list_view_btn
          	@browser.element(id: "profiles_list_view_btn")
          end

          def list
          	@browser.div(id: "profiles_list").div(id: "tile_wrapper").ul(css: ".ko_container")
          end

          def list_items
          	list.lis(css: ".profile")
          end

          def default_profile
          	list.li(css: ".profile.default")
          end

          def profile_listitem_present?(title)
            list.wait_until(&:present?)
            list.span(title: "#{title}").present?
          end

          def listitem_by_title(title)
          	li = list.span(title:"#{title}").parent.parent.wait_until(&:present?)
          	r = ListItem.new(li, @browser)
          	r
          end

          def delete_listitem(title)
          	listitem_to_delete = listitem_by_title(title)
          	listitem_to_delete.delete
          end

          def delete_all_except_default
          	profile_items = list_items
            profile_items.each {|item|
              unless item.attribute_value("class").include?("default")
                title = item.span(css: ".title").text
                li = ListItem.new(item,@browser)
                li.hover
                @browser.a(css: ".deleteIcon").wait_until(&:present?)
                @browser.a(css: ".deleteIcon").click
                sleep 2
              end
            }

          end

          def click_list_icon
            list_view_btn.send_keys :enter
          end

          def ssid_encrypt_auth_modal
            @el.div(id: "ssid_encrypt_auth_modal")
          end



          # expects a LI Watir Element
            class ListItem
              def initialize(li_element, browser)
              	@el = li_element
              	@browser = browser
              end

              def el
                @el
              end

              def click
                el.click
              end

              def trash_icon
                @el.a(css: ".deleteIcon")
              end

              def delete
              	@el.hover
                trash_icon.wait_until(&:present?)
              	trash_icon.click
              	sleep 1
              	@browser.a(id:"_jq_dlg_btn_1").wait_until(&:present?)
                @browser.a(id:"_jq_dlg_btn_1").click
                sleep 1
              end


            end # ListItem

      	end #ProfilesView

  end
end