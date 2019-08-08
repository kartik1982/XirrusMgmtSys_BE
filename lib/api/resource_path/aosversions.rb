module XMS
  module NG
    class ApiClient

## AOS Version Object
=begin
      {
         "id": "string",
         "enterpriseStatus": {
             "active": "boolean",
             "beta": "boolean"
      },
          "releaseDate": "Date",
          "cloudStatus": {
          "active": "boolean",
          "beta": "boolean"
      },
      "upgradeUrl": "string",
      "version": "string"
      }
=end
      def add_aos_version(obj={})
        post("/aosversions.json/",obj)
      end  

      def add_aos(obj={})
      	add_aos_version(obj)
      end

      def aos_by_id(_id)
      	get("/aosversions.json/#{_id}")
      end

      def aos_by_name(_name)
      	get("/aosversions.json/version/#{_name}")
      end

      def update_aos(_id, obj)
        put("/aosversions.json/#{id}",obj)
      end

      def delete_aos(_id)
      	delete("/aosversions.json/#{_id}")
      end

      def delete_aos_by_name(_name)
        puts "delete_aos_by_name"
      	aos_res = aos_by_name(_name)
        puts aos_res
        aos_id = aos_res.body['id']
        puts aos_id
        delete_aos(aos_id)
      end
      
      def list_all_aos_versions(params={})
      	get("/aosversions.json/all",params)
      end

      def all_aos(params={})
      	list_all_aos_versions(params)
      end

      def active_aos(params={})
      	get("/aosversions.json",params)
      end


## AOS Version Box Object
=begin 

  {
  "id": "string",
  "circleCount": "long",
  "defaultVersionId": "string",
  "description": "string",
  "defaultVersionName": "string",
  "name": "string",
  "versionRestrictions": [
    {
      "id": "string",
      "model": "string",
      "maximumVersionId": "string",
      "minimumVersionName": "string",
      "minimumVersionId": "string",
      "maximumVersionName": "string"
    }
  ]
}

=end      

      def add_box(obj={})
      	post("/aosversions.json/aosversionbox",obj)
      end

      def boxes(params={})
      	get("/aosversions.json/aosversionbox",params)
      end

      def aosversionbox_by_id(_id)
        get("/aosversions.json/aosversionbox/#{_id}")
      end

      def aosversionbox_by_name(_name)
      	get("/aosversions.json/aosversionbox/name/#{_name}")
      end

      def box_by_name(_name)
      	aosversionbox_by_name(_name)
      end

      def delete_box(_id)
      	delete("/aosversions.json/aosversionbox/#{_id}")
      end

      def delete_box_by_name(_name)
      	box_res = box_by_name(_name)
      	box_id  box_res.body['id']
      	delete_box(_id)
      end

      def circles_in_box(_box_id, params = {})
      	get("/aosversions.json/aosversionbox/circles/#{_box_id}", params)
      end

      def put_circles_in_box(_box_id, list_of_circle_ids)
        body_string = array_to_body_string(list_of_circle_ids)
        HTTParty.put("#{api_path}/aosversions.json/aosversionbox/circles/#{_box_id}", { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }}) # RestClient Post
      end




    end # ApiClient
  end # NG
end # XMS