require_relative '../constants.rb'
$:.unshift File.dirname(__FILE__)
require 'login_page_objects'
require 'guestportal_page_objects'
require 'profiles_page_objects'
require 'profile_config_view'
require 'reports_page_objects'
require 'settings_page_objects'
require 'mynetwork_page_objects'
require 'policy_toggle_div'
require 'arrays_tab'
require 'radios_tab'

module GUI
  class UI
    include GUI::LoginPageObjects
    include GUI::ReportsPageObjects
    # include GUI::SettingsPageObjects
    attr_accessor :browser, :log_file
    def initialize(args={})
      @log_file = args[:log_file]
      @browser = args[:browser]
    end
    #alphabetical order functions
    def css(_css)
      get(:element,{css: _css})
    end
    def click(css)
      if css(css).present? != true
        @position = css(css).wd.location
        browser.execute_script("body.scrollTop=#{@position[1]}")
      end
      css(css).focus
      obj = css(css)
      obj.wait_until(&:present?)
      obj.click
    end
    def click_on_certain_control_and_return_recently_added_value(css_to_click, control_type_to_verify, css_to_verify)
        sleep 1
        css(css_to_click).click
        sleep 1
        case control_type_to_verify
          when "input"
            return get(:input, {css: css_to_verify}).value
          when "textarea"
            return get(:textarea, {css: css_to_verify}).value
          when "switch", "checkbox"
            return get(:checkbox, {css: css_to_verify}).set?
          when "dropdownlist"
            return get(:span, {css: css_to_verify}).text
        end
      end
      def find_grid_header_by_name_support_management(string)
        get_grid_header_count_support_manegement
        if css('.nssg-table .nssg-thead').trs.length != 0
          header_css = '.nssg-thead'
        elsif css('.nssg-table .nssg-thead:nth-of-type(2)').trs.length != 0
          header_css = 'thead:nth-of-type(2)'
        end
        while ($header_count > 0) do
          if (css(".nssg-table #{header_css} tr th:nth-child(#{$header_count})").attribute_value("class") != "gutter nssg-th")
            if (css(".nssg-table #{header_css} tr th:nth-child(#{$header_count}) .mac_chk_label").exists?)
              puts "Column with the name '#{string}' has not been found!"
              $bool_not_exists = true
              $header_column_chk_label = css(".nssg-table #{header_css} tr th:nth-child(#{$header_count}) .mac_chk_label")
              break
            end
            if (css(".nssg-table #{header_css} tr th:nth-child(#{$header_count}) .nssg-th-text").text == string)
              sleep 0.5
              $header_column = css(".nssg-table #{header_css} tr th:nth-child(#{$header_count}) div:nth-child(2)")
              header_col = css(".nssg-table #{header_css} tr th:nth-child(#{$header_count}) div:nth-child(2)")
              return header_col
            end
          end
          $header_count-=1
        end
      end
     def find_grid_header_by_name(string)
        get_grid_header_count
        while ($header_count > 0) do
          if (css(".nssg-table thead tr th:nth-child(#{$header_count})").attribute_value("class") != "gutter nssg-th")
            if (css(".nssg-table thead tr th:nth-child(#{$header_count}) .mac_chk_label").exists?)
              puts "Column with the name '#{string}' has not been found!"
              $bool_not_exists = true
              $header_column_chk_label = css(".nssg-table thead tr th:nth-child(#{$header_count}) .mac_chk_label")
              break
            end
            if (css(".nssg-table thead tr th:nth-child(#{$header_count}) .nssg-th-text").text == string)
              sleep 0.5
              $header_column = css(".nssg-table thead tr th:nth-child(#{$header_count}) .nssg-th-text")
              header_col = css(".nssg-table thead tr th:nth-child(#{$header_count}) div:nth-child(2)")
              return header_col
            end
          end
          $header_count-=1
        end
      end
      def find_array_depending_on_included_strings_then_return_path(name, which_column, a_or_div)
        @grid_length = get_grid_length_new
        puts @grid_length
        while (@grid_length != -1) do
          puts css(".nssg-table tbody tr:nth-child(#{@grid_length}) td:nth-child(#{which_column}) #{a_or_div}").text
          if (css(".nssg-table tbody tr:nth-child(#{@grid_length}) td:nth-child(#{which_column}) #{a_or_div}").text.include?(name))
              path_general = ".nssg-table tbody tr:nth-child(#{@grid_length}) td:nth-child(#{which_column}) #{a_or_div}"
              return path_general
          end
          @grid_length-=1
          # after checking the last line in the grid (first one) start the following procedure
          if (@grid_length == 0)
           if (css('.nssg-paging-controls .nssg-paging-next').present?)
             css('.nssg-paging-controls .nssg-paging-next').click
             sleep 4
           else
             puts "Cannot find the proper line in the grid - searching for entry '#{name}'"
             return false
           end
            @grid_length = get_grid_length_new
            redo
          end
        end
      end
      def find_grid_header_by_name_new(string)
        hc = get_grid_header_count_new
        if css('.nssg-table .nssg-thead').trs.length != 0
          h = '.nssg-thead'
        elsif css('.nssg-table .nssg-thead:nth-of-type(2)').trs.length != 0
          h = '.nssg-thead:nth-of-type(2)'
        end
        #if browser.url.include?("mynetwork/alerts")
        #  h = '.nssg-thead:nth-of-type(2)'
        #end
        while (hc > 0) do
          if (css(".nssg-table #{h} tr th:nth-child(#{hc})").attribute_value("class").include?("gutter") == false)
            hct= 'text'
            if (css(".nssg-table #{h} tr th:nth-child(#{hc}) .mac_chk_label").exists?)
              puts "Column with the name '#{string}' has not been found!"
              return true
            end
            if(css(".nssg-table #{h} tr th:nth-child(#{hc})").attribute_value("class").include?("number"))
              hct= 'number'
            end
            if (css(".nssg-table #{h} tr th:nth-child(#{hc}) .nssg-th-#{hct}").text == string)
              sleep 0.5
              $header_count = hc
              return ["#{hc}", ".nssg-table #{h} tr th:nth-child(#{hc})", css(".nssg-table #{h} tr th:nth-child(#{hc}) .nssg-th-#{hct}")]
            end
          end
          hc-=1
        end
      end
      def find_certain_line_in_grid(column_name, searched_name)
        header_postion = find_grid_header_by_name_new(column_name)
        verify_grid_is_on_first_page
        g_length = get_grid_length_new
        while (g_length != -1) do
          if css(".nssg-table tbody tr:nth-child(#{g_length}) td:nth-child(#{header_postion[0]}) .nssg-td-text").text == searched_name
            return ".nssg-table tbody tr:nth-child(#{g_length})"
          end
          g_length -= 1
          if (g_length == 0)
            if (css('.nssg-paging-controls .nssg-paging-next').present?)
              css('.nssg-paging-controls .nssg-paging-next').click
              sleep 4
            else
              puts "Cannot find the proper line in the grid - searching for entry '#{name}'"
              return nil
            end
            g_length = get_grid_length_new
            redo
          end
        end
      end
    def refresh
      @browser.refresh
    end
    
    def ng_toggle_checked?(_id)
      @browser.checkbox(id: _id).checked? ? true : false
    end
    def ng_toggle(_id)
      label = @browser.checkbox(id: _id).parent.label
      label.wait_until_present
      # @browser.scroll.to label
      label.click
    end
    def li_text_array(_ul)
      _ul.lis.map {|l| l.text }
    end
    def ng_toggle_set(_id, value)
      current_val = ng_toggle_checked?( _id )
      if current_val == value
      return
      else
        ng_toggle( _id )
      end
    end
    
    def get_cell_text_on_ap_grid(ap_name,column_name,status_text,fake_ap)
        i = 0
        $expected_cell_string = ""
        for o in 1..3
          css('#arrays_grid .nssg-paging .nssg-refresh').click
          sleep 2
        end

        verify_grid_is_on_first_page

        find_grid_header_by_name(column_name)

        get_grid_length

        if fake_ap == false
          while $expected_cell_string!=status_text
            iterate_trough_each_grid_line(3, "div", ap_name, "verify text", $header_count,"div span:nth-child(2)", "", "", status_text)
            sleep 1
            css('.nssg-paging .nssg-refresh').click
            sleep 3
            i+=1
            if i == 15
              puts "Aborting - something went seriously wrong !!!"
              break
            end
          end
        else
          for o in 1..3
          css('#arrays_grid .nssg-paging .nssg-refresh').click
          sleep 2
          end
        end

      end
    def get_grid_header_count_new
        if css('.nssg-table .nssg-thead').trs.length != 0
          h = css('.nssg-table .nssg-thead')
        elsif css('.nssg-table .nssg-thead:nth-of-type(2)').trs.length != 0
          h = css('.nssg-table .nssg-thead:nth-of-type(2)')
        end
        #h = css('.nssg-table .nssg-thead')
        h.wait_until(&:present?)
        return h.ths.length
    end
    def get_grid_header_count
      if @browser.url.include?('#backoffice/firmware')
        header = css('.nssg-table .nssg-thead:nth-child(2)')
      else 
        header = css('.nssg-table .nssg-thead')
      end
        header.wait_until(&:present?)
        $header_count = header.ths.length
        hc = header.ths.length
        return  hc
      end
    def get(watir_browser_method, args = {})
      @browser.send(watir_browser_method.to_sym, args)
    end
    def grid_tick_on_specific_line(which_column, name, a_or_div)
          #verify that the grid is on the first page
          verify_grid_is_on_first_page
          sleep 0.2
          #get the grid's length
          get_grid_length
          sleep 0.2
          # start iterating trough each grid line
          return iterate_trough_each_grid_line(which_column, a_or_div, name, "tick", "", "", "", "", "")
      end
    def grid_action_on_specific_line(which_column, a_or_div, name, action)
          #verify that the grid is on the first page
          verify_grid_is_on_first_page
          sleep 0.2
          #get the grid's length
          get_grid_length
          sleep 0.2
          # start iterating trough each grid line
          iterate_trough_each_grid_line(which_column, a_or_div, name, action, "", "", "", "", "")
      end

      def grid_verify_icon_on_provider(which_column, a_or_div, name, which_column2, a_or_div2, class_name1)
         #verify that the grid is on the first page
          verify_grid_is_on_first_page
          sleep 0.2
          #get the grid's length
          get_grid_length
          sleep 0.2
          # start iterating trough each grid line
          iterate_trough_each_grid_line(which_column, a_or_div, name, "verify_provider_icon", which_column2, a_or_div2, class_name1, "", "")
      end

      def grid_verify_text_and_icons(which_column, a_or_div, name, which_column2, a_or_div2, class_name1, class_name2 )
         #verify that the grid is on the first page
          verify_grid_is_on_first_page
          sleep 0.2
          #get the grid's length
          get_grid_length
          sleep 0.2
          # start iterating trough each grid line
          iterate_trough_each_grid_line(which_column, a_or_div, name, "verify text and icons", which_column2, a_or_div2, class_name1, class_name2, "")
      end
    def grid_click_on_specific_line(which_column, name, a_or_div)
         #verify that the grid is on the first page
          verify_grid_is_on_first_page
          sleep 0.2
          #get the grid's length
          get_grid_length
          sleep 0.2
          # start iterating trough each grid line
          iterate_trough_each_grid_line(which_column, a_or_div, name, "click", "", "", "", "", "")
      end
      def get_grid_length
        # get the grid entries length as "grid_length"
          grid_entries = css(".nssg-table tbody")
          grid_entries.wait_until(&:present?)
          $grid_length = grid_entries.trs.length
      end
      def grid_verify_strig_value_on_specific_line_by_column_name(which_column_string, name, a_or_div, which_column2, a_or_div2, string)
       #verify that the grid is on the first page
          verify_grid_is_on_first_page
          sleep 0.2
          find_grid_header_by_name(which_column_string)
          #get the grid's length
          get_grid_length
          sleep 0.2
          # start iterating trough each grid line
          return iterate_trough_each_grid_line($header_count, a_or_div, name, "verify text", which_column2, a_or_div2, "", "", string)
      end

      def grid_verify_strig_value_on_specific_line(which_column, name, a_or_div, which_column2, a_or_div2, string)
       #verify that the grid is on the first page
          verify_grid_is_on_first_page
          sleep 0.2
          #get the grid's length
          get_grid_length
          sleep 0.2
          # start iterating trough each grid line
          iterate_trough_each_grid_line(which_column, a_or_div, name, "verify text", which_column2, a_or_div2, "", "", string)
      end
      def go_to_profile_tile(switch_present)
           sleep 0.5
           css("#header_nav_profiles").click
           sleep 0.5
           if switch_present
             click("#view_all_nav_item_left_aligned")
           else
             click("#view_all_nav_item")
           end
           sleep 1
           click("#profiles_tiles_view_btn")
      end
      def go_to_switch_templates_tile
           sleep 0.5
           css("#header_nav_profiles").click
           sleep 0.5
           @browser.element(:link, "Templates").click
           sleep 1
           # click("#profiles_tiles_view_btn")
      end
    def iterate_trough_each_grid_line(which_column, a_or_div, name, action, which_column2, a_or_div2, class_name1, class_name2, string) #click / verify text / verify text and icons / "tick"
        $search_failed_booleand = nil
        while ($grid_length != -1) do
            $verify_text_entry = css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{which_column}) #{a_or_div}").text
            # if the specific cell's text matches the "name" start the following procedure
            if (css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{which_column}) #{a_or_div}").text == name)
