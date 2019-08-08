module API
    class ApiClient

      def delete_ssodomain(id)
        delete("/ssodomain.json/#{id}")
      end

      def get_ssodomain_all_tenants
        get("/ssodomain.json/allTenants")
      end

    end # ApiClient
end # XMS