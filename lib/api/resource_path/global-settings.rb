module XMS 
    module NG 
       class ApiClient

# GET - get the news url and content
def get_whats_new_url_and_message() 
  get("/globalsettings.json/news")
end



       end
    end
end 