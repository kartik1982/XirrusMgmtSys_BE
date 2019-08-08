module XMS 
   module NG 
      class ApiClient 
# GET - List Clients
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["clientMacAddress", "clientHostName", "capability", "lastSeen", "manufacturer", "deviceType", "deviceClass", "online", "ipAddress", "activeHostIp", "operatingMode", "lastArrayHostName", "location", "sessionLength", "rssi", "txConnectRate", "rxConnectRate", "band", "channel", "iap", "txthroughput", "rxthroughput", "throughput", "totalBytes", "txTotalRetries", "txTotalErrors", "txPackets", "txBytes", "rxTotalRetries", "rxTotalErrors", "rxPackets", "rxBytes", "retryPct", "errorPct", "keyMgmt", "encType", "cipher", "ssid", "vlan", "userName", "profileName", "status", "onlineStatus", "guestName", "guestEmail", "guestMobile", "gapName"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_clients(args = {}) 
 get("/clients.json/", args)
end 

# GET - Get Client summary
#
# @return [XMS::NG::ApiClient::Response]
def get_client_summary 
 get("/clients.json/summary")
end 

# GET - List Top Clients
#
# @param args [Hash] 
# @custom args [String] :hours query int  
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["rxBytes", "txBytes", "totalBytes"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_top_clients(args = {}) 
 get("/clients.json/stats/top", args)
end 

# GET - Get Client throughput time series data
#
# @param args [Hash] 
# @custom args [String] :hours query int *required 
# @custom args [String] :period query int *required 
# @return [XMS::NG::ApiClient::Response]
def get_client_throughput_time_series_data(args = {}) 
 get("/clients.json/stats/throughput", args)
end 

# GET - Get Clients by Devices
#
# @param args [Hash] 
# @custom args [String] :hours query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["txBytes", "rxBytes", "totalBytes"]
# @return [XMS::NG::ApiClient::Response]
def get_clients_by_devices(args = {}) 
 get("/clients.json/stats/device", args)
end 

# GET - Get Clients by Manufacturer
#
# @param args [Hash] 
# @custom args [String] :hours query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["txBytes", "rxBytes", "totalBytes"]
# @return [XMS::NG::ApiClient::Response]
def get_clients_by_manufacturer(args = {}) 
 get("/clients.json/stats/manufacturer", args)
end 

# GET - Get Applications by Category
#
# @param args [Hash] 
# @custom args [String] :hours query int *required 
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["txBytes", "rxBytes", "totalBytes", "description"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @custom args [String] :useOther query boolean  allowed - ["true", "false"]
# @return [XMS::NG::ApiClient::Response]
def get_applications_by_category(args = {}) 
 get("/clients.json/stats/category", args)
end 

# GET - Get Applications
#
# @param args [Hash] 
# @custom args [String] :hours query int *required 
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["txBytes", "rxBytes", "totalBytes", "name", "risk", "productivity"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @custom args [String] :useOther query boolean  allowed - ["true", "false"]
# @return [XMS::NG::ApiClient::Response]
def get_applications(args = {}) 
 get("/clients.json/stats/application", args)
end 

# GET - Get Client count time series data
#
# @param args [Hash] 
# @custom args [String] :hours query int *required 
# @custom args [String] :period query int *required 
# @return [XMS::NG::ApiClient::Response]
def get_client_count_time_series_data(args = {}) 
 get("/clients.json/stats/count", args)
end 

# GET - Search Client
#
# @param args [Hash] 
# @custom args [String] :search path string *required 
# @custom args [String] :profileId query string  
# @return [XMS::NG::ApiClient::Response]
def search_client(args = {}) 
 get("/clients.json/search/#{args[:search]}", args)
end 

# GET - Get all Clients (CSV)
#
# @param args [Hash] 
# @custom args [String] :profileId query string  
# @return [XMS::NG::ApiClient::Response]
def get_all_clients_csv(args = {}) 
 get("/clients.json/all/csv", args)
end 

# PUT - Deauth Clients
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def deauth_clients(args = {}) 
  body_put("/clients.json/actions/deauth", args[:array_of_ids])
end 

# PUT - Reset Clients
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def reset_clients(args = {}) 
  body_put("/clients.json/actions/reset", args[:array_of_ids])
end 

# PUT - Block Clients
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def block_clients(args = {}) 
  body_put("/clients.json/actions/block", args[:array_of_ids])
end 


       end 
   end 
  end