module GUI
      class UI

        def policy_toggle_div(name)
          PolicyToggleDiv.new(@browser,name)
        end


        #### New Rule Modal methods
        def autoname_box
          @browser.checkbox(id: "auto_name_checkbox")
        end

        def uncheck_auto_name_box
          new_rule_modal = id("new_rule_modal")
          new_rule_modal.wait_until_present
          auto_name_cont = id("rule_autoname")
          auto_name_cont.wait_until_present
          auto_name_label =  auto_name_cont.div(text: "Auto-Name")
          auto_name_label.wait_until_present
          auto_name_input = new_rule_modal.input(id: "rule_name")
          auto_name_input.wait_until_present

          auto_name_input_checked = auto_name_input.disabled? ? true : false
          puts "auto checked? #{auto_name_input_checked}"
          if auto_name_input_checked
            auto_name_label.click
          end
        end

        #### END New Rule Modal methods



        #### SCHEDULING

        def policy_schedule_modal
          id("policy_schedule_modal")
        end

        # hidden checkbox check - presence of 'checked' attribute = true
        def day_checked?(day_int)
          checked_val = id("scheduleDaypicker").input(xpath: "./input[./@id = 'scheduleDaypicker_day_#{day_int}']").attribute_value('checked')
          #puts "Checked Val: #{checked_val}, #{checked_val.class}"
          val_to_return = (checked_val == "true") ? true : false
          val_to_return
        end
        
        # 0 = Sunday, 1 = Monday ... 6 = Saturday
        def click_day_picker(day_int = 0)
          id("scheduleDaypicker").label(xpath: "./label[@for='scheduleDaypicker_day_#{day_int}']").click 
          id("scheduleDaypicker").input(xpath: "./input[@id='scheduleDaypicker_day_#{day_int}']").attribute_value('checked')
        end

        # policy_schedule_modal must be visible - see 'set_schedule' method lower in this file
        def schedule_days(day_ints = [1,3,5])
          (0..6).each {|day_int|
            is_checked = day_checked?(day_int)
           # puts "is checked : #{is_checked}"
            should_be_checked = day_ints.include?(day_int)
           # puts "should_be_checked : #{should_be_checked}"
            if (!is_checked && should_be_checked)
              click_day_picker(day_int)
            elsif (is_checked && !should_be_checked)
              click_day_picker(day_int)
            else

            end
          }        
          current_scheduled_days
        end # schedule days

        def current_scheduled_days
          current_days = []
          (0..6).each{|day_int|
            if day_checked?(day_int)
              current_days << day_int
            end
          } 
          current_days
        end

        def start_time_field
          policy_schedule_modal.text_field(id: "scheduleStartTime")
        end

        def end_time_field
          policy_schedule_modal.text_field(id: "scheduleEndTime")
        end

        def current_scheduled_time
          { start_time: start_time_field.value, end_time: end_time_field.value, all_day: all_day_checked? }
        end

        def schedule_time(start_time = "8:15 am", end_time = "4:45 pm")
          if start_time == "All Day"
            set_all_day
          elsif (start_time == nil)

          else
            start_time_field.set(start_time)
            end_time_field.set(end_time)
          end
          current_scheduled_time
        end

        def all_day_box
          policy_schedule_modal.div(id: "allDayContainer").input(id: "scheduleAllDay")
        end

        def all_day_label
          policy_schedule_modal.div(id: "allDayContainer").label(text: "All Day")
        end

        def all_day_checked?
          checked_val = all_day_box.attribute_value("checked")
          val_to_return = (checked_val == "true") ? true : false
          val_to_return
        end

        def change_all_day_setting
          all_day_label.click 
        end

        def set_all_day
          if all_day_checked? 

          else
            change_all_day_setting
          end
          all_day_checked?
        end

        def submit_schedule
          a(id: "scheduleModalSubmit").click 
        end

        def open_schedule_modal(policy_name)
          policy_toggle_div = policy_toggle_div(policy_name)
          policy_toggle_div.wait_until(&:present?)

          schedule_icon = policy_toggle_div.schedule_icon
          schedule_icon.wait_until_present
          schedule_icon.click
          sleep 1
          policy_schedule_modal
        end


        def set_policy_schedule(policy_name,days=[1,3,5],start_time = "7:15 am", end_time = "4:45 pm")

          open_schedule_modal(policy_name)

          scheduled_days = schedule_days(days)

          scheduled_time = schedule_time(start_time, end_time)  

          submit_schedule
          
          sleep 1
          policy_schedule_modal.wait_while_present
          pcv.save_all
          sleep 2
          { scheduled_days: scheduled_days, scheduled_time: scheduled_time }
        end

        def policy_rule_div(policy_name, rule_name)
          policy_toggle_div(policy_name).rule_div(rule_name)
        end

        def set_rule_schedule(policy_name, rule_name, days=[2,4], start_time = "11:30 am", end_time = "1:45 pm")
          rule_div = policy_toggle_div(policy_name).rule_div(rule_name)

          #rule_div.schedule_rule_icon.click
          #AF - 4/1/19

          # if policy_name == "tagA"
          # # @browser.element(:xpath => "/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div[3]/div/div[5]/div[2]/div/div[1]/div[2]/span[2]/i").click
          # @browser.element(css: ".policy-type-container:nth-child(2) div.policy-rule-layer-container:nth-child(2) ul li:nth-child(1) .policy-rule-menu-btn.xcp-icon-menu").click
          # sleep 1
          # # @browser.element(:xpath => "/html/body/div[1]/div[2]/div[1]/div/div[2]/div/div[3]/div/div[5]/div[2]/div/div[1]/div[2]/span[2]/ul/li[2]").click
          # @browser.element(css: ".policy-rule-menu-container.xc-dropdown.active .xcp-icon-schedule").click
          # else
          rule_div.schedule_rule_icon.click
          # end  
          
          sleep 1
          policy_schedule_modal.wait_until_present
          schedule_days = schedule_days(days)
          scheduled_time = schedule_time(start_time, end_time)
         
          submit_schedule
          sleep 1
          pcv.save_all
          sleep 2
          { schedule_days: schedule_days, scheduled_time: scheduled_time}
        end

        #### END SCHEDULING methods


        class PolicyToggleDiv
          attr_accessor :name, :browser
          def initialize(browser, name)
            @name = name
            @browser = browser
            modal = @browser.div(:id => 'profile_config_policies')
            modal.wait_until_present
            @el = modal.span(:text => name).parent.parent.parent
            @el.wait_until_present
            @browser.execute_script('$("#suggestion_box").hide()')
            @el
          end

          def toggle_policy_menu
            menu_el = el.i(class: "xcp-icon-menu")
            menu_el.wait_until_present
            menu_el.click
            sleep 1
          end

          def schedule_icon
            toggle_policy_menu()
            edit_el = el.li(class: "xcp-icon-schedule")
            edit_el.wait_until_present
            edit_el
          end

          def toggle_advanced_icon
            el.a(class: "policy-show-advanced")
          end

          # Show advanced section if action is true Hide otherwise.
          def toggle_advanced(action)
            toggle_advanced_icon.click if toggle_advanced_icon.text.include?("Show Advanced") == action
          end
          def el
            #get(:div, {id: "profile_config_view"})
            @el
          end
          def expand_icon
            el.i(:css => ".policy-toggle-icon.xcp-icon-triangle")
          end

          def expanded?
            expand_icon.class_name.include?("active")
          end

          def expand
            #puts "Expanded?? : #{expanded?}"
            if expand_icon.visible? && !expanded?
              expand_icon.click
              sleep 1
            end
          end

          def first_app_rule_btn
            el.div(:text=>'Add a rule')
          end

          def rule_div(rule_name)
            expand
            sleep 2
            PolicyRuleDiv.new(@browser, @el, rule_name)
          end

          # see if the el = Watir::Element will handle it 
          def method_missing(name, *args)
           # puts "method_missing being called in #{self} is being sent to 'el' - #{name} with args #{args.to_s}"
            as_sym = name.to_sym 
            as_string = name.to_s
            if el.respond_to?(as_string, include_private = false)
              el.send(as_string,*args)
            else
              puts "#{self} does not respond_to #{name}"
              super # You *must* call super if you don't handle the
                # method, otherwise you'll mess up Ruby's method
                # lookup.
            end
          end


        end # PolicyToggleDiv


        class PolicyRuleDiv
          attr_accessor :name 
          def initialize(browser, policy_el, name)
            @name = name
            @browser = browser
            @el = policy_el.a(:text => name).parent
            @el.wait_until_present
            @el
          end


          def toggle_rule_menu
            menu_el = @el.i(css: ".policy-rule-menu-btn.xcp-icon-menu")
            h = menu_el.html
            menu_el.wait_until_present
            #Need to check why not scrolling
            # @browser.scroll.to(menu_el)
            menu_el.click
            sleep 1
          end

          def schedule_rule_icon
            toggle_rule_menu()
            edit_el = @el.li(class: "xcp-icon-schedule")
            edit_el.wait_until_present
            edit_el
          end

          def trash_icon
            toggle_rule_menu()
            edit_el = @el.li(class: "xcp-icon-trash")
            edit_el.wait_until_present
            edit_el
          end

           # see if the el = Watir::Element will handle it 
          def method_missing(name, *args)
           # puts "method_missing being called in #{self} is being sent to 'el' - #{name} with args #{args.to_s}"
            as_sym = name.to_sym 
            as_string = name.to_s
            if el.respond_to?(as_string, include_private = false)
              el.send(as_string,*args)
            else
              puts "#{self} does not respond_to #{name}"
              super # You *must* call super if you don't handle the
                # method, otherwise you'll mess up Ruby's method
                # lookup.
            end
          end

        end # PolicyRuleDiv
      end # UI
end # XMS