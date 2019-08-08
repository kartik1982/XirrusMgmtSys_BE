module XMS 
   module NG 
      class ApiClient 
# GET - List online Clients for Tenant
#
# @param args [Hash] 
# @custom args [String] :tenantId path string *required 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["clientMacAddress", "clientHostName", "capability", "lastSeen", "manufacturer", "deviceType", "deviceClass", "online", "ipAddress", "activeHostIp", "operatingMode", "lastArrayHostName", "location", "sessionLength", "rssi", "txConnectRate", "rxConnectRate", "band", "channel", "iap", "txthroughput", "rxthroughput", "throughput", "totalBytes", "txTotalRetries", "txTotalErrors", "txPackets", "txBytes", "rxTotalRetries", "rxTotalErrors", "rxPackets", "rxBytes", "retryPct", "errorPct", "keyMgmt", "encType", "cipher", "ssid", "vlan", "userName", "profileName", "status", "onlineStatus"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_online_clients_for_tenant(args = {}) 
 get("/tenantclients.json/#{args[:tenantId]}/online", args)
end 


       end 
   end 
  end