module XMS
  module NG
  	class ApiClient

      def get_clients(args = {})
      	get("/clients.json/", args)
      end

      alias_method :clients, :get_clients

      def search_clients(search_term, args = {})
      	get("/clients.json/search/#{search_term}",args)
      end


  	end
  end
end