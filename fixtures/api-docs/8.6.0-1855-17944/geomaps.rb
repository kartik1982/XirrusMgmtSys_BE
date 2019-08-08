module XMS 
   module NG 
      class ApiClient 
# PUT - Set Arrays Location
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[MapArrayLocationDto] *required 
# @return [XMS::NG::ApiClient::Response]
def set_arrays_location(args = {}) 
 put("/geomaps.json/location", args)
end 

# GET - List GeoArrays
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["hostName", "onlineStatus", "clients", "rxBytes", "txBytes", "totalBytes"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @custom args [String] :top query float  
# @custom args [String] :left query float  
# @custom args [String] :bottom query float  
# @custom args [String] :right query float  
# @return [XMS::NG::ApiClient::Response]
def list_geoarrays(args = {}) 
 get("/geomaps.json/", args)
end 


       end 
   end 
  end