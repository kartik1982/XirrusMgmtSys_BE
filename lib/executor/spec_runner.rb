require 'tempfile'
$:.unshift File.dirname(__FILE__)
require 'report_status_formatter'

module EXECUTOR
  def self.gem_root
    File.expand_path File.dirname(__FILE__).gsub("/lib/executor","")
  end

  def self.spec_root
    "#{self.gem_root}/spec"
  end
  def self.fixtures_root
    "#{self.gem_root}/fixtures"
  end
  def self.run_a_spec(spec)
    command=["#{self.spec_root}/#{spec}", "--format", "documentation"]
    run_spec(command)
  end # run_a_spec

  def self.run_spec(command)
    RSpec::Core::Runner.run(command)
  end

  def self.run_specs(specs, args={})
    $test_count=0
    $pass_count =0
    $fail_count=0
    $pending_count=0
    project_id = args[:project_id] || gem_root.split('/').last
    testcycle_id = args[:testcycle_id]
    release_id = args[:release_id] || "0.0.0"
    build_id=  args[:build_id] || "0000-0000"
    env= args[:env] || "test03"
    #will try to get from argument where job get trigger
    if testcycle_id == "Development"
     env == "test03"
    elsif testcycle_id =="Regression"
      env = "test01"
    end
    username = args[:username] || DEFAULT_USER
    password = args[:password] || DEFAULT_PASSWORD
    browser_name = args[:browser_name] || BROWSER_NAME
    download = args[:download] ||  Dir.home+"/Downloads" #DEFAULT_DOWNLOAD
    rspec_out = args[:rspec_out] || Dir.home+"/reports/" #RSPEC_OUT
    remote_srvr = args[:remote_srvr]
    skip_api = args[:skip_api] || false
    array = args[:array]
    array_serial= args[:array_serial]
    telnet= args[:telnet]
    self.spec_helper({
      env: env,
      username: username,
      password: password,
      project_id: project_id,
      release_id: release_id,
      testcycle_id: testcycle_id,
      download: download,
      array: array,
      array_serial: array_serial,
      telnet: telnet
      
    })

    specs.each do|spec|
      start_time= Time.now #.strftime("%Y-%m-%d %H:%M:%S")
      testsuite_id = spec.split('/').first
      testcase_id = spec.split('/').last.gsub(".rb","")
      if spec.split('/').count > 2
        child_section = spec.split('/')[1]
      else
        child_section=nil
      end
      
      date= Time.now.strftime('%m/%d/%Y')
      time= Time.now.strftime('%H-%M')
      date_path = date.gsub('/', '-')
      time_path = time.gsub('/', '-')
      #Rspec.Config
      RSpec.configuration.spec_settings[:date_path] = date_path
      RSpec.configuration.spec_settings[:time_path] = time_path

      save_folder = "#{rspec_out}/"
      section= spec.gsub('_spec.rb', '').gsub('.rb', '')
      out_file_base = "#{save_folder}#{release_id}/#{testcycle_id}/#{project_id}/#{section}" #{date_path}/
      #      out_file_base << "_#{browser_name}"
      out_path = args[:out_path] || "#{out_file_base}.html"
      #Rspec.config
      RSpec.configuration.spec_settings[:log_file] = "#{out_file_base}.txt"
      RSpec.configuration.spec_settings[:out_path] = out_path.gsub('.html','')
      RSpec.configuration.spec_settings[:out_link] = "http://"+remote_srvr+out_path.gsub("#{rspec_out}",'')
      command = ["#{self.spec_root}/#{spec}",  "--format", "documentation", "--format","html", "--out",out_path ]
      #Execute spec
      run_spec(command)
      
      ###############################################################################################################
      #post result into server using APIs
      token = EXECUTOR.get_token_by_email_password('kartik.aiyar@riverbed.com','Kartik@123')
      #old
      # report_params={
       # release_id: EXECUTOR.get_id_by_title('releases', release_id, token),
       # testcycle_id: EXECUTOR.get_id_by_title('testcycles', testcycle_id, token),
       # project_id: EXECUTOR.get_id_by_title('projects', project_id, token),
       # build: $build_id,
       # testsuite_id: EXECUTOR.get_id_by_title('testsuites', testsuite_id, token),
       # testcase_id: EXECUTOR.get_id_by_title('testcases', testcase_id, token),
       # pass: $pass_count,
       # fail: $fail_count,
       # pending: $pending_count,
       # log_path: "http://"+remote_srvr+out_path.gsub("#{rspec_out}",''),
       # start_at: start_time,
       # end_at: Time.now #.strftime("%Y-%m-%d %H:%M:%S")
      # }
      #new
      report_params={
       release_name: release_id,
       testcycle_name: testcycle_id,
       project_name: project_id,
       build: $build_id,
       testsuite_name: testsuite_id,
       testcase_name: testcase_id,
       testuser: username,
       testpassword: password,
       testpath: spec,
       pass: $pass_count,
       fail: $fail_count,
       pending: $pending_count,
       log_path: "http://"+remote_srvr+out_path.gsub("#{rspec_out}",''),
       start_at: start_time,
       end_at: Time.now, #.strftime("%Y-%m-%d %H:%M:%S")
       duration: Time.now-start_time,
       browser: browser_name,
       array_serial: array_serial || "none",
       os: "any"
      }
        puts "EXECUTION PARAMETERS:- #{report_params}"
        RestClient.post "http://10.100.185.250:3000/api/v1/reports", report_params.to_json, {Authorization: "Bearer #{token}", content_type: :json, accept: :json}
      ###############################################################################################################      
      #move all log files to remote location
      if child_section
        local_path="#{rspec_out}#{release_id}/#{testcycle_id}/#{project_id}/#{testsuite_id}/#{child_section}"
        remote_path="./Results/#{release_id}/#{testcycle_id}/#{project_id}/#{testsuite_id}/#{child_section}"
      else
        local_path="#{rspec_out}#{release_id}/#{testcycle_id}/#{project_id}/#{testsuite_id}"
        remote_path="./Results/#{release_id}/#{testcycle_id}/#{project_id}/#{testsuite_id}"
      end
      EXECUTOR.move_log_file_to_remote_server(remote_srvr,local_path, remote_path, testcase_id )
      ###############################################################################################################
    end #each spec
  end #Run_Specs 
end #module EXECUTOR