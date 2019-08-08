module XMS 
   module NG 
      class ApiClient 
# GET - Get an image given its floorplan ID
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_an_image_given_its_floorplan_id(args = {}) 
 get("/resource.json/floorplan/#{args[:floorplanId]}/image", args)
end 

# GET - Get a heat image given its floorplan ID and filter parameters
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @custom args [String] :filename path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_a_heat_image_given_its_floorplan_id_and_filter_parameters(args = {}) 
 get("/resource.json/heat/#{args[:floorplanId]}/#{args[:filename]}", args)
end 

# GET - Get an image thumbnail given its floorplan ID
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_an_image_thumbnail_given_its_floorplan_id(args = {}) 
 get("/resource.json/floorplan/#{args[:floorplanId]}/thumb", args)
end 


       end 
   end 
  end