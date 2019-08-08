module XMS 
   module NG 
      class ApiClient 
# PUT - Add or Update Airwatch
#
# @param args [Hash] 
# @custom args :NONAME body AirwatchDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_or_update_airwatch(args = {}) 
 id = args['id']
 temp_path = "/thirdParty.json/airwatch"
 path = temp_path
args.keys.each do |key|
  if (key == "thirdPartyId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - Get Airwatch
#
# @return [XMS::NG::ApiClient::Response]
def get_airwatch 
 get("/thirdParty.json/airwatch")
end 

# DELETE - Delete Airwatch
#
# @return [XMS::NG::ApiClient::Response]
def delete_airwatch 
 delete("/thirdParty.json/airwatch")
end 


       end 
   end 
  end