module XMS 
   module NG 
      class ApiClient 
# GET - List Reports Templates
#
# @param args [Hash] 
# @custom args [String] :start query int  
# @custom args [String] :count query int  
# @custom args [String] :sortBy query string  allowed - ["name"]
# @custom args [String] :sortOrder query string  allowed - ["asc", "desc"]
# @custom args [String] :filterFavorites query boolean  
# @return [XMS::NG::ApiClient::Response]
def list_reports_templates(args = {}) 
 get("/reports.json/template", args)
end 

# POST - Add Report Template
#
# @param args [Hash] 
# @custom args [String] :NONAME body ReportTemplateDto *required 
# @return [XMS::NG::ApiClient::Response]
def add_report_template(args = {}) 
 post("/reports.json/template", args)
end 

# DELETE - Delete Report Template
#
# @param args [Hash] 
# @custom args [String] :NONAME body List[string] *required 
# @return [String]
def delete_report_template(args = {}) 
  body_delete("/reports.json/template", args[:array_of_ids])
end 

# GET - Get Report Template
#
# @param args [Hash] 
# @custom args [String] :templateId path string *required 
# @return [XMS::NG::ApiClient::Response]
def get_report_template(args = {}) 
 get("/reports.json/template/#{args[:templateId]}", args)
end 

# PUT - Update Report Template
#
# @param args [Hash] 
# @custom args [String] :templateId path string *required 
# @custom args [String] :NONAME body ReportTemplateDto *required 
# @return [XMS::NG::ApiClient::Response]
def update_report_template(args = {}) 
 put("/reports.json/template/#{args[:templateId]}", args)
end 


       end 
   end 
  end