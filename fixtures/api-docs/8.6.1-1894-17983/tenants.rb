module XMS 
   module NG 
      class ApiClient 
# PUT - Resume Suspended Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def resume_suspended_tenant(args = {}) 
 put("/tenants.json/resume/#{args[:tenantId]}", args)
end 

# GET - Get Tenant by Name
#
# @param args [Hash] 
# @custom args :tenantName path string *required 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "erpId"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def get_tenant_by_name(args = {}) 
 get("/tenants.json/name/#{args[:tenantName]}", args)
end 

# PUT - Update Tenant Maintenance Window
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :NONAME body TenantMaintenanceWindowDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_tenant_maintenance_window(args = {}) 
 id = args['id']
 temp_path = "/tenants.json/maintenance/{tenantId}"
 path = temp_path
args.keys.each do |key|
  if (key == "tenantId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - Get Tenant Maintenance Window
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_tenant_maintenance_window(args = {}) 
 get("/tenants.json/maintenance/#{args[:tenantId]}", args)
end 

# GET - Search Tenant
#
# @param args [Hash] 
# @custom args :search query string  
# @return [XMS::NG::ApiClient::Response]
def search_tenant(args = {}) 
 get("/tenants.json/search", args)
end 

# PUT - Suspend Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def suspend_tenant(args = {}) 
 put("/tenants.json/suspend/#{args[:tenantId]}", args)
end 

# GET - Get Array counts for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_array_counts_for_tenant(args = {}) 
 get("/tenants.json/backoffice/arrays/summary/#{args[:tenantId]}", args)
end 

# GET - List Tenants
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "erpId"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_tenants(args = {}) 
 get("/tenants.json/", args)
end 

# POST - Add Tenant
#
# @param args [Hash] 
# @custom args :NONAME body TenantDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_tenant(args = {}) 
 post("/tenants.json/", args)
end 

# GET - List Tenants For Circles
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "erpId"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_tenants_for_circles(args = {}) 
 get("/tenants.json/circles", args)
end 

# GET - Get Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_tenant(args = {}) 
 get("/tenants.json/#{args[:tenantId]}", args)
end 

# PUT - Update Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :NONAME body TenantDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_tenant(args = {}) 
 id = args['id']
 temp_path = "/tenants.json/{tenantId}"
 path = temp_path
args.keys.each do |key|
  if (key == "tenantId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# DELETE - Delete Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_tenant(args = {}) 
 delete("/tenants.json/#{args[:tenantId]}", args)
end 

# GET - Get Tenant by ERP-ID
#
# @param args [Hash] 
# @custom args :erpId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_tenant_by_erp_id(args = {}) 
 get("/tenants.json/erp-id/#{args[:erpId]}", args)
end 

# GET - Get current Tenant
#
# @return [XMS::NG::ApiClient::Response]
def get_current_tenant 
 get("/tenants.json/current")
end 

# POST - Add Tenant to specified Shard
#
# @param args [Hash] 
# @custom args :shardId path string *required 
# @custom args :NONAME body TenantDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_tenant_to_specified_shard(args = {}) 
 post("/tenants.json/shard/#{args[:shardId]}", args)
end 

# GET - List Arrays for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["baseMacAddress", "actualIpAddress", "serialNumber", "aosVersion", "activationStatus", "recentActivation", "hostName", "location", "onlineStatus", "actualNetmask", "actualGateway", "licenseKey", "licensedAosVersion", "arrayModel", "manufacturer", "baseIapMacAddress", "profileName", "clients", "rxBytes", "txBytes", "totalBytes"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_arrays_for_tenant(args = {}) 
 get("/tenants.json/#{args[:tenantId]}/arrays", args)
end 

# POST - Add Arrays to Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :NONAME body List[XirrusArrayDto] *required 
# @return [XMS::NG::ApiClient::Response]
def add_arrays_to_tenant(args = {}) 
 post("/tenants.json/#{args[:tenantId]}/arrays", args)
end 

# PUT - Assign Arrays to Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :NONAME body List[string] *required 
# @return [String]
def assign_arrays_to_tenant(args = {}) 
  body_put("/tenants.json/#{args[:tenantId]}/arrays", args[:array_of_ids])
end 

# PUT - Update Array for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :arrayId path string *required 
# @custom args :NONAME body XirrusArrayDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_array_for_tenant(args = {}) 
 id = args['id']
 temp_path = "/tenants.json/{tenantId}/arrays/{arrayId}"
 path = temp_path
args.keys.each do |key|
  if (key == "tenantId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# DELETE - Delete Array for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :arrayId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_array_for_tenant(args = {}) 
 delete("/tenants.json/#{args[:tenantId]}/arrays/#{args[:arrayId]}", args)
end 

# GET - List Users for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["email"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_users_for_tenant(args = {}) 
 get("/tenants.json/#{args[:tenantId]}/users", args)
end 

# POST - Add User for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :NONAME body UserDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_user_for_tenant(args = {}) 
 post("/tenants.json/#{args[:tenantId]}/users", args)
end 

# GET - Get User for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :userId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_user_for_tenant(args = {}) 
 get("/tenants.json/#{args[:tenantId]}/users/#{args[:userId]}", args)
end 

# PUT - Update User for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :userId path string *required 
# @custom args :NONAME body UserDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_user_for_tenant(args = {}) 
 id = args['id']
 temp_path = "/tenants.json/{tenantId}/users/{userId}"
 path = temp_path
args.keys.each do |key|
  if (key == "tenantId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# DELETE - Delete User for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :userId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_user_for_tenant(args = {}) 
 delete("/tenants.json/#{args[:tenantId]}/users/#{args[:userId]}", args)
end 

# GET - Get User for Tenant by email
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :email path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_user_for_tenant_by_email(args = {}) 
 get("/tenants.json/#{args[:tenantId]}/users/email/#{args[:email]}", args)
end 

# GET - List Audit Logs for Date Range for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["startTime"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_audit_logs_for_date_range_for_tenant(args = {}) 
 get("/tenants.json/#{args[:tenantId]}/auditlog", args)
end 

# GET - Get Current Tenant Maintenance Window
#
# @return [XMS::NG::ApiClient::Response]
def get_current_tenant_maintenance_window 
 get("/tenants.json/maintenance")
end 

# PUT - Update Current Tenant Maintenance Window
#
# @param args [Hash] 
# @custom args :NONAME body TenantMaintenanceWindowDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_current_tenant_maintenance_window(args = {}) 
 id = args['id']
 temp_path = "/tenants.json/maintenance"
 path = temp_path
args.keys.each do |key|
  if (key == "tenantId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - List backoffice information for Arrays for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["baseMacAddress", "aosVersion", "activationStatus"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_backoffice_information_for_arrays_for_tenant(args = {}) 
 get("/tenants.json/backoffice/arrays/#{args[:tenantId]}", args)
end 

# GET - Get Client summary for Tenant
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_client_summary_for_tenant(args = {}) 
 get("/tenants.json/backoffice/clients/summary/#{args[:tenantId]}", args)
end 

# PUT - Set Tenant Scope
#
# @param args [Hash] 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def set_tenant_scope(args = {}) 
 put("/tenants.json/scope/#{args[:tenantId]}", args)
end 

# PUT - Reset Tenant Scope to default
#
# @return [XMS::NG::ApiClient::Response]
def reset_tenant_scope_to_default 
 put("/tenants.json/scope/clear")
end 


       end 
   end 
  end