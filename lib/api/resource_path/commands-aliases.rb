module XMS 
  module NG 
    class ApiClient 

      alias_method :commands, :get_a_page_of_cli_command_execution_history
      alias_method :execution_history, :get_a_page_of_cli_command_execution_history

      alias_method :commands_for_job, :get_a_page_of_cli_command_executions_for_jobid
      alias_method :job_commands, :get_a_page_of_cli_command_executions_for_jobid

      alias_method :readonly_commands, :execute_readonly_commands
    
      alias_method :commands_device, :get_list_of_cli_command_executions_by_jobid_and_serial_number
      alias_method :device_latest, :get_latest_jobid_for_the_device

      
    end
  end
end