module XMS 
   module NG 
      class ApiClient 
# GET - Get Dashboards for current User
#
# @return [XMS::NG::ApiClient::Response]
def get_dashboards_for_current_user 
 get("/userproperties.json/dashboard/")
end 

# PUT - Save Dashboards
#
# @param args [Hash] 
# @custom args [String] :NONAME body UserDashboardDto *required 
# @return [XMS::NG::ApiClient::Response]
def save_dashboards(args = {}) 
 put("/userproperties.json/dashboard/", args)
end 

# GET - Get Grid by name
#
# @param args [Hash] 
# @custom args [String] :gridName path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_grid_by_name(args = {}) 
 get("/userproperties.json/grid/#{args[:gridName]}", args)
end 

# PUT - Save Grid
#
# @param args [Hash] 
# @custom args [String] :gridName path string *required 
# @custom args [String] :NONAME body UserGridDto *required 
# @return [XMS::NG::ApiClient::Response]
def save_grid(args = {}) 
 put("/userproperties.json/grid/#{args[:gridName]}", args)
end 

# GET - Get current User's Preferences
#
# @return [XMS::NG::ApiClient::Response]
def get_current_users_preferences 
 get("/userproperties.json/preferences/")
end 

# PUT - Save User Preferences
#
# @param args [Hash] 
# @custom args [String] :NONAME body UserPreferencesDto *required 
# @return [XMS::NG::ApiClient::Response]
def save_user_preferences(args = {}) 
 put("/userproperties.json/preferences/", args)
end 

# GET - Get Floorplan settings for current User
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_floorplan_settings_for_current_user(args = {}) 
 get("/userproperties.json/floorplan/#{args[:floorplanId]}", args)
end 

# PUT - Save Floorplan settings
#
# @param args [Hash] 
# @custom args [String] :floorplanId path string *required 
# @custom args [String] :NONAME body FloorplanPreferencesDto *required 
# @return [XMS::NG::ApiClient::Response]
def save_floorplan_settings(args = {}) 
 put("/userproperties.json/floorplan/#{args[:floorplanId]}", args)
end 


       end 
   end 
  end