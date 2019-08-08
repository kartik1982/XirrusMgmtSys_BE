module XMS 
  module NG 
    class ApiClient 
      # GET - get a page of Cli command executions for jobId
      #
      # @param args [Hash] 
      # @custom args :jobId query string  
      # @custom args :start query int  
      # @custom args :count query int  
      # @custom args :sortBy query string  allowed - ["serialNumber", "submittedTime", "finishedTime"]
      # @custom args :sortOrder query string  allowed - ["asc", "desc"]
      # @return [XMS::NG::ApiClient::Response]
      def get_a_page_of_cli_command_executions_for_jobid(args = {}) 
       get("/commands.json/job", args)
      end 
      
      # GET - get latest jobid for the device
      #
      # @param args [Hash] 
      # @custom args :serialNumber query string  
      # @return [XMS::NG::ApiClient::Response]
      def get_latest_jobid_for_the_device(args = {}) 
       get("/commands.json/device/latest", args)
      end 

      # GET - get a page of Cli command execution history
      #
      # @param args [Hash] 
      # @custom args :serialNumber query string  
      # @custom args :start query int  
      # @custom args :count query int  
      # @custom args :sortBy query string  allowed - ["serialNumber", "submittedTime", "finishedTime"]
      # @custom args :sortOrder query string  allowed - ["asc", "desc"]
      # @return [XMS::NG::ApiClient::Response]
      def get_a_page_of_cli_command_execution_history(args = {}) 
       get("/commands.json/", args)
      end 
      
      # POST - execute commands
      #
      # @param args [Hash] 
      # @custom args :NONAME body CliCommandDto *required 
      # @return [XMS::NG::ApiClient::Response]
      def execute_commands(args = {}) 
       post("/commands.json/", args)
      end 

      # POST - execute readonly commands
      #
      # @param args [Hash] 
      # @custom args :NONAME body CliCommandDto *required 
      # @return [XMS::NG::ApiClient::Response]
      def execute_readonly_commands(args = {}) 
       post("/commands.json/readonly", args)
      end 
      
      # GET - get list of Cli command executions by jobId and serial number
      #
      # @param args [Hash] 
      # @custom args :jobId query string  
      # @custom args :serialNumber query string  
      # @return [XMS::NG::ApiClient::Response]
      def get_list_of_cli_command_executions_by_jobid_and_serial_number(args = {}) 
       get("/commands.json/device", args)
      end 


    end 
  end 
end