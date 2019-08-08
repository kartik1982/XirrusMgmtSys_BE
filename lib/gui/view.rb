require_relative '../util/util.rb'
module GUI
    class View     
      include UTIL 
      def initialize(browser)
        @browser = browser
      end
    
      #def dd_active
      #  @browser.dd(css: ".ko_dropdownlist_list.active")
      #end

    end # View

    class Grid
      include UTIL
      
      def initialize(browser)
      	@browser = browser
      end


      #def dd_active
      #  @browser.dd(css: ".ko_dropdownlist_list.active")
      #end

      def col_header(text)
        el.th(xpath: ".//div[@class='gridhead']/a[./text() = '#{text}']")
      end

      
      def base_top
        el.div(css: ".base_top")
      end

      def pages_total
        base_top.el.div(css: '.grid_pageLinks').span(css: '.total').text
      end

      def page_links
        base_top.div(css: ".grid_pageLinks").links
      end

      def first_page_link
        page_links[0]
      end

      def prev_page_link
        page_links[1]
      end

      def next_page_link
        page_links[2]
      end

      def last_page_link
        page_links[3]
      end 

      def pages_total
        base_top.div(css: ".grid_pageLinks").span(css: '.total')
      end

      def rowCount
        base_top.span(css: ".rowCount")
      end

      def pages_row_count
         rowCount.strong(xpath: ".//strong[2]").text
      end

      def select_column
        el.th(css: ".select_column")
      end

      def select_all
        select_column.wait_until(&:present?)
        select_column.label.click
      end

      def row(name)
      	Row.new(name,@browser)
      end

      

      class Row
        attr_reader :name
        include UTIL
        def initialize(name, browser)
          @name = name
          @browser = browser
          title_span = @browser.send(:span,{title: name})
          title_span.wait_until(&:present?)
          @el = @browser.send(:span,{title: name}).parent.parent.parent

        end

          def view_row
            el.div(css: ".view_row")
          end

          def html
            @el.html
          end

          def column(selector_hash)
            el.td(selector_hash)
          end

          def column_by_data_field(field_name)
            column(data_field: field_name)
          end

          def delete_icon
            view_row.a(css: ".view_row_icon.delete")
          end

          def select_column
            el.td(css: ".select_column")
          end

          def select
            select_column.label.click
          end
          

          def name_column
            el.td(css: ".name")
          end

           # if method is called on the UI class that does not exist
      # see if the b = Watir::Browser will handle it - this does have a performance cost
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


      end # Row

      #### Row by div, new version of Row, with div inside instead of span ####
      def row_div(name)
      	RowDiv.new(name,@browser)
      end

      class RowDiv
        attr_reader :name
        include UTIL
        def initialize(name, browser)
          @name = name
          @browser = browser
          title_span = @browser.send(:div,{title: name})
          title_span.wait_until(&:present?)
          @el = @browser.send(:div,{title: name}).parent.parent
        end

        def view_row
          el.div(css: ".nssg-actions-container")
        end

        def html
          @el.html
        end

        def column(selector_hash)
          el.td(selector_hash)
        end

        def column_by_data_field(field_name)
          column(data_field: field_name)
        end

        def delete_icon
          view_row.a(css: ".nssg-action-delete")
        end

        def select_column
          el.td(css: ".select_column")
        end

        def select
          select_column.label.click
        end

        def name_column
          el.td(css: ".name")
        end

        # if method is called on the UI class that does not exist
        # see if the b = Watir::Browser will handle it - this does have a performance cost
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
      end # RowDiv

    end # Grid 
end