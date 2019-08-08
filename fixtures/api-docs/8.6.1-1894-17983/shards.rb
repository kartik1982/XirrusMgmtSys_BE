module XMS 
   module NG 
      class ApiClient 
# PUT - Trigger Data Source cache update
#
# @return [XMS::NG::ApiClient::Response]
def trigger_data_source_cache_update 
 put("/shards.json/dataSourceCache")
end 

# GET - List all Shards
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["name", "capacity"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_all_shards(args = {}) 
 get("/shards.json/", args)
end 

# POST - Add Shard
#
# @param args [Hash] 
# @custom args :NONAME body ShardDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_shard(args = {}) 
 post("/shards.json/", args)
end 

# GET - Get Shard
#
# @param args [Hash] 
# @custom args :shardId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_shard(args = {}) 
 get("/shards.json/#{args[:shardId]}", args)
end 

# PUT - Update Shard
#
# @param args [Hash] 
# @custom args :shardId path string *required 
# @custom args :NONAME body ShardDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_shard(args = {}) 
 id = args['id']
 temp_path = "/shards.json/{shardId}"
 path = temp_path
args.keys.each do |key|
  if (key == "shardId")
    args.delete(key)
    path = temp_path.gsub("{#{key}}", id)
  end
end
  puts " PATH : #{path}"
  put(path, args)
end 

# DELETE - Delete Shard
#
# @param args [Hash] 
# @custom args :shardId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_shard(args = {}) 
 delete("/shards.json/#{args[:shardId]}", args)
end 

# PUT - Assign Suspended Tenant to Shard
#
# @param args [Hash] 
# @custom args :shardId path string *required 
# @custom args :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def assign_suspended_tenant_to_shard(args = {}) 
 put("/shards.json/#{args[:shardId]}/tenant/#{args[:tenantId]}", args)
end 


       end 
   end 
  end