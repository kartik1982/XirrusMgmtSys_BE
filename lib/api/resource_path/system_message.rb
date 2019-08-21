module API
  class ApiClient
    def add_system_message(args = {})
      post("/systemmessage.json/backoffice", args)
    end

    def get_expiration_messages_for_tenant(tenantId, args = {})
      get("/systemmessage.json/backoffice/expiration/#{tenantId}", args)
    end

    def get_system_message(msgId, args = {})
      get("/systemmessage.json/#{msgId}", args)
    end

    def list_system_messages(args = {})
      get("/systemmessage.json/backoffice", args)
    end

    def list_system_messages_for_current_tenant(args = {})
      get("/systemmessage.json/", args)
    end

    def reset_expiration_messages_for_tenant(tenantId, args = {})
      put("/systemmessage.json/backoffice/expiration/reset/#{tenantId}", args)
    end

    def update_system_message(msgId, args = {})
      put("/systemmessage.json/backoffice/#{msgId}", args)
    end

    def delete_system_message(msgId)
      delete("/systemmessage.json/backoffice/#{msgId}")
    end

  end
end