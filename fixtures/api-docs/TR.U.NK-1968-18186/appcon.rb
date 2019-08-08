module XMS 
   module NG 
      class ApiClient 
# GET - Get all Appcons
#
# @return [XMS::NG::ApiClient::Response]
def get_all_appcons 
 get("/appcon.json/apps")
end 

# GET - Get AppCon categories
#
# @return [XMS::NG::ApiClient::Response]
def get_appcon_categories 
 get("/appcon.json/categories")
end 

# GET - Get all Apps with categories
#
# @return [XMS::NG::ApiClient::Response]
def get_all_apps_with_categories 
 get("/appcon.json/")
end 

# GET - Get Apps By category
#
# @param args [Hash] 
# @custom args :category path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_apps_by_category(args = {}) 
 get("/appcon.json/apps/#{args[:category]}", args)
end 


       end 
   end 
  end