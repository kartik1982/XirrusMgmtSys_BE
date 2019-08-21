module API
    class ApiClient

      
      def tenantcircles(params={})
        get("/tenantcircles.json",params)
      end
       

      def circles(params={})
        tenantcircles(params)
      end

      def add_circle(circle_params) 
        post("/tenantcircles.json",circle_params )
      end

      # one param should be 'circleId'
      def circle_tenants(params = {})
      	get("/tenantcircles.json/tenants",params)
      end

      def delete_circle(_circle_id)
        delete("/tenantcircles.json/#{_circle_id}")
      end
      
      def delete_circle_by_name(circle_name)
        max_limit = 1000
        i = 200
        is_circle_removed = false

        while !is_circle_removed && i <= max_limit
          circles = tenantcircles({count: i}).body["data"]
          circles.each do |c|
            if c["name"] == circle_name
              delete_circle(c["id"])
              is_circle_removed = true
            end
          end
          i +=200
        end
        is_circle_removed
      end
      def update_circle(_circle_id, params = {})
        put("/tenantcircles.json/#{_circle_id}",params)
      end

      def tenants_to_circle(_circle_id, array_of_tenant_ids)
      	tenants_to_assign = array_to_body_string(array_of_tenant_ids)
        HTTParty.put("#{api_path}/tenantcircles.json/tenants/#{_circle_id}", { :body => tenants_to_assign, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }}) # RestClient Post
      end
      

    end # ApiClient
end # API