module API
    class ApiClient

    def self.delete_id_keys(obj)
        if obj.respond_to?(:keys)
         if obj['id']
           obj.delete("id")
         end
         if obj['ssidId']
           obj.delete("ssidId")
         end
         if obj['modificationId']
           obj.delete("modificationId")
         end
         obj.keys.each do |obj_key|
           delete_id_keys(obj[obj_key])
         end
        elsif obj.respond_to?(:each)
          obj.each {|prop|
          
             delete_id_keys(prop)     
          }
        else
          ## not an hash or enumerable object, most likely a string or null
        end
        obj
    end

      def profiles(args={})
        get("/profiles.json",args)
      end

      def get_profiles(args={})
        profiles(args)
      end

      def default_profile
        get("/profiles.json/default")
      end

      def create_profile(args)
        post("/profiles.json", args)
      end

      def add_profile(args)
        post("/profiles.json", args)
      end

      def delete_profile(_profile_id)
        delete("/profiles.json/#{_profile_id}")
      end

      def profile_configuration(_profile_id)
        get("/profiles.json/#{_profile_id}/configuration")
      end

      def update_profile_configuration(_profile_id, _config)
        put("/profiles.json/#{_profile_id}/configuration",_config)
      end

#      def assign_arrays_to_profile(_profile_id, array_of_array_ids)
#        body_put( "/profiles.json/#{_profile_id}/arrays", array_of_array_ids )
#        #body_string = array_to_body_string(array_of_array_ids)
#        #HTTParty.put("#{api_path}/profiles.json/#{_profile_id}/arrays", { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }}) # RestClient Post
#      end

      def delete_id_keys(obj)
 if obj.respond_to?(:keys)
  if obj['id']
    obj.delete("id")
  end
  if obj['ssidId']
    obj.delete("ssidId")
  end
  if obj['modificationId']
    obj.delete("modificationId")
  end
  obj.keys.each do |obj_key|
    delete_id_keys(obj[obj_key])
  end
 elsif obj.respond_to?(:each)
   obj.each {|prop|   
      delete_id_keys(prop)     
   }
 else
   ## not an hash or enumerable object, most likely a string or null
 end
end

  end
end