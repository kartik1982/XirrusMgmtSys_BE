module XMS 
   module NG 
      class ApiClient 
# GET - import customer data
#
# @return [XMS::NG::ApiClient::Response]
def import_customer_data 
 get("/sfdc.json/customerData")
end 


       end 
   end 
  end