module XMS 
   module NG 
      class ApiClient 
# GET - List Tenant Circles
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_tenant_circles(args = {}) 
 get("/tenantcircles.json/", args)
end 

# POST - Add Tenant Circle
#
# @param args [Hash] 
# @custom args :NONAME body TenantCircleDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_tenant_circle(args = {}) 
 post("/tenantcircles.json/", args)
end 

# GET - List Tenants for Circle
#
# @param args [Hash] 
# @custom args :circleId query string *required 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "erpId"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_tenants_for_circle(args = {}) 
 get("/tenantcircles.json/tenants", args)
end 

# DELETE - Delete Tenant Circle
#
# @param args [Hash] 
# @custom args :circleId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_tenant_circle(args = {}) 
 delete("/tenantcircles.json/#{args[:circleId]}", args)
end 

# PUT - Update Tenant Circle
#
# @param args [Hash] 
# @custom args :circleId path string *required 
# @custom args :NONAME body TenantCircleDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_tenant_circle(args = {}) 
 put("/tenantcircles.json/#{args[:circleId]}", args)
end 

# PUT - Assign Tenants to Circle
#
# @param args [Hash] 
# @custom args :circleId path string *required 
# @custom args :NONAME body List[string] *required 
# @return [String]
def assign_tenants_to_circle(args = {}) 
  body_put("/tenantcircles.json/tenants/#{args[:circleId]}", args[:array_of_ids])
end 


       end 
   end 
  end