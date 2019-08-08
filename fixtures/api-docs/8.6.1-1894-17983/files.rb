module XMS 
   module NG 
      class ApiClient 
# GET - List Images
#
# @return [XMS::NG::ApiClient::Response]
def list_images 
 get("/files.json/captiveportal/images")
end 

# DELETE - Delete Images
#
# @param args [Hash] 
# @custom args :fileNames query List[string] *required 
# @return [XMS::NG::ApiClient::Response]
def delete_images(args = {}) 
 delete("/files.json/captiveportal/images", args)
end 

# POST - Upload Image File
#
# @param args [Hash] 
# @custom args :NONAME body FileParamDto *required 
# @return [XMS::NG::ApiClient::Response]
def upload_image_file(args = {}) 
 post("/files.json/captiveportal/images", args)
end 

# GET - List Floor Plans
#
# @return [XMS::NG::ApiClient::Response]
def list_floor_plans 
 get("/files.json/floorplan/images")
end 

# DELETE - Delete Floor Plan
#
# @param args [Hash] 
# @custom args :fileNames query List[string] *required 
# @return [XMS::NG::ApiClient::Response]
def delete_floor_plan(args = {}) 
 delete("/files.json/floorplan/images", args)
end 

# POST - Upload Floor Plan
#
# @param args [Hash] 
# @custom args :NONAME body FileParamDto *required 
# @return [XMS::NG::ApiClient::Response]
def upload_floor_plan(args = {}) 
 post("/files.json/floorplan/images", args)
end 


       end 
   end 
  end