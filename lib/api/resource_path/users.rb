module API
    class ApiClient
      def tenant_users(tenant_id, params = {})
        get("/tenants.json/#{tenant_id}/users", params)
      end

      def update_tenant_user(tenant_id, user_id, params = {})
        put("/tenants.json/#{tenant_id}/users/#{user_id}", params)
      end

    

      # gets users for tenant of current token
      def users(args = {})
        get("/users.json",args)
      end

      def add_user(xirrus_user)
       post("/users.json/",xirrus_user)
      end

      def delete_user(id)
        delete("/users.json/#{id}")
      end

      def delete_user_by_email(email)
        user_res = get_user_by_email_for_any_tenant({:email=>email})
          begin
            delete_user(user_res.body["id"]) if user_res.code == 200
          rescue => e
            puts e
        end        
      end
  end
end