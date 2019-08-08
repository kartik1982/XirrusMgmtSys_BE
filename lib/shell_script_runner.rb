require 'net/ssh'
require 'net/scp'

Net::SSH.start("10.100.185.210", "xirrus", password: "Xirrus!23") do |ssh|
  path="9.1.0/XirrusMgmtSys_GUI/Regression/TS_XMSLight/"
  local_path=Dir.home+"/reports/"+path
  remote_path= "./reports/"+"9.1.0/XirrusMgmtSys_GUI/Regression/"
  ssh.exec!("mkdir -p #{remote_path}")
  puts local_path
  puts remote_path
  ssh.scp.upload! "#{local_path}", "#{remote_path}", {recursive: true}
  # puts ssh.exec!("pwd")
  puts ssh.exec!("ruby -v")
  # puts ssh.exec!("ruby jenkins-runner --spec 'ui/mynetwork/switches_tab/switch_port_stats.rb' --skip_api true --headless false --env 'test01' --username mynetwork+switchtab+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name chrome")

end
  # Net::SCP.start("10.100.185.210", "xirrus", :password => "Xirrus!23") do |scp|
    # path="9.1.0/XirrusMgmtSys_GUI/Regression/TS_XMSLight/"
    # local_path=Dir.home+"/reports/"+path+"TC_Create_All_Types_Of_Portals.html"
    # local_path="C:/Users/xirrus/reports/9.1.0/XirrusMgmtSys_GUI/Regression/TS_XMSLight/*.html"
    # scp.upload! local_path, "./reports/"
    # puts "done"
  # end
