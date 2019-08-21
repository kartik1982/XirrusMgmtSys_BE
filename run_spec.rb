require_relative './lib/xirrus-auto.rb'

require 'logger'

options = {}
options[:env] = "test03"
options[:serial] = nil
options[:spec] = nil 
options[:headless] = true
options[:skip_api] = false
options[:ui] = true
options[:telnet] = true
options[:remote_report]= false
    
opt_parser = OptionParser.new do |opts|
  opts.on('-e', '--env ENV') do |obj|
    options[:env] = obj
  end
  opts.on("-u","--username USERNAME","please provide the User") do |obj|
    options[:username] = obj
  end
  opts.on("-p","--password PASSWORD","please provide the password for the user") do |obj|
    options[:password] = obj
  end
  opts.on("-sp","--spec SPEC","please provide the spec to run") do |obj|
    options[:spec] = obj
  end
  opts.on("-b","--browser_name BROWSER NAME","Please Provide a Browser Name (chrome or firefox") do |obj|
    options[:browser_name] = obj
  end
  opts.on("-skip_api","--skip_api SKIP-API","Skip API Tests?") do |obj|
    options[:skip_api] = (obj == true || obj == "true")
  end
  opts.on("-project_id","--project PROJECT","Please provide project name") do |obj|
    options[:project_id] = obj
  end
  opts.on("-testcycle_id","--testcycle_id TEST CYCLE","Please provide Test cycle Name") do |obj|
    options[:testcycle_id] = obj
  end
  opts.on("-release_id","--release_id RELEASE ID","Please provide Release name") do |obj|
    options[:release_id] = obj
  end
  opts.on("-build_id","--build_id BUILD NUMBER","Please provide build Number") do |obj|
    options[:build_id] = obj
  end
  opts.on("-result_srvr","--result_srvr RESULT SERVER","Please provide REsult web server name or IP address") do |obj|
    options[:result_srvr] = obj
  end
  opts.on("-remote_report","--remote_report REMOTE UPLOAD REPORTS","Please provide remote_report option true or false") do |obj|
    options[:remote_report] = obj
  end
  opts.on("-rspec_out","--rspec_out RSPEC OUTPUT","Please provide rspec output folder path") do |obj|
    options[:rspec_out] = obj
  end
  opts.on("-se","--serial SERIAL","Please Provide an Array Serial") do |serial|
    options[:serial] = serial
  end
  opts.on("-telnet","--telnet TELNET", "Use a telnet session with array? Default is yes.") do |obj|
     options[:telnet] = obj
  end
end
opt_parser.parse(ARGV)
if options[:serial] 
  if options[:serial] != 'none'
    array_serial = options[:serial].to_sym
  else
    array_serial = nil
  end
else 
  array_serial = nil
end
spec = options[:spec]
settings={
  env: options[:env],
  username: options[:username],
  password: options[:password],
  browser_name: options[:browser_name],
  skip_api: options[:skip_api],  
  rspec_out: options[:rspec_out], #"E:/xmsc_results",
  remote_srvr: "10.100.185.250", #"http://10.100.185.3", 
  remote_report: options[:remote_report],
  project_id: options[:project_id],
  testcycle_id: options[:testcycle_id],
  release_id: options[:release_id],
  build_id: options[:build_id],
  telnet: options[:telnet],
  array_serial: array_serial
    
}  

#spec= "TS_Profiles/TC_Profile_01_spec.rb"
EXECUTOR.run_specs([spec], settings)



