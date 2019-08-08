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
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["name", "capacity"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_all_shards(args = {}) 
 get("/shards.json/", args)
end 

# POST - Add Shard
#
# @param args [Hash] 
# @custom args [String] :NONAME body ShardDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_shard(args = {}) 
 post("/shards.json/", args)
end 

# GET - Get Shard
#
# @param args [Hash] 
# @custom args [String] :shardId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_shard(args = {}) 
 get("/shards.json/#{args[:shardId]}", args)
end 

# PUT - Update Shard
#
# @param args [Hash] 
# @custom args [String] :shardId path string *required 
# @custom args [String] :NONAME body ShardDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_shard(args = {}) 
 put("/shards.json/#{args[:shardId]}", args)
end 

# DELETE - Delete Shard
#
# @param args [Hash] 
# @custom args [String] :shardId path string *required 
# @return [XMS::NG::ApiClient::Response]
def delete_shard(args = {}) 
 delete("/shards.json/#{args[:shardId]}", args)
end 

# PUT - Assign Suspended Tenant to Shard
#
# @param args [Hash] 
# @custom args [String] :shardId path string *required 
# @custom args [String] :tenantId path string *required 
# @return [XMS::NG::ApiClient::Response]
def assign_suspended_tenant_to_shard(args = {}) 
 put("/shards.json/#{args[:shardId]}/tenant/#{args[:tenantId]}", args)
end 


       end 
   end 
  end