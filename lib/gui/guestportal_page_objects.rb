require_relative 'view.rb'
module GUI
  class UI
        def gpv
          GuestPortalsView.new(@browser)
        end

        def guest_portal_config_view
          GuestPortalConfigView.new(@browser)
        end

        def guestportal
            b.div(id: "guestportal")
        end

        def header_left_nav
          id("header_left_nav")
        end

        def header_guests
          id("header_nav_guestportals")
        end

        def view_all_guestportals_link
          #@browser.a(id: "view_all_nav_item")
          @browser.span(text: "View All Portals")
        end

        def goto_all_guestportals_view
          if header_left_nav.visible? != true
            @position = header_left_nav.wd.location
            browser.execute_script("body.scrollTop=#{@position[1]}")
          end
          header_left_nav.wait_until(&:present?)
          header_guests.wait_until(&:present?)
          header_guests.click
          sleep 1
          view_all_guestportals_link.wait_until(&:present?)
          view_all_guestportals_link.click

        end

        def new_portal_btn
          @browser.span(text: "New Portal")
        end

        def header_access_arrow
          @browser.div(id: "header_guestportals_arrow")
        end

        alias_method :header_guestportals_arrow, :header_access_arrow

        def header_new_portal_btn
          @browser.a(id: "header_new_guestportals_btn")
        end

        alias_method :header_newportal_btn, :header_new_portal_btn

        def newportal_modal
          div(id: "guestportals_newportal")
        end

        def easy_option_hider
          newportal_modal.div(css: ".portal_type.guest")
        end

        def select_easypass_portal_type(portal_type = "self")
          t = portal_type.downcase

          if ( t == "self" || t == "ambassador")
            easy_option_hider.wait_until(&:present?)
            easy_option_hider.div(css: ".name").hover
            sleep 1

            if (t == "self")
              easy_option_hider.a(css: ".portal_type.self_reg").click
            elsif (t == "ambassador")
              easy_option_hider.a(css: ".portal_type.ambassador").click
            else

            end

          elsif (t == "voucher")


          elsif ( t == "onboarding")


          else


          end # t ==

        end # select easypass portal type


        def create_gap(args = { type: "self"})
          type = args[:type] || "self"
          name = args[:name] || ""
          desc = args[:desc] || args[:description] || ""

          header_guestportals_arrow.wait_until(&:present?)
          header_guestportals_arrow.click

          header_new_portal_btn.wait_until(&:present?)
          header_new_portal_btn.click

          newportal_modal.wait_until(&:present?)

          set_text_field_by_id( new_name_field_id, name )
          textarea(id: new_desc_field_id).send_keys desc

          select_easypass_portal_type(type)
        end


        def delete_gap(portal_to_delete)

          goto_all_guestportals_view
          sleep 5
          tile =  gpv.tile(portal_to_delete)
          tile.wait_until(&:present?)
         # tile.fire_event("onmouseover")
          tile.hover
          sleep 2
          delete_icon = tile.a(css: ".icon.deleteIcon")
          sleep 2
         # delete_icon.wait_until(&:present?)
          delete_icon.fire_event("click")
          sleep 2
          div(css: ".dialogBox.confirm").wait_until(&:present?)
          confirm_modal = div(css: ".dialogBox.confirm")
          confirm_modal.span(text: "Delete Portal?").wait_until(&:present?)
         # @ui.div(text: "Are you sure you want to delete the Guest Portal?").wait_until(&:present?)
         #  @ui.div(xpath: "//div[@class='warning' and text() = 'Users will no longer be required to log in through a Guest Portal when accessing SSIDs currently assigned to this Guest Portal.']").wait_until(&:present?)
          div(id: "confirmButtons").wait_until(&:present?)
          div(id: "confirmButtons").a(text: "Cancel").wait_until(&:present?)
          a(text: "DELETE PORTAL").wait_until(&:present?)
          a(text: "DELETE PORTAL").click

        end

        def secretary_home_view
          id("guestambassador")
        end

        def secretary_home_search_id
          "guestambassador_search"
        end

        def guest_lookup_list
          id("guest_lookup_list")
        end

        def guest_lookup_listitems
          guest_lookup_list.lis
        end

        def guest_lookup_listitem(name)
          item = guest_lookup_listitems.select{|li| li.div(css: ".name") == name}.first
        end


        def secretary_home_add_guest_btn
          div(css: ".addNew")
        end

        def secretary_home_manage_guests_btn
          div(css: ".manageGuests")
        end

        ##
