module GUI
  class UI
      #####################################
      ### MY NETWORK NAVIGATION METHODS ###
      #####################################
      def goto_overview_tab
        _goto_tab("mynetwork_tab_overview")
      end

      def goto_access_points_tab
        _goto_tab("mynetwork_tab_arrays")
      end

      def goto_clients_tab
        _goto_tab("mynetwork_tab_clients")
      end

      def goto_alerts_tab
        _goto_tab("mynetwork_tab_alerts")
      end

      def goto_floor_plans_tab
        _goto_tab("mynetwork_tab_locations")
      end


      def dashboard_tiles_container
        div(css: ".dashboardTilesContainer")
      end
 
      def dashboard_tiles
        ul(css: ".dashboardTiles")
      end

      def dashboard_tile(tile_name)
        dashboard_tiles.li(css: ".#{tile_name}")
      end

      def fullscreen_btn
        a(id: "mynetwork_overview_full_screen")
      end
    
      ##### GeoMaps geomaps Geomaps

      def geo_widget
        div(css: ".widget_geomap")
      end

      def geo_container
        geo_widget.div(css: ".geomap_container")
      end

      def geo_map_container
        geo_container.div(css: ".geomap_map_container")
      end

      def map_buttons
        div(css: ".map_button")
      end

      def map_slideout_icon
        geo_container.a(css: ".slideout_icon.mapSlideoutToggle")
      end

      def open_map_slideout
        unless div(css: ".mapSlideout").attribute_value("class").include?("active")
          map_slideout_icon.click
        end
      end

      def geomap_tab(tab_title)
        div(css: ".geomap_tabs").a(title: tab_title)
      end

      def geoarrays
        div(css: ".geoarrays")
      end

      def geoarray_row(serial)
        geoarrays.label(text: serial).parent
      end

      def geo_arraysContainer
        geo_container.div(css: ".arraysContainer")
      end

      def map_zoom_in_btn
        geo_container.a(css: ".leaflet-control-zoom-in")
      end

      def map_zoom_out_btn
        geo_container.a(css: ".leaflet-control-zoom-out")
      end



      ##### Drag and Drop Arrays to Map
      def add_arrays_to_geomap(array_serials = [], horizontal, vertical)
        geo_map_container.wait_until_present
        sleep 0.5

        open_map_slideout
        sleep 0.5

        geomap_tab("Access Points").click

        sleep 0.5
        geoarrays.wait_until_present

        array_serials.each {|serial|

          row = geoarray_row(serial)

          row.label(text: serial).click      
        }

        arraysContainer = geo_arraysContainer.drag_and_drop_by horizontal, vertical

        sleep 1

        a(text: "Accept").click

        sleep 1
      end 

      ##### End Geomaps


      def wait_for_grid_loading
        div(css: ".grid_wrap.loading").wait_while_present
      end

      def array_to_profile(serial, profile_name)
        a(id: "header_mynetwork_link").wait_until_present
        a(id: "header_mynetwork_link").click
        sleep 8
        tab('Access Points').click
        sleep 3
        #div(css: ".grid_wrap.loading").wait_while_present

        row = array_grid.row(serial)
        row.select
        sleep 2
        @browser.span(id: "mynetwork_arrays_moveto_btn").wait_until_present
        @browser.span(id: "mynetwork_arrays_moveto_btn").click
        sleep 1
        link = array_grid.a(title: profile_name)
        link.wd.location_once_scrolled_into_view
        link.click
        sleep 1
        confirm_dialog
      end

      def network_slideout(array_hostname)
        sleep 1
        row = array_grid.row(array_hostname)
        row.wait_until_present
        row.hover 
        sleep 2
        css('.nssg-action.nssg-action-invoke').click
        array_slideout
      end

      def ap_grid
        ApGrid.new( @browser )
      end

      def search_for_ap(serial)
        search_section = nil
        @browser.divs(css: ".xc-search").each do |el|
          search_section = el if el.present?
        end

        text_field = search_section.text_field
        search_btn = search_section.button(css: ".btn-search")
        text_field.clear
        search_btn.wait_until_present
        search_btn.click
        text_field.set(serial)
        search_btn.click if search_btn.present?
      end


      def clients_grid
        ClientsGrid.new( @browser )
      end


      def modal_move_btn
        @browser.a(id: "column_selector_modal_move_btn")
      end

      def modal_remove_btn
        @browser.a(id: "column_selector_modal_remove_btn")
      end

      def open_column_selector_modal
        div(css: ".icon.columnPickerIcon").click 
        sleep 1 
        this_modal = div(css: ".column_selector_modal")
        this_modal.wait_until_present
        this_modal
      end


      def add_columns_to_grid(column_text = ["Guest Email"])
       
        this_modal = open_column_selector_modal
        
        # selected list 
        right_side = this_modal.div(css: ".rhs.greybox").ul 
        column_text.each do |col_text|
          already_selected = right_side.li(text: col_text)
          unless already_selected.exists?
            # unselected list
            left_side = this_modal.div(css: ".lhs.greybox").ul
            li = left_side.li(text: col_text)
            li.wd.location_once_scrolled_into_view 
            li.click 
            modal_move_btn.click
          end
        end # column_text each
        this_modal.a(id: "column_selector_modal_save_btn").click
      end



      def rm_columns_from_grid(column_text = ["Guest Email"])
        this_modal = open_column_selector_modal
        
        # selected list 
        left_side = this_modal.div(css: ".lhs.greybox").ul 
        column_text.each do |col_text|
          already_selected = left_side.li(text: col_text)
          unless already_selected.exists?
            # unselected list
            right_side = this_modal.div(css: ".rhs.greybox").ul
            li = right_side.li(text: col_text)
            li.wd.location_once_scrolled_into_view 
            li.click 
            modal_remove_btn.click
          end
        end # column_text each
        this_modal.a(id: "column_selector_modal_save_btn").click
      end

     

      class ApGrid

        def initialize(browser)
          super(browser)
        end

        def row(name)
          Row.new(self, name,@browser)
        end

        class Row 

          AP_GRID_DATA_FIELDS.each do |key, value|
           
            define_method("#{key}_column") do 
              column(key.to_s, value.to_s)
            end

            define_method("#{key}") do 
              self.send("#{key}_column".to_sym).text
            end
          end

          def initialize( parent_grid, name, browser )
            super( parent_grid, name, browser )
          end

          def hostname_column
              column("Access Point Hostname")
            end

            def status_column
              column("Status")
            end

            def current_status
              status_column.text
            end



        end # arrays grid row

      end # arrays grid



      class ClientsGrid 
        
        def initialize( browser)

          super(browser)
        end

        
        def row(_element)
          Row.new( self,_element, @browser )
        end



        class Row

                
          def initialize( _parent_grid, _element, browser )
            super( _parent_grid, _element, browser)
          end

          CLIENT_GRID_DATA_FIELDS.each do |key, value|

            #puts key,value
           
            define_method("#{key}_column") do 
              column(value)
            end

            define_method("#{key}") do 
              self.send("#{key}_column".to_sym).text
            end

          end

          def current_status
            status_column.text 
          end
        end # ClientsGrid::Row
      end # ClientsGrid


      ################################
      #### PRIVATE HELPER METHODS ####
      ################################
      private

      def _goto_tab(tab_el_id)
        tab_btn = id(tab_el_id)
        tab_btn.wait_until_present
        @browser.scroll.to tab_btn
        tab_btn.click
      end

    end
end