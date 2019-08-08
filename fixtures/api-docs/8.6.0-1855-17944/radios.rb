module XMS 
   module NG 
      class ApiClient 
# GET - Get Radios for Array
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_radios_for_array(args = {}) 
 get("/radios.json/#{args[:arrayId]}", args)
end 

# PUT - Update Radios for Array
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @custom args [String] :NONAME body List[RadioDto] *required 
# @return [XMS::NG::ApiClient::Response]
def update_radios_for_array(args = {}) 
 put("/radios.json/#{args[:arrayId]}", args)
end 


       end 
   end 
  end