module XMS 
   module NG 
      class ApiClient 
# POST - insert or update user preferences
#
# @param args [Hash] 
# @custom args [String] :NONAME body AttributeDto *required 
# @return [XMS::NG::ApiClient::Response]
def insert_or_update_user_preferences(args = {}) 
 post("/attributes.json/userpreference", args)
end 

# GET - List current user preferences
#
# @return [XMS::NG::ApiClient::Response]
def list_current_user_preferences 
 get("/attributes.json/userpreference")
end 

# GET - List current user preferences by keys
#
# @param args [Hash] 
# @custom args [String] :keys query string *required 
# @return [XMS::NG::ApiClient::Response]
def list_current_user_preferences_by_keys(args = {}) 
 get("/attributes.json/userpreference/bykeys", args)
end 

# DELETE - delete user preferences by keys
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def delete_user_preferences_by_keys(args = {}) 
  body_delete("/attributes.json/userpreference/bykeys", args[:array_of_ids])
end 


       end 
   end 
  end