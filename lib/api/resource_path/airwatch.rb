module XMS
  module NG
  	class ApiClient

      def add_or_update_airwatch(args = {})
      	put("/thirdParty.json/airwatch", args)
      end

      def add_air(args = {})
        add_or_update_airwatch(args)
      end

      def get_airwatch
        get("/thirdParty.json/airwatch")
      end

      def delete_airwatch
        delete("/thirdParty.json/airwatch")
      end



  	end
  end
end