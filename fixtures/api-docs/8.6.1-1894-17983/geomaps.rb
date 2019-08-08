module XMS 
   module NG 
      class ApiClient 
# PUT - Set Arrays Location
#
# @param args [Hash] 
# @custom args :NONAME body List[MapArrayLocationDto] *required 
# @return [XMS::NG::ApiClient::Response]
def set_arrays_location(args = {}) 
 id = args['id']
 temp_path = "/geomaps.json/location"
 path = temp_path
args.keys.each do |key|
  if (key == "geomapId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - List GeoArrays
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["hostName", "onlineStatus", "clients", "rxBytes", "txBytes", "totalBytes"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @custom args :top query float  
# @custom args :left query float  
# @custom args :bottom query float  
# @custom args :right query float  
# @return [XMS::NG::ApiClient::Response]
def list_geoarrays(args = {}) 
 get("/geomaps.json/", args)
end 


       end 
   end 
  end