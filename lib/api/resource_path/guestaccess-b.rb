module XMS 
   module NG 
      class ApiClient 
# GET - Search for a Guest
#
# @param args [Hash] 
# @custom args :portalId query string  
# @custom args :value query string *required 
# @custom args :field query string *required 
# @custom args :types query SearchTypeDto *required 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "email"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def search_for_a_guest(args = {}) 
 get("/guestaccess.json/search", args)
end 

# PUT - Extend Guest's access
#
# @param args [Hash] 
# @custom args :NONAME body List[string] *required 
# @return [String]
def extend_guests_access(args = {}) 
  body_put("/guestaccess.json/extend", args[:array_of_ids])
end 

# PUT - Assign SSIDs to Portal
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @custom args :NONAME body List[GuestSsidDto] *required 
# @return [XMS::NG::ApiClient::Response]
def assign_ssids_to_portal(args = {}) 
 id = args['id']
 temp_path = "/guestaccess.json/gap/{portalId}/ssids"
 path = temp_path
args.keys.each do |key|
  if (key == "portalId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - Get Guest Access Portal Configuration
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_guest_access_portal_configuration(args = {}) 
 get("/guestaccess.json/gap/#{args[:portalId]}/configuration", args)
end 

# PUT - Create or update Guest Access Portal Configuration
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @custom args :NONAME body GuestAccessPortalConfigurationDto *required 
# @return [XMS::NG::ApiClient::Response]
def create_or_update_guest_access_portal_configuration(args = {}) 
 id = args['id']
 temp_path = "/guestaccess.json/gap/{portalId}/configuration"
 path = temp_path
args.keys.each do |key|
  if (key == "portalId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# DELETE - Delete Ssids (For XMS-E Only)
#
# @param args [Hash] 
# @custom args :NONAME body List[string] *required 
# @return [String]
def delete_ssids_for_xms_e_only(args = {}) 
  body_delete("/guestaccess.json/gap/ssid", args[:array_of_ids])
end 

# GET - Get a Guest
#
# @param args [Hash] 
# @custom args :guestId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_a_guest(args = {}) 
 get("/guestaccess.json/#{args[:guestId]}", args)
end 

# PUT - Update Guest
#
# @param args [Hash] 
# @custom args :guestId path string *required 
# @custom args :NONAME body GuestDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_guest(args = {}) 
  id = args['id']
  temp_path = "/guestaccess.json/{guestId}"
  path = temp_path
args.keys.each do |key|
  if (key == "guestId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - List Guests
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "company", "email", "mobile", "enabled", "note", "accessActivationDate", "accessTerminationDate"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_guests(args = {}) 
 get("/guestaccess.json/", args)
end 

# DELETE - Delete Guests
#
# @param args [Hash] 
# @custom args :NONAME body List[string] *required 
# @return [String]
def delete_guests(args = {}) 
  body_delete("/guestaccess.json/", args[:array_of_ids])
end 

# GET - List All Guests
#
# @param args [Hash] 
# @custom args :portalId query string  
# @return [XMS::NG::ApiClient::Response]
def list_all_guests(args = {}) 
 get("/guestaccess.json/all", args)
end 

# GET - List all Guests (CSV)
#
# @param args [Hash] 
# @custom args :portalId query string  
# @return [XMS::NG::ApiClient::Response]
def list_all_guests_csv(args = {}) 
 get("/guestaccess.json/all/csv", args)
end 

# POST - Add Guest
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @custom args :NONAME body List[GuestDto] *required 
# @return [XMS::NG::ApiClient::Response]
#def add_guest(args = {}) 
# post("/guestaccess.json/#{args[:portalId]}/guest", args)
#end 

# GET - List Guests for Guest Access Portal
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "company", "email", "mobile", "enabled", "note", "accessActivationDate", "accessTerminationDate"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_guests_for_guest_access_portal(args = {}) 
 get("/guestaccess.json/#{args[:portalId]}/guest", args)
end 

# POST - Generate new password for Guest
#
# @param args [Hash] 
# @custom args :guestId path string *required 
# @return [XMS::NG::ApiClient::Response]
def generate_new_password_for_guest(args = {}) 
 post("/guestaccess.json/#{args[:guestId]}/newpassword", args)
end 

# PUT - Send password to user
#
# @param args [Hash] 
# @custom args :guestId path string *required 
# @custom args :password query string *required 
# @custom args :token query string *required 
# @custom args :doEmail query boolean  
# @custom args :doText query boolean  
# @return [XMS::NG::ApiClient::Response]
def send_password_to_user(args = {}) 
 put("/guestaccess.json/#{args[:guestId]}/sendpassword", args)
end 

# PUT - Toggle access
#
# @param args [Hash] 
# @custom args :NONAME body List[string] *required 
# @custom args :enable query boolean *required 
# @return [String]
def toggle_access(args = {}) 
  body_put("/guestaccess.json/access", args[:array_of_ids])
end 

# GET - Get Guest Access Portal
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_guest_access_portal(args = {}) 
 get("/guestaccess.json/gap/#{args[:portalId]}", args)
end 

# POST - Copy Guest Access Portal
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @return [XMS::NG::ApiClient::Response]
def copy_guest_access_portal(args = {}) 
 post("/guestaccess.json/gap/#{args[:portalId]}", args)
end 

# PUT - Update Guest Access Portal
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @custom args :NONAME body GuestAccessPortalDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_guest_access_portal(args = {}) 
 id = args['id']
 temp_path = "/guestaccess.json/gap/{portalId}"
 path = temp_path
args.keys.each do |key|
  if (key == "guestaccesId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# DELETE - Delete Guest Access Portal
#
# @param args [Hash] 
# @custom args :portalId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_guest_access_portal(args = {}) 
 delete("/guestaccess.json/gap/#{args[:portalId]}", args)
end 

# POST - Add Guest Access Portal
#
# @param args [Hash] 
# @custom args :NONAME body GuestAccessPortalDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_guest_access_portal(args = {}) 
 post("/guestaccess.json/gap/", args)
end 

# GET - List Guest Access Portals
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "type"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_guest_access_portals(args = {}) 
 get("/guestaccess.json/gap/", args)
end 

# PUT - Add SSIDs to Guest Access Portal (For XMS-E Only)
#
# @param args [Hash] 
# @custom args :gapId path string *required 
# @custom args :NONAME body List[string] *required 
# @return [String]
def add_ssids_to_guest_access_portal_for_xms_e_only(args = {}) 
  body_put("/guestaccess.json/gap/ssid/#{args[:gapId]}", args[:array_of_ids])
end 


       end 
   end 
  end