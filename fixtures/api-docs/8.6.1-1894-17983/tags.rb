module XMS 
   module NG 
      class ApiClient 
# DELETE - Delete Tag
#
# @param args [Hash] 
# @custom args :tagName path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_tag(args = {}) 
 delete("/tags.json/#{args[:tagName]}", args)
end 

# PUT - Assign Tags to Arrays
#
# @param args [Hash] 
# @custom args :NONAME body List[ArrayTagListDto] *required 
# @return [XMS::NG::ApiClient::Response]
def assign_tags_to_arrays(args = {}) 
 id = args['id']
 temp_path = "/tags.json/arrays/"
 path = temp_path
args.keys.each do |key|
  if (key == "tagId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
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