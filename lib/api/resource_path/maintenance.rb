module XMS
  module NG
    class ApiClient

      def upsert_appcons(csv_path)
      	if File.exist?(csv_path)
      	  file_content = File.open(csv_path,'r'){|fp| fp.read}
          encoded = Base64.encode64(file_content)
         # puts encoded
          post_file("/maintenance.json/upsertAppCons",encoded)
        else
          false
        end
      end

      def update_app_categories(csv_path)
        if File.exist?(csv_path)
          file_content = File.open(csv_path,'r'){|fp| fp.read}
          encoded = Base64.encode64(file_content)
          post_file("/maintenance.json/updateAppCategories",encoded)
        else
          false
        end
      end

    end
  end
end