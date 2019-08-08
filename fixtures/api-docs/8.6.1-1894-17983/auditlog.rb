module XMS 
   module NG 
      class ApiClient 
# GET - List Audit Logs for Date Range
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["startTime"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_audit_logs_for_date_range(args = {}) 
 get("/auditlog.json/", args)
end 

# GET - List global Audit Logs for Date Range
#
# @param args [Hash] 
# @custom args :start query int  
# @custom args :count query int  
# @custom args :sortBy query string  allowed - ["startTime"]
# @custom args :sortOrder query string  allowed - ["asc", "desc"]
# @return [XMS::NG::ApiClient::Response]
def list_global_audit_logs_for_date_range(args = {}) 
 get("/auditlog.json/global", args)
end 


       end 
   end 
  end