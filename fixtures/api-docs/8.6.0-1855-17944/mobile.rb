module XMS 
   module NG 
      class ApiClient 
# GET - List Mobile Carriers
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["country", "provider", "enabled", "custom"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_mobile_carriers(args = {}) 
 get("/mobile.json/", args)
end 

# POST - Add Mobile Carrier
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[MobileCarrierDto] *required 
# @return [XMS::NG::ApiClient::Response]
def add_mobile_carrier(args = {}) 
 post("/mobile.json/", args)
end 

# GET - Get Carriers by country
#
# @param args [Hash] 
# @custom args [String] :default query boolean  
# @custom args [String] :custom query boolean  
# @return [XMS::NG::ApiClient::Response]
def get_carriers_by_country(args = {}) 
 get("/mobile.json/countries", args)
end 

# DELETE - Delete Mobile Carrier
#
# @param args [Hash] 
# @custom args [String] :carrierId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_mobile_carrier(args = {}) 
 delete("/mobile.json/#{args[:carrierId]}", args)
end 

# PUT - Update Mobile Carrier
#
# @param args [Hash] 
# @custom args [String] :carrierId path string *required 
# @custom args [String] :NONAME body MobileCarrierDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_mobile_carrier(args = {}) 
 put("/mobile.json/#{args[:carrierId]}", args)
end 


       end 
   end 
  end