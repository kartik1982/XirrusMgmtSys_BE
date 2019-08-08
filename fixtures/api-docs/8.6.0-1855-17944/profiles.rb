module XMS 
   module NG 
      class ApiClient 
# GET - List all SSIDs
#
# @return [XMS::NG::ApiClient::Response]
def list_all_ssids 
 get("/profiles.json/ssids")
end 

# GET - Get default Profile
#
# @return [XMS::NG::ApiClient::Response]
def get_default_profile 
 get("/profiles.json/default")
end 

# POST - Validator Captive Portal
#
# @param args [Hash] 
# @custom args [String] :NONAME body CaptivePortalDto *required 
# @return [XMS::NG::ApiClient::Response]
def validator_captive_portal(args = {}) 
 post("/profiles.json/captiveportal/", args)
end 

# POST - Duplicate Profile
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @return [XMS::NG::ApiClient::Response]
def duplicate_profile(args = {}) 
 post("/profiles.json/#{args[:profileId]}", args)
end 

# GET - Get Profile
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_profile(args = {}) 
 get("/profiles.json/#{args[:profileId]}", args)
end 

# PUT - Update Profile
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @custom args [String] :NONAME body ProfileDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_profile(args = {}) 
 put("/profiles.json/#{args[:profileId]}", args)
end 

# DELETE - Delete Profile
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_profile(args = {}) 
 delete("/profiles.json/#{args[:profileId]}", args)
end 

# GET - Get Profile Configuration
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_profile_configuration(args = {}) 
 get("/profiles.json/#{args[:profileId]}/configuration", args)
end 

# PUT - Create or update Profile Configuration
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @custom args [String] :NONAME body ProfileConfigurationDto *required 
# @return [XMS::NG::ApiClient::Response]
def create_or_update_profile_configuration(args = {}) 
 id = args['profileId']
 args.delete('profileId')
 put("/profiles.json/#{id}/configuration", args)
end 

# PUT - Assign default Profile
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @return [XMS::NG::ApiClient::Response]
def assign_default_profile(args = {}) 
 put("/profiles.json/#{args[:profileId]}/default", args)
end 

# PUT - Clear default Profile
#
# @return [XMS::NG::ApiClient::Response]
def clear_default_profile 
 put("/profiles.json/default/clear")
end 

# GET - List Profiles
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["name"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_profiles(args = {}) 
 get("/profiles.json/", args)
end 

# POST - Add Profile
#
# @param args [Hash] 
# @custom args [String] :NONAME body ProfileDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_profile(args = {}) 
 post("/profiles.json/", args)
end 

# GET - List Arrays assigned to Profile
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["baseMacAddress", "ipAddress", "serialNumber", "aosVersion", "activationStatus", "hostName", "location", "onlineStatus", "netmask", "gateway", "licenseKey", "licensedAosVersion", "arrayModel", "manufacturer", "baseIapMacAddress"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_arrays_assigned_to_profile(args = {}) 
 get("/profiles.json/#{args[:profileId]}/arrays", args)
end 

# PUT - Assign Arrays to Profile
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def assign_arrays_to_profile(args = {}) 
  body_put("/profiles.json/#{args[:profileId]}/arrays", args[:array_of_ids])
end 

# DELETE - Remove Arrays from Profile
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def remove_arrays_from_profile(args = {}) 
  body_delete("/profiles.json/#{args[:profileId]}/arrays", args[:array_of_ids])
end 

# GET - List Clients
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["clientMacAddress", "clientHostName", "capability", "lastSeen", "manufacturer", "deviceType", "deviceClass", "online", "ipAddress", "activeHostIp", "operatingMode", "lastArrayHostName", "location", "sessionLength", "rssi", "txConnectRate", "rxConnectRate", "band", "channel", "iap", "txthroughput", "rxthroughput", "throughput", "totalBytes", "txTotalRetries", "txTotalErrors", "txPackets", "txBytes", "rxTotalRetries", "rxTotalErrors", "rxPackets", "rxBytes", "retryPct", "errorPct", "keyMgmt", "encType", "cipher", "ssid", "vlan", "userName", "status", "onlineStatus", "guestName", "guestEmail", "guestMobile", "gapName"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_clients(args = {}) 
 get("/profiles.json/#{args[:profileId]}/clients/", args)
end 

# GET - Profile Settings
#
# @param args [Hash] 
# @custom args [String] :profileId path string *required 
# @return [XMS::NG::ApiClient::Response]
def profile_settings(args = {}) 
 get("/profiles.json/#{args[:profileId]}/settings/", args)
end 


       end 
   end 
  end