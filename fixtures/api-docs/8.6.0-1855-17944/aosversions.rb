module XMS 
   module NG 
      class ApiClient 
# PUT - Assign Tenant Circles to an AOS Version Box
#
# @param args [Hash] 
# @custom args [String] :aosVersionBoxId path string *required 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def assign_tenant_circles_to_an_aos_version_box(args = {}) 
  body_put("/aosversions.json/aosversionbox/circles/#{args[:aosVersionBoxId]}", args[:array_of_ids])
end 

# GET - List all TenantCircles for a Version Box
#
# @param args [Hash] 
# @custom args [String] :aosVersionBoxId path string *required 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["name"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_all_tenantcircles_for_a_version_box(args = {}) 
 get("/aosversions.json/aosversionbox/circles/#{args[:aosVersionBoxId]}", args)
end 

# DELETE - Delete AOS Version Box
#
# @param args [Hash] 
# @custom args [String] :aosVersionBoxId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_aos_version_box(args = {}) 
 delete("/aosversions.json/aosversionbox/#{args[:aosVersionBoxId]}", args)
end 

# GET - Get AOS Version Box by ID
#
# @param args [Hash] 
# @custom args [String] :aosVersionBoxId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_aos_version_box_by_id(args = {}) 
 get("/aosversions.json/aosversionbox/#{args[:aosVersionBoxId]}", args)
end 

# GET - Get AOS Version by name
#
# @param args [Hash] 
# @custom args [String] :aosVersionName path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_aos_version_by_name(args = {}) 
 get("/aosversions.json/version/#{args[:aosVersionName]}", args)
end 

# DELETE - Delete AOS Version
#
# @param args [Hash] 
# @custom args [String] :aosVersionId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_aos_version(args = {}) 
 delete("/aosversions.json/#{args[:aosVersionId]}", args)
end 

# GET - Get AOS Version
#
# @param args [Hash] 
# @custom args [String] :aosVersionId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_aos_version(args = {}) 
 get("/aosversions.json/#{args[:aosVersionId]}", args)
end 

# PUT - Update AOS Version
#
# @param args [Hash] 
# @custom args [String] :aosVersionId path string *required 
# @custom args [String] :NONAME body AosVersionInfoDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_aos_version(args = {}) 
 put("/aosversions.json/#{args[:aosVersionId]}", args)
end 

# POST - Add AOS Version Box
#
# @param args [Hash] 
# @custom args [String] :NONAME body AosVersionBoxDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_aos_version_box(args = {}) 
 post("/aosversions.json/aosversionbox", args)
end 

# GET - List all AOS Version Boxes
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["name"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_all_aos_version_boxes(args = {}) 
 get("/aosversions.json/aosversionbox", args)
end 

# GET - List active AOS Versions
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["version"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @custom args [String] :includeBeta query boolean  allowed - ["false", "true"]
# @return [XMS::NG::ApiClient::Response]
def list_active_aos_versions(args = {}) 
 get("/aosversions.json/", args)
end 

# POST - Add AOS Version
#
# @param args [Hash] 
# @custom args [String] :NONAME body AosVersionInfoDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_aos_version(args = {}) 
 post("/aosversions.json/", args)
end 

# GET - List all AOS Versions
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["version"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_all_aos_versions(args = {}) 
 get("/aosversions.json/all", args)
end 

# GET - Get AOS Version Box by name
#
# @param args [Hash] 
# @custom args [String] :aosVersionBoxName path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_aos_version_box_by_name(args = {}) 
 get("/aosversions.json/aosversionbox/name/#{args[:aosVersionBoxName]}", args)
end 


       end 
   end 
  end