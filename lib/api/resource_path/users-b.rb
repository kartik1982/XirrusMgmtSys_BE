module API
    class ApiClient
# GET - Get User by email for any Tenant
#
# @param args [Hash] 
# @custom args :email path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_user_by_email_for_any_tenant(args = {}) 
 get("/users.json/global/email/#{args[:email]}", args)
end 

# GET - Reset Whats New for all Users
#
# @return [XMS::NG::ApiClient::Response]
def reset_whats_new_for_all_users 
 get("/users.json/news/reset")
end 

# GET - List Users
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["email"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_users(args = {}) 
 get("/users.json/", args)
end 

# POST - Add User
#
# @param args [Hash] 
# @custom args :NONAME body UserDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_user(args = {}) 
 post("/users.json/", args)
end 

# GET - Get User
#
# @param args [Hash] 
# @custom args :userId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_user(args = {}) 
 get("/users.json/#{args[:userId]}", args)
end 

# PUT - Update User
#
# @param args [Hash] 
# @custom args :userId path string *required 
# @custom args :NONAME body UserDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_user(args = {}) 
 id = args['id']
 temp_path = "/users.json/{userId}"
 path = temp_path
args.keys.each do |key|
  if (key == "userId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# DELETE - Delete User
#
# @param args [Hash] 
# @custom args :userId path string *required 
# @return [XMS::NG::ApiClient::Response]
# def delete_user(args = {}) 
 # delete("/users.json/#{args[:userId]}", args)
# end 

# GET - Get User by email for current Tenant
#
# @param args [Hash] 
# @custom args :email path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_user_by_email_for_current_tenant(args = {}) 
 get("/users.json/email/#{args[:email]}", args)
end 

# PUT - Update current logged-in user's password
#
# @param args [Hash] 
# @custom args :NONAME body PasswordDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_current_logged_in_users_password(args = {}) 
 id = args['id']
 temp_path = "/users.json/current/password"
 path = temp_path
args.keys.each do |key|
  if (key == "userId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# GET - Get TenantUsers
#
# @return [XMS::NG::ApiClient::Response]
def get_tenantusers 
 get("/users.json/scope/")
end 

# GET - List Users for all Tenants
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["email"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_users_for_all_tenants(args = {}) 
 get("/users.json/global", args)
end 

# GET - Get current logged-in User
#
# @return [XMS::NG::ApiClient::Response]
def get_current_logged_in_user 
 get("/users.json/current")
end 

# PUT - Update current logged-in User
#
# @param args [Hash] 
# @custom args :NONAME body UserDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_current_logged_in_user(args = {}) 
 id = args['id']
 temp_path = "/users.json/current"
 path = temp_path
args.keys.each do |key|
  if (key == "userId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# PUT - Update User's password
#
# @param args [Hash] 
# @custom args :userId path string *required 
# @custom args :password path string *required 
# @return [XMS::NG::ApiClient::Response]
def update_users_password(args = {}) 
 put("/users.json/backoffice/#{args[:userId]}/password/#{args[:password]}", args)
end 

# PUT - Update User's password by e-mail
#
# @param args [Hash] 
# @custom args :email path string *required 
# @custom args :password path string *required 
# @return [XMS::NG::ApiClient::Response]
def update_users_password_by_e_mail(args = {}) 
 put("/users.json/backoffice/email/#{args[:email]}/password/#{args[:password]}", args)
end

# GET - sets all user's showWhatsNew field to true
def reset_whats_new_for_all_users() 
 get("/users.json/backoffice/news/reset")
end
   end 
  end