#            if (css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{which_column}) #{a_or_div}").text.include?name)
              # hover over the specific line to reveal the underlay controls
              #css(".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{which_column})").hover
              snippet = "$(\".nssg-table tbody tr:nth-child(#{$grid_length}) .nssg-actions-container\").show()"
              browser.execute_script(snippet)
              sleep 0.5
              path_general = ".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{which_column}) #{a_or_div}"
              path_model= ".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(3)"
              path_verify = ".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(#{which_column2}) #{a_or_div2}"
              # path_check = ".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(2) .mac_chk_label"
              path_check = ".nssg-table tbody tr:nth-child(#{$grid_length}) .nssg-td-select .mac_chk_label"
              path_check_avaya = ".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(1) .mac_chk_label"
              path_container = ".nssg-table tbody tr:nth-child(#{$grid_length}) td:nth-child(1) .nssg-actions-container"
              case action
                when "click"
                  css(path_general).click
                when "click_model"
                  css(path_model).click
                when "verify text"
                  puts "verify text"
                  puts "string: #{string}"
                  puts string.class.to_s
                  if string.class.to_s == "Array"
                    puts "gone to array"
                    string.each do |array_entry|
                      puts "#Array entry: {array_entry}"
                      if (css(path_verify).text.include? array_entry)
                        expected_cell_string = css(path_verify).text
                        puts "#{array_entry} belongs to '#{expected_cell_string}' -> correct"
                        return expected_cell_string
                      end
                    end
                  else
                    if (css(path_verify).text == string)
                      expected_cell_string = css(path_verify).text
                      puts "#{string} correct"
                      return expected_cell_string
                    end
                  end
                when "return css"
                    return path_general
                when "verify text and icons"
                  #css("#{path_verify} span:nth-child(2)").hover
                  #browser.execute_script(script)
                  $icon_span = css("#{path_verify} .#{class_name1}")
                  $text_span = css("#{path_verify} span:nth-child(2)")
                  $info_span = css("#{path_verify} .#{class_name2}")
                  return "FOUND"
                when "tick"
                  css(path_check).click
                  return path_check
                when "tick_avaya"
                  css(path_check_avaya).click
                when "invoke"
                  css("#{path_container} .nssg-action-invoke").click
                when "delete"
                  css("#{path_container} .nssg-action-delete").click
                when "duplicate"
                  css("#{path_container} .nssg-action-duplicate").click
                when "cli"
                  css("#{path_container} .nssg-action-cli").click
                when "edit"
                  css("#{path_container} .nssg-action-edit").click #nssg-action-edit
                when "scope"
                  css("#{path_container} .nssg-action-scope").click
                when "unassign"
                  css("#{path_container} .nssg-action-unassign").click
                when "activate_provider"
                  css("#{path_container} .nssg-action-activate").click
                when "deactivate_provider"
                  css("#{path_container} .nssg-action-deactivate").click
                when "verify_provider_icon"
                  #css("#{path_verify} span:nth-child(1)").hover
                  $expected_icon_class = css("#{path_verify} .#{class_name1}").attribute_value("class")
              end
              # exit the loop
              break
            end
            # go line by line
            $grid_length-=1
            # after checking the last line in the grid (first one) start the following procedure
             if ($grid_length == 0)
              if (css('.nssg-paging-controls .nssg-paging-next').present?)
                css('.nssg-paging-controls .nssg-paging-next').click
                sleep 4
              else
                puts "Cannot find the proper line in the grid - searching for entry '#{name}'"
                $search_failed_booleand = false
                break
              end
              get_grid_length
              redo
            end
          end
      end

      def get_grid_length_new
        grid_entries = css('.nssg-table tbody')
        grid_entries.wait_until(&:present?)
        grid_length = grid_entries.trs.length
        return grid_length
      end
    def id(_id)
      get(:element,{id: _id})
    end
    # if method is called on the UI class that does not exist
      # see if the b = Watir::Browser will handle it - this does have a performance cost
      def method_missing(name, *args)
        # puts "method_missing being called - #{name} with args #{args.to_s}"
        as_sym = name.to_sym
        as_string = name.to_s
        if @browser.respond_to?(as_string, include_private = false)# this is experimental
          # puts "browser respond_to #{as_string} , sending to browser"
          @browser.send(as_string,*args)
        else
          super # You *must* call super if you don't handle the
                # method, otherwise you'll mess up Ruby's method
                # lookup.
        end
      end

      ###################################################################################
 def set_val_for_input_field(cssval, val)
        obj = get(:input, { css: cssval})
        obj.wait_until(&:present?)
        del_times = obj.value.size
        if(val)
          obj.click
          while(del_times!=0)
            browser.send_keys :backspace
            del_times -= 1
          end
          2.times do
            browser.send_keys :delete
          end
          browser.send_keys val
        else
          obj.clear
        end
      end
    def set_text_field_by_id(_id, value)
      tf = get(:text_field,{id: _id})
      sleep 5
      tf.wait_until_present
      tf.clear
      tf.value = value.strip
      sleep 1
      tf.fire_event("onblur")
      @browser.send_keys :tab
      sleep 1
    end
 def set_input_val(cssval, val)
      if css(cssval).present? != true
        @css = cssval
        browser.execute_script("$(\"#{@css}\").click()")
      end
      obj = get(:text_field, { css: cssval})
      obj.wait_until(&:present?)
      if(val)
      obj.value.length.times do
        obj.send_keys(:backspace)
      end
      obj.set val
      else
      obj.clear
      end
    end

      def set_textarea_val(cssval, val)
        obj = get(:textarea, { css: cssval})
        obj.wait_until(&:present?)
        obj.set val
      end

      def hover(css)
        css(css).wait_until(&:present?)
        css(css).focus
        @css = css
        script = "$(\"#{@css}\").mousedown()"
        browser.execute_script(script)
        css(css).fire_event("onmouseover")
        css(css).fire_event("mousemove")
        css(css).fire_event("mousedown")
        sleep 2
      end
      def login_without_url(username, password)
        login_form.wait_until(&:present?)
        login_form_username_field.clear
        login_form_username_field.send_keys(username)
        login_form_password_field.clear
        login_form_password_field.send_keys(password)
        login_form_submit_btn.click
      end
      def header_user_link
        header_right_nav.li(id: "header_nav_user").wait_until(&:present?)
        header_right_nav.li(id: "header_nav_user")
      end
      def header_logout_link
        a(id: "header_logout_link")
      end
      def header_right_nav
        id("header_right_nav")
      end

      def header_contact_link
        header_right_nav.wait_until(&:present?)
        header_right_nav.li(id: "header_nav_contact").a(id: "header_contact_link")
      end
    def logout
        header_user_link.wait_until(&:present?)
        header_user_link.click
        sleep 1
        header_logout_link.wait_until(&:present?)
        header_logout_link.click
    end
    def forgot_password_link
        div(id: "forgot").links[0]
      end

      def reset_form
        form(action: "/j_reset_password")
      end

      def reset_password(username)
        forgot_password_link.wait_until_present
        forgot_password_link.click
        sleep 1
        reset_form.wait_until_present
        reset_form.text_field(name: "j_username").send_keys(username)
        reset_form.input(css: ".button.submitBtn").click
      end

      def welcome_modal
        div(id: "welcome")
      end
    def set_dropdown_entry_by_path(path_of_dropdown_control, value_to_set)
        if path_of_dropdown_control.include?(".ko_dropdownlist_combo")
          dropdown = css(path_of_dropdown_control + ' .ko_dropdownlist_combo_btn')
        else
          dropdown = css(path_of_dropdown_control + ' .ko_dropdownlist_button')
        end
        @position = dropdown.wd.location
        browser.execute_script("body.scrollTop=#{@position[1]}")
        sleep 1
        if !["firefox", "edge"].include? $the_browser_used
          dropdown.hover
        end
        sleep 2
        dropdown.click
        sleep 1
        dropdown_list = css('.ko_dropdownlist_list.active')
        sleep 0.5
        dropdown_list.li(text: value_to_set).click
      end

      def set_dropdown_entry(dropdown_id, value)
        dropdown = id(dropdown_id).a(css: ".ko_dropdownlist_button")
        @position = dropdown.wd.location
        browser.execute_script("body.scrollTop=#{@position[1]}")
        sleep 1
        if !["firefox", "edge"].include? $the_browser_used
          dropdown.hover
        end
        sleep 2
        dropdown.click
        sleep 2
        if !["firefox", "edge"].include? $the_browser_used
          dd_active.li(text: value).hover
        end
        sleep 1
        dd_active.li(text: value).click
      end
      def ul_list_select_by_index(string_address, index)
        list_path = css(string_address)
        list_path.wait_until(&:present?)
        li = list_path.lis.select{|li| li.present?}[index]
        li.wait_until(&:present?)
        li.click
      end

      def ul_list_select_by_string(string_address, string)
        list = css(string_address)
        list.wait_until(&:present?)
        list_length = list.lis.length
        begin
          list_length-=1
          li = list.lis.select{|li| li.present?}[list_length]
          if (li.text == string)
            sleep 0.5
            li.click
            break
          end
        end while (list_length > 0)
      end
      def show_needed_control(css)
         @css = css
         browser.execute_script("$(\"#{@css}\").show()")
      end
      def dd_active
       browser.div(css: ".ko_dropdownlist_list.active")
      end
      def confirm_dialog
        dialog_box = browser.div(css: ".dialogBox.confirm")
        dialog_box.wait_until(&:present?)
        dialog_box.div(id: "confirmButtons").a(css: '.default').click
      end

      def cancel_dialog
        dialog_box = browser.div(css: ".dialogBox.confirm")
        dialog_box.wait_until(&:present?)
        dialog_box.div(id: "confirmButtons").a(css: '.cancel').click
      end
      def click_drop_btn(list_el)

        a = list_el.a(css: ".ko_dropdownlist_button")
        a.wait_until(&:present?)
        a.click

      end
      def change_tenant(tenant_name)
        if id("tenant_scope_options").exists?
          tenant_dropdown = id("tenant_scope_options").a(css: ".ko_dropdownlist_button").click
          sleep 1
          dd_active.li(text: tenant_name).click
          sleep 3
        end
        #tab("Access Points").wait_until(&:present?)
        #tab("Clients").wait_until(&:present?)
      end
