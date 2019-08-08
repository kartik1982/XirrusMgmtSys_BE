module API
    class ApiClient

      def tenant_arrays(tenant_id, params = {})
        get("/tenants.json/#{tenant_id}/arrays", params)
      end

      def update_tenant_array(tenant_id, array_id, params = {})
        put("/tenants.json/#{tenant_id}/arrays/#{array_id}", params)
      end

      def backoffice_array_by_serial(serial)
        get("/arrays.json/backoffice/serialnumber/#{serial}")
      end

      def array_by_serial(serial)
        get("/arrays.json/serialnumber/#{serial}")
      end

      def array_by_mac(mac)
        get("/arrays.json/macaddress/#{mac}")
      end

      def global_by_mac(mac)
        get("/arrays.json/global/macaddress/#{mac}")
      end

      def global_by_serial(serial)
        get("/arrays.json/global/serialnumber/#{serial}")
      end

      def reset_arrays(ids_array)
        post("/arrays.json/factorydefault",ids_array)
      end

      def reset_array(serial)
        array = array_by_serial(serial)
        xirrus_arrays = [ array.body["id"] ]
        reset_arrays(xirrus_arrays)
      end

      def clear_penalty(serial)
        post("/arrays.json/backoffice/penalty/#{serial}")
      end

      # gets arrays for tenant of current token
      def arrays(args={})
        get("/arrays.json",args)
      end

      def add_array(xirrus_arrays)
       post("/arrays.json/backoffice",xirrus_arrays)
       # HTTParty.post("#{api_path}/arrays.json/", { :body => xirrus_arrays.to_json, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }}) # RestClient Post
      end

      #def add_arrays(xirrus_arrays)
      #  add_array(xirrus_arrays)
      #end

    #def update_array(_array_id, xirrus_array)
    #    put("/arrays.json/#{_array_id}", xirrus_array)
    #end

      #def delete_array(id)
      #  delete("/arrays.json/#{id}")
      #end

      def delete_array_by_serial(serial)
        array_res = array_by_serial(serial)
        if array_res.respond_to?(:body)
         array_res = delete_array(arrayId: array_res.body["id"])
        else
         array_res
        end
        array_res
      end

      def array_system_info(array_id)
        get("/arrays.json/systeminfo/#{array_id}")
      end

      def get_radios(array_id)
        get("/radios.json/#{array_id}")
      end

      def radios
        get_radios(array_id)
      end

      def put_radios(array_id,args={})
        put("/radios.json/#{array_id}",args)
      end

      def tags
        get("/tags.json")
      end


      def unassign_arrays(array_of_array_ids)
        body_string = array_to_body_string(array_of_array_ids)
        HTTParty.put("#{api_path}/arrays.json/unassigned", { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }}) # RestClient Post
      end
  end
end