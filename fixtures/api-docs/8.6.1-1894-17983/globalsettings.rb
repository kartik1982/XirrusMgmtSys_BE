module XMS 
   module NG 
      class ApiClient 
# GET - Get 'Whats New' url
#
# @return [XMS::NG::ApiClient::Response]
def get_whats_new_url 
 get("/globalsettings.json/news/url")
end 

# PUT - Set 'Whats New' url
#
# @param args [Hash] 
# @custom args :url query string *required 
# @return [XMS::NG::ApiClient::Response]
def set_whats_new_url(args = {}) 
 put("/globalsettings.json/news/url", args)
end 

# PUT - Enable Alert Feature
#
# @return [XMS::NG::ApiClient::Response]
def enable_alert_feature 
 put("/globalsettings.json/alerts/enable")
end 

# PUT - Disable Alert Feature
#
# @return [XMS::NG::ApiClient::Response]
def disable_alert_feature 
 put("/globalsettings.json/alerts/disable")
end 

# PUT - Flag XMS system to be normal
#
# @return [XMS::NG::ApiClient::Response]
def flag_xms_system_to_be_normal 
 put("/globalsettings.json/xms/normal")
end 

# GET - Refresh Feature Cache
#
# @return [XMS::NG::ApiClient::Response]
def refresh_feature_cache 
 get("/globalsettings.json/cache/refresh")
end 


       end 
   end 
  end