def goto_mynetwork
       id("header_mynetwork_link").wait_until(&:present?)
       id("header_mynetwork_link").click
     end


     def goto_all_guestportals_view
       if header_left_nav.present? != true
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
    def add_ssid(ssid_names)
      ssid_id=ssid_names.split(",")

      for i in 0..ssid_id.length-1
        ssid = ssid_id[i]

        if ssid == 'honeypot'

          if @browser.div(:id => 'profile_config_ssids_view').a(:id => 'ssids_show_advanced').present?
            @browser.div(:id => 'profile_config_ssids_view').a(:id => 'ssids_show_advanced').click
            @browser.div(:id => 'profile_config_ssids_view').a(:id => 'ssids_show_advanced', :text => 'Hide Advanced').wait_until_present
          end

          @browser.div(:id => 'ssid_grid').div(:class => 'base_top').a(:id => 'ssid_honeypot_btn').wait_until_present
          @browser.div(:id => 'ssid_grid').div(:class => 'base_top').a(:id => 'ssid_honeypot_btn').click

        else

          @browser.a(:id=> 'profile_ssid_addnew_btn').wait_until_present
          @browser.a(:id=> 'profile_ssid_addnew_btn').click
          sleep 2

          @browser.tr(:class => 'nssg-tbody-tr is-active').text_field(:type => 'text').set "#{ssid}"
          #@browser.div(:class => 'inner').text_field(:type => 'text').set "#{ssid}"
          @browser.div(:text=> 'SSIDs').wait_until_present
          @browser.div(:text=> 'SSIDs').click
        end
        sleep 2
      end

    end

    def goto_guestportal(name)
      goto_all_guestportals_view
      sleep 2
      tile = gpv.tile(name)
      tile.wait_until(&:present?)
      tile.fire_event("onmouseover")
     # tile.fire_event("onclick")
      tile.element(text: name).fire_event("onclick")
      sleep 2
      @browser.a(text: "Save All").wait_until(&:present?)
    end

    def manage_guests
      a(text: "Manage Guests").wait_until(&:present?)
      a(text: "Manage Guests").click
    end
    def login(login_url, username, password)
      go(login_url)
      sleep 1
      6.times do
        unless login_form.exists?
          b.refresh
          sleep 10
        end
      end
      login_form.wait_until(&:present?)
      login_form_username_field.clear
      login_form_username_field.send_keys(username)
      sleep 2
      login_form_password_field.clear
      login_form_password_field.send_keys(password)
      sleep 5
      @browser.input(css: ".button.submitBtn").click
      # If License agreement page show up press Accept and login
      sleep 2
      if (css('.login_form').exists?)
        click('.submitBtn')
        sleep 1
      end
    end

    def error_dialog
      get(:div, { css: ".error" })
    end

    def error_title
      error_dialog.div(css: ".title").span.text
    end

    def error_msgbody
      error_dialog.div(css: ".msgbody")
    end

    def error_msgbody_text
      error_msgbody.div.text
    end

    def error_dialog_close
      error_dialog.span(css: ".dialog-close")
    end

    def close_error_dialog(d)
      d.span(css: ".dialog-close")
    end

    def temp_error
      div(css: ".temperror")
    end

    def toast_dialog
      get(:div, {id: 'toast-container'})
    end

    def toast_dialog_ok_button
      get(:button, {css: '#toast-container .toast-btn-container .btn'})
    end

    def easypass_upgrade_modal
      get(:element, {css: ".easypass-upgrade-modal"})
    end

    def easypass_upgrade_modal_close_button
      get(:a, {css: ".easypass-upgrade-modal .xc-modal-close"})
    end
     def verify_grid_is_on_first_page
        # verify if the 'go to first' page control is visible
        if (css('.nssg-paging-controls .nssg-paging-first').exists?)
          if (css('.nssg-paging-controls .nssg-paging-first').present?)
            # send the application to the first page of the grid
            css('.nssg-paging-controls .nssg-paging-first').click
            sleep 0.5
          else
            puts "The grid is on the first page"
          end
        end
      end
      def clear_hover
        get(:element, {id: 'header_logo'}).hover
      end
            def set_paging_view_for_grid(string_address, string)
        if css('.nssg-paging .nssg-paging-selector-container .nssg-paging-pages a span:first-child').exists?
          if css('.nssg-paging .nssg-paging-selector-container .nssg-paging-pages a span:first-child').present?
            paging_view_selected = css('.nssg-paging .nssg-paging-selector-container .nssg-paging-pages a span:first-child').text
            if (paging_view_selected == string)
              puts "View is already #{string} entries per page - skipping"
            else
              paging_selector = css('.nssg-paging .nssg-paging-selector-container .nssg-paging-pages a .arrow')
              paging_selector.wait_until(&:present?)
              paging_selector.click
              ul_list_select_by_string(string_address, string)
              sleep 3
              css('.nssg-paging-selector-container').wait_until(&:present?)
              if css('.loading').exists?
                css(".loading").wait_while_present
              end
            end
          end
        end
      end

      def mouse_down_on_element_move_to(string_address, target_address)
        driver = @browser.driver
        target = css(target_address)
        element = css(string_address)
        element.hover
        element.fire_event('onmousedown')
        sleep 2
        driver.action.click_and_hold(element.wd).perform
        driver.action.move_to(target.wd).perform
        sleep 2
        element.fire_event('onmouseup')
      end

      def mouse_down_on_element(string_address)

        element = css(string_address)
        element.hover
        element.fire_event('onmousedown')
        sleep 2
      end

      def mouse_up_on_element(string_address)
        element = css(string_address)
        element.hover
        element.fire_event('onmouseup')
        sleep 2
      end
      def get_grid_header_count_support_manegement
        if css('.nssg-table .nssg-thead').trs.length != 0
          header = css('.nssg-table .nssg-thead')
        elsif css('.nssg-table .nssg-thead:nth-of-type(2)').trs.length != 0
          header = css('.nssg-table .nssg-thead:nth-of-type(2)')
        end
        header.wait_until(&:present?)
        $header_count = header.ths.length
        hc = header.ths.length
        return  hc
      end
      def wait_while_browser_url_matches_certain_string(url_string)
        i = 0
        while browser.url != "https://xcs-#{$the_environment_used}.cloud.xirrus.com/#{url_string}"
          sleep 0.5
          i += 1
          if i == 60
            return false
          end
        end
        return true
      end
  end
end # GUI module