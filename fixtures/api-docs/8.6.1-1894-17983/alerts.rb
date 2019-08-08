module XMS 
   module NG 
      class ApiClient 
# GET - Search Alerts
#
# @param args [Hash] 
# @custom args :search path string *required 
# @custom args :severity query string  allowed - ["ALL", "HIGH", "MEDIUM", "LOW"]
# @custom args :state query string  allowed - ["ALL", "OPEN", "CLOSED"]
# @custom args :acknowledged query string  allowed - ["ALL", "ACKNOWLEDGED", "UNACKNOWLEDGED"]
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["severity", "state", "source", "type", "createdTime", "closedTime"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def search_alerts(args = {}) 
 get("/alerts.json/search/#{args[:search]}", args)
end 

# GET - Get Alert Summary
#
# @return [XMS::NG::ApiClient::Response]
def get_alert_summary 
 get("/alerts.json/summary")
end 

# GET - Get Alerts
#
# @param args [Hash] 
# @custom args :severity query string  allowed - ["ALL", "HIGH", "MEDIUM", "LOW"]
# @custom args :state query string  allowed - ["ALL", "OPEN", "CLOSED"]
# @custom args :acknowledged query string  allowed - ["ALL", "ACKNOWLEDGED", "UNACKNOWLEDGED"]
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["severity", "state", "source", "type", "createdTime", "closedTime"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def get_alerts(args = {}) 
 get("/alerts.json/", args)
end 

# PUT - Acknowledge Alerts
#
# @param args [Hash] 
# @custom args :NONAME body List[string] *required 
# @return [String]
def acknowledge_alerts(args = {}) 
  body_put("/alerts.json/acknowledge", args[:array_of_ids])
end 

# PUT - Unacknowledge Alerts
#
# @param args [Hash] 
# @custom args :NONAME body List[string] *required 
# @return [String]
def unacknowledge_alerts(args = {}) 
  body_put("/alerts.json/unacknowledge", args[:array_of_ids])
end 


       end 
   end 
  end