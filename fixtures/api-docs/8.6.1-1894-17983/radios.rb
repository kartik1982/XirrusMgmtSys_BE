module XMS 
   module NG 
      class ApiClient 
# GET - Get Radios for Array
#
# @param args [Hash] 
# @custom args :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_radios_for_array(args = {}) 
 get("/radios.json/#{args[:arrayId]}", args)
end 

# PUT - Update Radios for Array
#
# @param args [Hash] 
# @custom args :arrayId path string *required 
# @custom args :NONAME body List[RadioDto] *required 
# @return [XMS::NG::ApiClient::Response]
def update_radios_for_array(args = {}) 
 id = args['id']
 temp_path = "/radios.json/{arrayId}"
 path = temp_path
args.keys.each do |key|
  if (key == "radioId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 


       end 
   end 
  end