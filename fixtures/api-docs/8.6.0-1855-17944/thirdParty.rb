module XMS 
   module NG 
      class ApiClient 
# PUT - Add or Update Airwatch
#
# @param args [Hash] 
# @custom args [String] :NONAME body AirwatchDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_or_update_airwatch(args = {}) 
 put("/thirdParty.json/airwatch", args)
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