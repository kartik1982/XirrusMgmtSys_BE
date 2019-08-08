require_relative 'view.rb'
module GUI
  class UI
     def settings_link
        a(id: "header_settings_link")
      end

      def user_settings
        header_user_link.wait_until(&:present?)
        header_user_link.click
        settings_link.wait_until(&:present?)
        settings_link.click
      end

      def primary_email_field
        text_field(id: "myaccount_myaccountname")
      end

      def change_email(new_email)
        primary_email_field.wait_until(&:present?)
        primary_email_field.clear 
        primary_email_field.set(new_email)
        primary_email_field
      end

      def change_password_btn
        a(id: "myaccount_changepassword_btn")
      end

      def change_password_modal
        div(css: ".change_password_modal.modal.ui-draggable")
      end

      def change_password_current_field
        change_password_modal.text_field(id: "myaccount_changepassword_current")
      end

      def change_password_new_field
        change_password_modal.text_field(id: "myaccount_changepassword_new")
      end

      def change_password_confirm_field 
        change_password_modal.text_field(id: "myaccount_changepassword_confirm")
      end

      def change_password_cancel_btn
        change_password_modal.a(id: "myaccount_changepassword_cancel_btn")
      end

      def change_password_save_btn
        change_password_modal.a(id: "myaccount_changepassword_save_btn")
      end

      def change_password(current_password, new_password)
        change_password_btn.click
        sleep 1
        change_password_modal.wait_until(&:present?)
        change_password_current_field.set(current_password)
        change_password_new_field.set(new_password)
        change_password_confirm_field.set(new_password)
        change_password_save_btn.click        
      end

      def settings_tabs
        id("settings_tabs")
      end
      
      def tabs
        @browser.nav(css: ".right-tab-menu")
      end

      def tab(text)
        tabs.a(text: text)
      end

      def goto_user_accounts
        user_settings
        sleep 2
        tab("User Accounts").wait_until(&:present?)
        sleep 2
        tab("User Accounts").click
      end

      def goto_addon_solutions
        user_settings
        tab("Add-on Solutions").wait_until(&:present?)
        tab("Add-on Solutions").click
      end

      def user_grid
        UserGrid.new(div(id: "user_grid"), @browser)
      end


      def roles_modal
        div(id: "roles_modal")
      end

      def roles_modal_field(label_text)
        roles_modal.label(text: label_text).parent
      end

      def xms_roles
        %w[None User Admin Beta]
      end

      def cloud_roles
        %w[None Admin]
      end

      def mobilize_roles
        %W[None User Admin]
      end

      def roles_modal_guest_switch_id
        "settings_useraccounts_ambassador_Switch_switch"
      end

      def roles_modal_make_guest
        ng_toggle_set(roles_modal_guest_switch_id, true)
      end

      def roles_modal_make_not_guest
        ng_toggle_set(roles_modal_guest_switch_id, false)
      end

      def set_role(product_label,role)
         field = roles_modal_field(product_label)
         field.a(css: '.ko_dropdownlist_button').click
         sleep 1
         dd = dd_active
         li = dd.li(text: role)
         li.wd.location_once_scrolled_into_view
         li.click    
      end

      def roles_modal_save_btn
        roles_modal.div(css: ".buttons").links[0]
      end

      def roles_modal_cancel_btn
        roles_modal.div(css: '.buttons').links[1]
      end

      def add_user(args = {})
        firstName = args[:firstName]
        lastName = args[:lastName]
        email = args[:email]
        grid = user_grid
        grid.new_user_btn.click
        sleep 1
        row = grid.el.tr(css: ".highlight_single")
        row.td(data_field: "firstName").text_field.send_keys firstName
        @browser.send_keys :tab
        sleep 1
        row.td(data_field: "lastName").text_field.send_keys lastName
        @browser.send_keys :tab
        sleep 1
        row.td(data_field: "email").text_field.send_keys email
        @browser.send_keys :tab
        sleep 1 
        grid.configure_btn.click
        sleep 1
        roles_modal.wait_until(&:present?)
        if args[:xms]
          set_role("XMS:", args[:xms])
        end
        if args[:cloud]
          set_role("Cloud Services:", args[:cloud])
        end
        if args[:mobilize]
          set_role("Mobilize:", args[:mobilize])
        end
        if args[:guest]
          ng_toggle_set(roles_modal_guest_switch_id, args[:guest])
        end
        sleep 1 
        roles_modal_save_btn.click
        sleep 1
        @browser.element(text: "User Accounts").click
      end

      class UserGrid < GUI::Grid

        def initialize(_element, browser)

          super(browser)
          @el = _element
          @el.wait_until(&:present?)

        end

        def new_user_btn
          el.a(id: "useraccounts_newuser_btn")
        end

        def configure_btn
          @browser.a(text: 'Configure')
        end


        def row(name)
          Row.new(name,@browser)
        end

        class Row 

          def initialize(name, browser)
            super(name, browser)
          end

          def col(val)
            column({data_field: val})
          end 

          def firstname_col
            col("firstName")
          end

          def lastname_col
            col("lastName")
          end

          def description_col
            col("description")
          end

          def email_col
            col("email")
          end

          def roles_col
            col("roles")
          end


        end # Row

      end # User Grid



      def provider_grid
        ProviderGrid.new(div(id: "mobileproviders_grid"),@browser)
      end

      class ProviderGrid < GUI::Grid 

        def initialize(_element, browser)

          super(browser)
          @el = _element
          @el.wait_until(&:present?)

        end

        def provider_sort_btn
          el.a(id: "providergrid_col_header_sort_btn_provider")
        end


        def row(name)
          Row.new(name,@browser)
        end

        class Row < GUI::Grid::Row 


          def initialize(name,browser)
            super(name,browser)
          end

          def col(val)
            column({data_field: val})
          end 


          def enabled_column
            col("enabled")
          end

          def inner_span(_el)
            _el.send(:div,{css: ".inner"}).send(:span)
          end


          def enabled?
            enabled_column.attribute_value("data-value") == 'true'
          end

          def provider_column
            col("provider")
          end

          def gateway_column
            col("gateway")
          end

          def country_column
            col("country")
          end
          

        end
      end     
  end # SettingPageObject
end # GUI