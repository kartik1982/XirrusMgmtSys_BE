module XMS 
   module NG 
      class ApiClient 
# PUT - Assign Tags to Arrays
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[ArrayTagListDto] *required 
# @return [XMS::NG::ApiClient::Response]
def assign_tags_to_arrays(args = {}) 
 put("/tags.json/arrays/", args)
end 

# DELETE - Delete Tag
#
# @param args [Hash] 
# @custom args [String] :tagName path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_tag(args = {}) 
 delete("/tags.json/#{args[:tagName]}", args)
end 

# GET - Get Tags
#
# @return [XMS::NG::ApiClient::Response]
def get_tags 
 get("/tags.json/")
end 


       end 
   end 
  end