#  New Guest Modal
#

      def guestmodal
        div(id: "guestambassador_guestmodal")
      end

      def guestmodal_title_wrap
        guestmodal.div(css: ".title_wrap")
      end

      def guestmodal_title
        guestmodal_title_wrap.div(css: ".commonTitle")
      end

      def guestmodal_subtitle
        guestmodal_title_wrap.div(css: ".commonSubtitle")
      end

      def guestmodal_guest_lookup_field
        guestmodal.text_field(id: "guestportal_guestmodal_search")
      end

      def guestmodal_guest_lookup_button
        guestmodal.element(id: "guestportal_guestmodal_search_btn")
      end

      def guestmodal_indicates_required_fields
        guestmodal.span(css: ".requiredFields")
      end

      def guestname_label_text
        "Guest Name*:"
      end

      def guestname_label
        @browser.div(text: guestname_label_text)
      end

      def guestname_input
        @browser.div(css: ".row.name").input
      end

      def guestemail_label_text
        "Email*:"
      end

      def guestemail_label
        @browser.div(text: email_label_text)
      end

      def guestemail_input
        @browser.div(css: ".row.email").input
      end

      def mobile_label_text
        "Mobile:"
      end

      def mobile_label
        @browser.div(text: mobile_label_text)
      end

      def mobile_input
        text_field(id: "guestambassador_guestmodal_mobile_number")
      end

      def receive_password_via_text_checkbox
        @browser.div(css: ".row.sendByText").input(css: ".mac_chk")
      end

      def receive_password_via_text_label_text
        "Receive password via text message in addition to email."
      end

      def receive_password_via_text_label
        @browser.label(text: receive_password_via_text_label_text)
      end

      def mobile_infobtn
        receive_password_via_text_label.parent.div(css: ".infoBtn")
      end


      def guest_company_input
        div(text: "Guest's Company:").parent.text_field
      end

      def guest_note_input
        div(text: "Note:").parent.text_field
      end

      def gap_dropdown_btn
        #guestmodal.label(text: "Guest Portal*:").parent.a(css: ".ko_dropdownlist_button")
        span(text: "No guest portal selected").parent
      end


      def save_and_send_password_btn
        div(text: "Save & Send Password")
      end

      def guest_password_confirm_modal
        id("guestambassador_guestpassword")
      end

      def thanks_btn
        div(text: "THANKS! Close window")
      end

      def guest_grid
        GuestGridView.new(table(id: "manage_guests_grid"),@browser)
      end

      def guestportal_grid
        GuestGridView.new(div(css: ".manageguests_grid_container"),@browser)
      end


      def add_guest_open_guestmodal
        a(id: "manageguests_addnew_btn").wait_until(&:present?)
        a(id: "manageguests_addnew_btn").click
      end


      def add_guest_set_name(name)
        set_text_field_by_id("guestmodal_name_input", name)
      end

      def add_guest_set_email(email)
        set_text_field_by_id("guestmodal_email_input", email)
      end

      def add_guest_choose_provider(country, mobile)
        receive_password_via_text_label.click
        #div(css: ".sendByText").label.click
        dl(css: '.ddl_countries').a(css: ".ko_dropdownlist_button").click
        sleep 1
        dd = dd_active
        li = dd_active.li(text: country)
        li.wd.location_once_scrolled_into_view
        li.click
        sleep 1
        mobile_input.send_keys mobile
        @browser.send_keys :tab
      end

      def add_guest_set_company(company)
      #  guest_company_input.send_keys(company)
       puts div(text: "Guest's Company:").parent.html
      end

      def add_guest_set_note(note)
        guest_note_input.send_keys(note)
      end

      def add_guest_save
        save_and_send_password_btn.wait_until(&:present?)
        save_and_send_password_btn.click
        sleep 1
      end

      def add_guest_confirm
        Watir::Wait.until(5){guest_password_confirm_modal}
        Watir::Wait.until(5){thanks_btn}
        guest_info = guest_password_confirm_modal.div(css: '.guest_info')
        thanks_btn.click
      end

      ######### New UI Functions ###########
      def save_guestportal
        click("#guestportal_config_save_btn")
        sleep 3
      end

      def goto_guestportal(guestportal)
        # check to see if the guestportal is already opened
        if (@browser.url.match(/#guestportals\/[a-z0-9]{8}(?:-[a-z0-9]{4}){3}-[a-z0-9]{12}\/[a-zA-Z]/i))
          # check the guestportal name
          pn = id("profile_name")
          pn.wait_until(&:present?)
          if (pn.text == guestportal)
            return "already in guestportal"
          end
        end

        goto_all_guestportals_view
        sleep 3
        get(:span,{title: guestportal}).wait_until(&:present?)
        get(:span,{title: guestportal}).click

      end

      def guestportal_tile_with_name(name)
          pt = id("guestportals_list")
          pt.wait_until(&:present?)
          pt = pt.element(:css => ".tile span[title='" + name + "']")
          sleep 0.5
          pt.parent.parent
      end

      def guestportal_tile_with_name_new(name)
        portals_list_lenght = get(:elements , {css: "#guestportals_list .ko_container .tile"}).length
        while portals_list_lenght > 0
          if css("#guestportals_list .ko_container li:nth-child(#{portals_list_lenght}) .title").text == name
            return "#guestportals_list .ko_container li:nth-child(#{portals_list_lenght})"
          end
          portals_list_lenght -= 1
        end
      end

      def gap_add_guest(xms_guest)

        add_guest_open_guestmodal
        add_guest_set_name(xms_guest.name)
        add_guest_set_email(xms_guest.email)

        if xms_guest.mobileCarrier
          add_guest_choose_provider( xms_guest.country, xms_guest.mobile )
        end

        add_guest_set_company(xms_guest.company)
        add_guest_set_note(xms_guest.note)

        add_guest_save

        Watir::Wait.until(5){guest_password_confirm_modal}
        Watir::Wait.until(5){thanks_btn}
        thanks_btn.click

     end # add guest
      class GuestPortalsView < GUI::View
        def initialize(browser)
          super(browser)
          @browser.span(text: "EasyPass").wait_until(&:present?)
          @el = @browser.span(text: "EasyPass").parent.parent
          @b = @browser
        end

        def el
          @el
        end

        def b
          @browser
        end


      def tile_wrapper
        @browser.div(css: ".tile_wrapper")
      end

      def tiles
        tile_wrapper.wait_until(&:present?)
        tile_wrapper.ul(css: ".ko_container.ui-sortable.ui-sortable-disabled").wait_until(&:present?)
        tile_wrapper.ul(css: ".ko_container.ui-sortable.ui-sortable-disabled")
      end

      def tile(gap_name)
        tiles.span(xpath: ".//span[@class = 'title' and text() = '#{gap_name}'][1]").parent.parent
      end
=begin
    <li class="profile noSsids" data-bind="css: { noSsids: ssids.length === 0 }">
                    <div class="overlay">
                        <div class="content">
                            <a href="#" data-bind="click: $parent.deleteGuestPortal.bind($parent)" class="icon deleteIcon"></a>
                            <a href="#" data-bind="click: $parent.duplicateGuestPortal.bind($parent)" class="icon duplicateIcon"></a>
                        </div>
                    </div>
                    <a data-bind="attr: { href: '#guestportals/' + id + '/config', id:'guestportals_tile_item_' + $index(), 'data-itemid': id }" href="#guestportals/4d9ca460-e9c4-11e3-98f0-22000aeb20d8/config" id="guestportals_tile_item_1" data-itemid="4d9ca460-e9c4-11e3-98f0-22000aeb20d8">
                        <span class="title" data-bind="text: name, attr: { title: name }" title="Athletics_News_15260">Athletics_News_15260</span>
                        <span class="description" data-bind="attr: { title: description }" title="I am a guest portal">
                            <span data-bind="ellipsify: { text: description, trigger: $parent.tile_view }">I am a guest portal</span>
                        </span>
                        <ul class="infoBlock">
                            <li class="company" data-bind="visible: companyName" style="display: none;">
                                <div class="label" data-bind="localize: 'guestportals.company'">Company Name:</div>
                                <div class="value" data-bind="text: companyName"></div>
                            </li>
                            <li class="type noCompany" data-bind="css: { noCompany: !companyName }">
                                <div class="label" data-bind="localize: 'guestportals.type'">Portal Type:</div>
                                <div class="value" data-bind="localize: 'guestportal.type.' + type">Guest Ambassador Portal</div>
                            </li>
                            <li class="ssids taller" data-bind="visible: ssids.length > 0, css: { taller: !companyName }" style="display: none;">
                                <div class="label" data-bind="localize: 'guestportals.ssids'">SSIDs:</div>
                                <div class="value" data-bind="ellipsify: { text: $parent.getSsidsString($data), trigger: $parent.tile_view }"></div>
                            </li>
                        </ul>
                    </a>
                    <div class="bottom_slashes"></div>
                </li>
=end
      def addnew_button
        b.div(css: ".addNew")
      end

      def addnew_button_img
        addnew_button.div(css: ".img")
      end

      def addnew_button_details
        addnew_button.div(css: ".details")
      end

      def addnew_button_details_title
        addnew_button_details.div(css: ".title")
      end

      def addnew_button_details_description
        addnew_button_details.div(css: ".description")
      end

      def new_portal_btn
        @browser.a(id: "new_guestportal_btn")
        #el.span(text: "New Portal")
      end
    end# GuestPortalsView
  end # UI
end # GUI 