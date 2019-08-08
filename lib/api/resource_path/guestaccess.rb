module XMS
  module NG
    class ApiClient

      def gaps(args = {})
        get("/guestaccess.json/gap/",args)
      end

      def create_gap(args)
        post("/guestaccess.json/gap/", args)
      end

      def add_gap(args)
        post("/guestaccess.json/gap/", args)
      end

      def delete_gap(_id)
        delete("/guestaccess.json/gap/#{_id}")
      end

      def delete_gap_by_name(gap_name)
        all_gaps = gaps(count: 1000).body['data']
        gap_to_delete = all_gaps.select{|gapObj| gapObj['name'] == gap_name}.first
        delete_gap(gap_to_delete['id'])
      end

      def add_guest(gap_id, array_of_guest_hashes)
        post("/guestaccess.json/#{gap_id}/guest",array_of_guest_hashes)
      end

      def guests(_gap_id,args={})
        get("/guestaccess.json/#{_gap_id}/guest", args)
      end

      def delete_guests(guest_ids)
        
        if guest_ids.respond_to?("each")
         body_string = "["
         guest_ids.each_with_index{|id,index|
          unless index == 0
           body_string += " ,"
          end
          body_string += "\"#{id}\""
         }
         body_string += "]"
        
         response_json_string = HTTParty.delete("#{api_path}/guestaccess.json/", { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }}) # RestClient Post
        else
         nil
        end
      end # delete guests

      def get_guest(args ={})
        get("/guestaccess.json/#{args[:guestId]}")
      end

      def gap_by_id(_gap_id)
        get("/guestaccess.json/gap/#{_gap_id}")
      end

      def update_gap(_gap_id, gap_obj)
        put("/guestaccess.json/gap/#{_gap_id}", gap_obj)
      end

      def gap_configuration(_gap_id)
        get("/guestaccess.json/gap/#{_gap_id}/configuration")
      end

      def update_gap_configuration(_gap_id,_config)
        put("/guestaccess.json/gap/#{_gap_id}/configuration", _config)
      end

      def extend_guests(args={})
        body_put("/guestaccess.json/extend",args[:array_of_ids])
      end



    end # APICLien
  end
end