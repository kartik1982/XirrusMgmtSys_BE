module API
    class ApiClient


      def tenants(args = {})
        get("/tenants.json/",args)
      end

      def current_tenant
        get("/tenants.json/current")
      end

      def tenant_by_name(name)
      	get("/tenants.json/name/#{name}")
      end

      def tenant_by_erp(erp)
        get("/tenants.json/erp-id/#{erp}")
      end

      def new_tenant(args = { name: nil, erpId: nil, products: nil, circleId: nil, shardId: nil, suspended: false, brand: nil, parentName: nil, parentId: nil, tenantOwnership: nil })
        post("/tenants.json", { name: args[:name], erpId: args[:erpId], products: args[:products], circleId: args[:circleId], shardId: args[:shardId], suspended: args[:suspended], brand: args[:brand],  parentName: args[:parentName], parentId: args[:parentId], tenantOwnership: args[:tenantOwnership]})
      end
      # It is required to use new_tenant_to_shard method to create a tenant in specific shard other
      # SHARD_ID is a constant defined
      def add_tenant(args = {name: nil, erpId: nil, tenantProperties: nil, products: nil, circleId: nil, shardId: nil, suspended: false, hasXR320: false, parentId: nil, brand: nil, region: nil, apCount: 0, description: "", tenantOwnership: "SELF" })
        post("/tenants.json/shard/#{SHARD_ID}", {
          name: args[:name],
          erpId: args[:erpId],
          tenantProperties: args[:tenantProperties],
          products: args[:products],
          circleId: args[:circleId],
          shardId: SHARD_ID,
          suspended: args[:suspended],
          hasXR320: args[:hasXR320],
          parentId: args[:parentId],
          brand: args[:brand],
          region: args[:region],
          apCount: args[:apCount],
          description: args[:description],
          tenantOwnership: args[:tenantOwnership]
        })
      end

      def new_tenant3(args = { name: nil, erpId: nil, products: nil, circleId: nil, shardId: nil, suspended: false, brand: nil, parentName: nil, parentID: nil, tenantOwnership: nil })
        post("/msp.json/tenants", { name: args[:name], erpId: args[:erpId], products: args[:products], circleId: args[:circleId], shardId: args[:shardId], suspended: args[:suspended], brand: args[:brand],  parentName: args[:parentName], parentID: args[:parentID], tenantOwnership: args[:tenantOwnership]})
      end

      def new_tenant_ad(name_val, erpId, products, circleId, shardId, suspended, brand, tenantProperties, parentName, parentID, tenantOwnership)
        post("/tenants.json/", { name: name_val, erpId: erpId, products: products, circleId: circleId, shardId: shardId, suspended: suspended, brand: brand, tenantProperties: tenantProperties, parentName: parentName, parentID: parentID, tenantOwnership: tenantOwnership})
      end

      def new_tenant_ad2(name_val, erpId, products, circleId, shardId, suspended, brand, tenantProperties, parentName, parentID, tenantOwnership)
        post("/tenants.json", [name_val, erpId, products,  circleId,  shardId, suspended,  brand,  tenantProperties,  parentName,  parentID,  tenantOwnership])
      end

      def new_tenant_to_shard(shardId, args={})
        post("/tenants.json/shard/#{shardId}",args)
      end

      def easy_xms_tenant(name_and_erp)
        products = ["XMS","BACKOFFICE"]
        new_tenant(args = {name: name_and_erp, erpId: name_and_erp, products: products})
      end

      def delete_tenant(tenant_id)
        delete("/tenants.json/#{tenant_id}")
      end

      def delete_tenant_if_name_or_erp_exists(name_erp)
        name_check = tenant_by_name(name_erp)
        #puts "Delete Tenant - name check"

        #res = "Before Delete"
        if( name_check.respond_to?(:body) && name_check.body['data'][0]['id'] )
          res = delete_tenant(name_check.body['data'][0]['id'])
        else
          #puts "name_check else"
        end

        erp_check = tenant_by_erp(name_erp)

        if( erp_check.respond_to?(:body) && erp_check.body['data'][0]['id'] )
          res = delete_tenant(erp_check.body['data'][0]['id'])
        else
         # puts "erp_check else"
        end
        res
      end

      def add_arrays_to_tenant(tenant_id, xirrus_arrays)
        post("/tenants.json/#{tenant_id}/arrays", xirrus_arrays)
      end

      def assign_arrays_to_tenant(tenant_id,array_of_array_ids)
        #body_string = array_to_body_string(array_of_array_ids)
        #HTTParty.put("#{api_path}/tenants.json/#{tenant_id}/arrays", { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }}) # RestClient Post
        body_put("/tenants.json/#{tenant_id}/arrays", array_of_array_ids )
      end

      def arrays_for_tenant(tenant_id)
        get("/tenants.json/#{tenant_id}/arrays")
      end
      def add_user_for_tenant(tenantId, user)
        post("/tenants.json/#{tenantId}/users", user)
      end

      def delete_array_for_tenant(tenant_id, array_id)
        delete("/tenants.json/#{tenant_id}/arrays/#{array_id}")
      end

      def delete_array_for_tenant_by_serial(serial)
        global_res = global_by_serial(serial)
        res = "begin delete_array_for_tenant_by_serial"
        if global_res.respond_to? :body
          array_id = global_res.body['xirrusArrayDto']['id']
          tenant_id = global_res.body['tenantId']
          res = delete_array_for_tenant(tenant_id, array_id)
        else
          res = global_res
        end
        res
      end

      def list_arrays_for_tenant(tenant_id)
        arrays_for_tenant(tenant_id)
      end

      def delete_user_for_tenant(tenant_id, user_id)
        delete("/tenants.json/#{tenant_id}/users/#{user_id}")
      end
      def delete_user_for_current_tenant(user_id)
        current_tenant = current_tenant().body
        delete("/tenants.json/#{current_tenant["id"]}/users/#{user_id}")
      end

      def new_user_for_tenant_by_name(tenant_name, user = File.read("#{XMS.fixtures_root}/json/kiladad.json").to_json )

      end

      def update_tenant(tenant_id, tenant_body)
        body_put("/tenants.json/#{tenant_id}", tenant_body)
      end

      def update_tenant2(tenant_id, tenant_body)
        put("/tenants.json/#{tenant_id}", tenant_body)
      end
      def update_user_for_tenant(tenant_id, user_id, user_body) 
       put("/tenants.json/#{tenant_id}/users/#{user_id}", user_body)
      end 

    end # ApiClient

end # XMS