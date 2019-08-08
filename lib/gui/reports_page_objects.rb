  module GUI
    module ReportsPageObjects
        def reports_view
          ReportsView.new(@browser)
        end

        def header_reports_menu_item_with_name(name)
            pi = css("#report_items")
            pi.wait_until(&:present?)
            pi.element(:class => /title/, :text => name)
            pi.parent
        end

        def view_all_reports
          if (!@browser.url.end_with? "#reports")
            click('#header_nav_reports')
            click('#header_nav_reports #view_all_nav_item')
          end
        end

        def reports_tile(report)
          get(:span,{title: report})
        end

        def goto_report(report)
          # check to see if the report is already opened
          if (@browser.url.match(/#reports\/[a-z0-9]{8}(?:-[a-z0-9]{4}){3}-[a-z0-9]{12}\/[a-zA-Z]/i))
            # check the report name
            pn = id("profile_name")
            pn.wait_until(&:present?)
            if (pn.text == report)
              return "already in report"
            end
          end

          view_all_reports
          sleep 3
          get(:span,{title: report}).wait_until(&:present?)
          get(:span,{title: report}).click   
        end

        def report_tile_with_name(name)
          pt = id("reports_list")
          pt.wait_until(&:present?)
          pt = pt.element(:css => ".tile a span[title='" + name + "']")
          sleep 0.5
          pt.parent.parent
        end

        def report_tile_with_name_new(name)
          reports_list = get(:elements , {css: "#reports_list .ko_container .tile"}).length
          while reports_list > 0
            if css("#reports_list .ko_container li:nth-child(#{reports_list}) .title").text == name
              puts "#reports_list .ko_container li:nth-child(#{reports_list})"
              return "#reports_list .ko_container li:nth-child(#{reports_list})"
            end
            reports_list -= 1
          end
        end

        def delete_all_reports
          view_all_reports

          list = css('#reports_list .ui-sortable')
          list.wait_until(&:present?)

          tiles = list.lis(:class => 'custom')
          if(tiles.length>0)
            puts "Deleting non-precanned reports"
          end
          while(tiles.length>0)
              tile = list.li(:class => 'custom')
              tile.hover
              sleep 1
              tile.element(:css => ".overlay .deleteIcon").click
              sleep 0.5
              confirm_dialog
              sleep 1

              tiles = list.lis(:class => 'custom')
          end

          sleep 1


        end

        class ReportsView
          def initialize(browser)
            @browser = browser
          end

          def reports_list
            @browser.div(id: "reports_list")
          end
        end
 end # ReportsPageObjects
end # GUI
















