module XMS
  module NG

    class ReportTemplate
      attr_accessor :id, :description, :name, :iconUrl, :pages, :favorite
      def initialize(args={})
        @id = args[:id]
        @description = args[:description]
        @name = args[:name]
        @iconUrl = args[:iconUrl]
        @pages = args[:pages]
        @favorite = args[:favorite]
      end

      def add_page(report_template_page)
        @pages << report_template_page
      end

      def to_hash
        hash = {}
        self.instance_variables.each {|var| 
           if var == "@pages"
            hash[:pages] = self.pages
           else
            hash[var.delete("@").to_sym] = self.instance_variable_get(var) 
           end
        }
        hash 
      end
    end

    

    def self.report_widget_types
      %w[TOP_CLIENTS_BY_USAGE TOP_ARRAYS_BY_USAGE TOP_DEVICES_BY_USAGE TOP_MANUFACTURERS_BY_USAGE TOP_APPLICATIONS_BY_USAGE TOP_APP_CATEGORIES CLIENT_THROUGHPUT ARRAY_THROUGHPUT CLIENTS_OVER_TIME]
    end

    def self.report_ranges
      %w[DAY_1 DAY_7 DAY_30 HOUR_1]
    end

    

    class ApiClient

      def report_template_starter
        JSON.parse(File.read("#{XMS.fixtures_root}/json/reports/report_template_starter.json"))
      end

      def basic_report_template
         JSON.parse(File.read("#{XMS.fixtures_root}/json/reports/basic_report_template.json"))
      end

      def reports(args={})
        get("/reports.json/template",args)
      end

      def get_reports(args={})
        reports(args)
      end

      def create_report(args)
        post("/reports.json/template", args)
      end

      def add_report(args)
        create_report(args)
      end

      def get_report(_report_id)
        get("/reports.json/template/#{_report_id}")
      end

      def update_report(_report_id, updated_object)
        put("/reports.json/template/#{_report_id}", updated_object)
      end

      def delete_reports(_array_of_report_ids)
        body_string = array_to_body_string(_array_of_report_ids)
        HTTParty.delete("#{api_path}/reports.json/template", { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }})
      end


    end
  end
end