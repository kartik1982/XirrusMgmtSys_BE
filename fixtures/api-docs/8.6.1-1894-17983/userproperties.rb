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
# @custom args :NONAME body UserDashboardDto *required 
# @return [XMS::NG::ApiClient::Response]
def save_dashboards(args = {}) 
 id = args['id']
 temp_path = "/userproperties.json/dashboard/"
 path = temp_path
args.keys.each do |key|
  if (key == "userpropertieId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - Get Grid by name
#
# @param args [Hash] 
# @custom args :gridName path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_grid_by_name(args = {}) 
 get("/userproperties.json/grid/#{args[:gridName]}", args)
end 

# PUT - Save Grid
#
# @param args [Hash] 
# @custom args :gridName path string *required 
# @custom args :NONAME body UserGridDto *required 
# @return [XMS::NG::ApiClient::Response]
def save_grid(args = {}) 
 id = args['id']
 temp_path = "/userproperties.json/grid/{gridName}"
 path = temp_path
args.keys.each do |key|
  if (key == "userpropertieId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
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
# @custom args :NONAME body UserPreferencesDto *required 
# @return [XMS::NG::ApiClient::Response]
def save_user_preferences(args = {}) 
 id = args['id']
 temp_path = "/userproperties.json/preferences/"
 path = temp_path
args.keys.each do |key|
  if (key == "userpropertieId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - Get Floorplan settings for current User
#
# @param args [Hash] 
# @custom args :floorplanId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_floorplan_settings_for_current_user(args = {}) 
 get("/userproperties.json/floorplan/#{args[:floorplanId]}", args)
end 

# PUT - Save Floorplan settings
#
# @param args [Hash] 
# @custom args :floorplanId path string *required 
# @custom args :NONAME body FloorplanPreferencesDto *required 
# @return [XMS::NG::ApiClient::Response]
def save_floorplan_settings(args = {}) 
 id = args['id']
 temp_path = "/userproperties.json/floorplan/{floorplanId}"
 path = temp_path
args.keys.each do |key|
  if (key == "userpropertieId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 


       end 
   end 
  end