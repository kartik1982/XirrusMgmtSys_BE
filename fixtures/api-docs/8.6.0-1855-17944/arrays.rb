module XMS 
   module NG 
      class ApiClient 
# GET - Search Array
#
# @param args [Hash] 
# @custom args [String] :search path string *required 
# @custom args [String] :profileId query string  
# @return [XMS::NG::ApiClient::Response]
def search_array(args = {}) 
 get("/arrays.json/search/#{args[:search]}", args)
end 

# POST - Clear Array penalty
#
# @param args [Hash] 
# @custom args [String] :serialNumber path string *required 
# @return [XMS::NG::ApiClient::Response]
def clear_array_penalty(args = {}) 
 post("/arrays.json/backoffice/penalty/#{args[:serialNumber]}", args)
end 

# GET - Get Array and Tenant by MAC addess from global storage
#
# @param args [Hash] 
# @custom args [String] :macAddress path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_and_tenant_by_mac_addess_from_global_storage(args = {}) 
 get("/arrays.json/global/macaddress/#{args[:macAddress]}", args)
end 

# GET - Get Array counts
#
# @return [XMS::NG::ApiClient::Response]
def get_array_counts 
 get("/arrays.json/summary")
end 

# GET - Get Array backoffice details by serial number
#
# @param args [Hash] 
# @custom args [String] :serialNumber path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_backoffice_details_by_serial_number(args = {}) 
 get("/arrays.json/backoffice/serialnumber/#{args[:serialNumber]}", args)
end 

# GET - Get Array by serial number
#
# @param args [Hash] 
# @custom args [String] :serialNumber path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_by_serial_number(args = {}) 
 get("/arrays.json/serialnumber/#{args[:serialNumber]}", args)
end 

# GET - Get Array by MAC addess
#
# @param args [Hash] 
# @custom args [String] :macAddress path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_by_mac_addess(args = {}) 
 get("/arrays.json/macaddress/#{args[:macAddress]}", args)
end 

# GET - List Arrays
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["baseMacAddress", "actualIpAddress", "serialNumber", "activationStatus", "recentActivation", "hostName", "location", "onlineStatus", "actualNetmask", "actualGateway", "licenseKey", "licensedAosVersion", "arrayModel", "manufacturer", "baseIapMacAddress", "profileName", "clients", "rxBytes", "txBytes", "totalBytes", "penaltyType", "reportedAosVersion"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_arrays(args = {}) 
 get("/arrays.json/", args)
end 

# POST - Add Arrays
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[XirrusArrayDto] *required 
# @return [XMS::NG::ApiClient::Response]
def add_arrays(args = {}) 
 post("/arrays.json/", args)
end 

# GET - List Arrays for all Tenants
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["globalSerialNumber", "globalMacAddress", "globalArrayId", "globalActivationStatus", "penaltyType", "globalLicenseKey"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_arrays_for_all_tenants(args = {}) 
 get("/arrays.json/global", args)
end 

# GET - Get Array
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array(args = {}) 
 get("/arrays.json/#{args[:arrayId]}", args)
end 

# PUT - Update Array
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @custom args [String] :NONAME body XirrusArrayDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_array(args = {})  
  id = args['id']
  puts id
  args.delete("arrayId")
  puts args
  path = "/arrays.json/#{id}"
  puts path
  put(path, args)
end 

# DELETE - Delete Array
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_array(args = {}) 
  delete("/arrays.json/#{args[:arrayId]}", args)
end 

# GET - Get Array and Tenant by serial number from global storage
#
# @param args [Hash] 
# @custom args [String] :serialNumber path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_and_tenant_by_serial_number_from_global_storage(args = {}) 
 get("/arrays.json/global/serialnumber/#{args[:serialNumber]}", args)
end 

# GET - Get Array and Tenant by ID from global storage
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_and_tenant_by_id_from_global_storage(args = {}) 
 get("/arrays.json/global/#{args[:arrayId]}", args)
end 

# GET - List Arrays not assigned to a Profile
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["baseMacAddress", "serialNumber"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_arrays_not_assigned_to_a_profile(args = {}) 
 get("/arrays.json/unassigned", args)
end 

# PUT - Remove Arrays from any Profile
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def remove_arrays_from_any_profile(args = {}) 
  body_put("/arrays.json/unassigned", args[:array_of_ids])
end 

# GET - Get Array throughput time series data
#
# @param args [Hash] 
# @custom args [String] :hours query int *required 
# @custom args [String] :period query int *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_throughput_time_series_data(args = {}) 
 get("/arrays.json/stats/throughput", args)
end 

# GET - List Top Arrays
#
# @param args [Hash] 
# @custom args [String] :hours query int *required 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["rxBytes", "txBytes", "totalBytes"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_top_arrays(args = {}) 
 get("/arrays.json/stats/top", args)
end 

# GET - Get Array System Info
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_system_info(args = {}) 
 get("/arrays.json/systeminfo/#{args[:arrayId]}", args)
end 

# POST - Perform optimization actions on Arrays
#
# @param args [Hash] 
# @custom args [String] :NONAME body OptimizationActionDto *required 
# @return [XMS::NG::ApiClient::Response]
def perform_optimization_actions_on_arrays(args = {}) 
 post("/arrays.json/actions/optimize", args)
end 

# POST - Optimization check
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [XMS::NG::ApiClient::Response]
def optimization_check(args = {}) 
 post("/arrays.json/actions/optimize/check", args)
end 

# POST - Factory Reset Array
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string]  
# @return [XMS::NG::ApiClient::Response]
def factory_reset_array(args = {}) 
 post("/arrays.json/factorydefault", args)
end 

# POST - Reboot Array
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string]  
# @return [XMS::NG::ApiClient::Response]
def reboot_array(args = {}) 
 post("/arrays.json/reboot", args)
end 

# GET - Get all Array (CSV)
#
# @param args [Hash] 
# @custom args [String] :profileId query string  
# @return [XMS::NG::ApiClient::Response]
def get_all_array_csv(args = {}) 
 get("/arrays.json/all/csv", args)
end 

# GET - List Penalized Arrays
#
# @param args [Hash] 
# @custom args [String] :tenantId query string  
# @custom args [String] :sortBy query string  allowed - ["tenantId", "serialNumber", "penaltyType"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_penalized_arrays(args = {}) 
 get("/arrays.json/backoffice/penalty", args)
end 

# POST - Bulk clear Array penalty
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string]  
# @return [XMS::NG::ApiClient::Response]
def bulk_clear_array_penalty(args = {}) 
 post("/arrays.json/backoffice/penalty", args)
end 

# PUT - Reset Activation status
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def reset_activation_status(args = {}) 
 put("/arrays.json/#{args[:arrayId]}/activation/reset", args)
end 

# PUT - Expire Array
#
# @param args [Hash] 
# @custom args [String] :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def expire_array(args = {}) 
 put("/arrays.json/#{args[:arrayId]}/activation/expire", args)
end 


       end 
   end 
  end