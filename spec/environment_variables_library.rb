
def return_proper_value_based_on_the_used_environment(envirnoment_used, test_file_name, needed_parameter)
	puts "THE ENVIRONMENT USED : #{envirnoment_used}"
	puts "TEST FILE : #{test_file_name}"
	puts "NEEDED PARAMETER: #{needed_parameter}"
	case test_file_name
		when "supportTools/access_points/search_for_ap.rb"
			if envirnoment_used == "test03"
				if needed_parameter == "AP SN"
					return "AUTOWAP9132AVAYA001SELFOWNED"
				elsif needed_parameter == "Tenant ID"
					return "8d8b8c40-1b61-11e7-b4eb-06c05ef2ae8d"
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "AP SN"
					return "AUTOWAP9173AVAYA001FIRST"
				elsif needed_parameter == "Tenant ID"
					return "1392e121-2d52-11e6-af41-0a048895c7a1"
				end
			end
		when "supportManagement/access_points/"
			if envirnoment_used == "test03"
				return "AUTOXR320CHROME001FIRST"
			elsif envirnoment_used == "test01"
				return "MACAUTOCHROME1"
			end
		when "supportManagement/customers/customers_tab_change_circle.rb"
			if envirnoment_used == "test03"
				return "test anca"
			elsif envirnoment_used == "test01"
				return "ANCA-Child-T01"
			end
		when "supportManagement/customers/customers_tab_search_for_customer.rb"
			if envirnoment_used == "test03"
				return 23
			elsif envirnoment_used == "test01"
				return 150
			end
		when "supportManagement/circles.rb"
			if envirnoment_used == "test03"
				if needed_parameter == "first tenant"
					return "Adrian-Automation-Chrome-Fourth"
				elsif needed_parameter == "second tenant"
					return "test anca"
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "first tenant"
					return "TEST CHROME"
				elsif needed_parameter == "second tenant"
					return "ANCA-Child-T01"
				end
			end
		when "mynetwork/access_points_tab/exports.rb"
			if envirnoment_used == "test03"
				if needed_parameter == "Tenant Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Tenant Count"
					return 1
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "Tenant Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Tenant Count"
					return 1
				end
			end
		when "msp/dashboard/"
			if envirnoment_used == "test03"
				if needed_parameter == "first ap"
					return "AUTOXR320CHROME001"
				elsif needed_parameter == "second ap"
					return "AUTOXR320CHROME003"
				elsif needed_parameter == "delete tenants array"
					return Array["Adrian-Automation-", "Adrian-Automation-General-SELF-OWNED"]
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "first ap"
					return "MACAUTOCHROME1"
				elsif needed_parameter == "second ap"
					return "MACAUTOCHROME03"
				elsif needed_parameter == "delete tenants array"
					return Array["Adrian-Automation-"]
				end
			end
		when "troubleshooting/msp/arrays"
			if envirnoment_used == "test03"
				return "AUTOXR620CHROME011FOURTEENTH"
			elsif envirnoment_used == "test01"
				return "AUTOXR620CHROME011FOURTEENTH"
			end
		when "msp/access_points"
			if envirnoment_used == "test03"
				if needed_parameter == "serial number"
					return "AUTOXR620CHROME011FIRST"
				elsif needed_parameter == "mac"
					return "00:11:33:21:33:11"
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "serial number"
					return "MACAUTOCHROME1"
				elsif needed_parameter == "mac"
					return "13:e2:30:C4:00:00"
				end
			end
		when "msp/export"
			if envirnoment_used == "test03"
				if needed_parameter == "serial number"
					return ["AUTOXR620CHROME011FIRST","AUTOXR620CHROME012FIRST"]
				elsif needed_parameter == "mac"
					return ["00:11:33:21:33:11", "00:11:33:21:33:12"]
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "serial number"
					return ["AUTOX2120CHROME008FIRST", "AUTOX2120CHROME007FIRST"]
				elsif needed_parameter == "mac"
					return ["01:01:01:01:01:08","01:01:01:01:01:07"]
				end
			end
		when "msp/general_features"
			if envirnoment_used == "test03"
					return ["AUTOXR620CHROME011FIRST","01:01:01:01:01:11", "XR620", "Tenant Scope Dropdownlist testing", "AutomationXR620-CHROME-011-First", "Profile for CC APs tab testing", "Cluj-Napoca", "AD #{XMS.ickey_shuffle(9)}"]
			elsif envirnoment_used == "test01"
					return ["AUTOX2120CHROME007FIRST", "01:01:01:01:01:07", "X2-120", "Tenant Scope Dropdownlist testing", "AutomationX2-120-CHROME-007-First", "Profile for CC APs tab testing", "Cluj-Napoca", "AD #{XMS.ickey_shuffle(9)}"]
			end
		when "api/api_user"
			if envirnoment_used == "test03"
				if needed_parameter == "first tenant"
					return "Adrian-Automation"
				elsif needed_parameter == "second tenant"
					return "Adrian-Automation-Chrome"
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "first tenant"
					return "Adrian-Automation-Chrome"
				elsif needed_parameter == "second tenant"
					return "Adrian-Automation"
				end
			end
		when "mynetwork/floorplans/"
			if envirnoment_used == "test03"
				return "AutomationX2-120-CHROME-010-Tenth"
			elsif envirnoment_used == "test01"
				return "AutomationX2-120-CHROME-010-Tenth"
			end
		when "mynetwork/access_points_tab/groups/"
			if envirnoment_used == "test03"
				if needed_parameter == "3 tenants"
					return ["AutomationXR320-CHROME-001-Twelfth", "AutomationX2-120-CHROME-006-Twelfth", "AutomationXR520-CHROME-013-Twelfth"]
				elsif needed_parameter == "2 tenants"
					return ["AutomationXR320-CHROME-002-Twelfth", "AutomationXR320-CHROME-003-Twelfth"]
				elsif needed_parameter == "1 tenant"
					return "AutomationXR320-CHROME-002-Twelfth"
				elsif needed_parameter == "1 tenant second"
					return "AutomationXR320-CHROME-003-Twelfth"
				elsif needed_parameter == "1 tenant array"
					return ["AutomationXR320-CHROME-003-Twelfth"]
				elsif needed_parameter == "ap count"
					return "15"
				elsif needed_parameter == "ap name for profile 1"
					return "AutomationXR320-CHROME-003-Twelfth"
				elsif needed_parameter == "ap name for profile 2"
					return "AutomationXR320-CHROME-002-Twelfth"
				elsif needed_parameter == "max limit"
					return 8
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "3 tenants"
					return ["AutomationXR320-CHROME-001-Twelfth", "AutomationX2-120-CHROME-006-Twelfth", "AutomationXR520-CHROME-013-Twelfth"]
				elsif needed_parameter == "2 tenants"
					return ["AutomationXR320-CHROME-002-Twelfth", "AutomationXR320-CHROME-003-Twelfth"]
				elsif needed_parameter == "1 tenant"
					return "AutomationXR320-CHROME-002-Twelfth"
				elsif needed_parameter == "1 tenant second"
					return "AutomationXR320-CHROME-003-Twelfth"
				elsif needed_parameter == "1 tenant array"
					return ["AutomationXR320-CHROME-003-Twelfth"]
				elsif needed_parameter == "ap count"
					return "15"
				elsif needed_parameter == "ap name for profile 1"
					return "AutomationXR320-CHROME-002-Twelfth"
				elsif needed_parameter == "ap name for profile 2"
					return "AutomationXR320-CHROME-003-Twelfth"
				elsif needed_parameter == "max limit"
					return 8
				end
			end
		when "supportManagement/aos_boxes/create_add_circles_delete"
			if envirnoment_used == "test03"
				if needed_parameter == "First Customer"
					return "Adrian-Automation-Chrome-Fourth"
				elsif needed_parameter == "Second Customer"
					return "Empty Circle"
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "First Customer"
					return "TEST CHROME"
				elsif needed_parameter == "Second Customer"
					return "General Public"
				end
			end
		when "supportManagement/customers/browsing_tenant_ap_tab_command_line_interface"
			if envirnoment_used == "test03"
				if needed_parameter == "Customer Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Customer Count"
					return 1
				elsif needed_parameter == "Details"
					return Hash["Serial Number" => "X306519043B60", "Name" => "Romania-XR620-Auto", "Activation Server" => "//activate-test03.cloud.xirrus.com", "Cloud Server" => "stomp-test03.cloud.xirrus.com"]
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "Customer Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Customer Count"
					return 1
				elsif needed_parameter == "Details"
					return Hash["Serial Number" => "X20641902ADDC", "Name" => "Romania-XR620-Auto", "Activation Server" => "//activate-test01.cloud.xirrus.com", "Cloud Server" => "stomp-test01.cloud.xirrus.com"]
				end
			end
		when "troubleshooting/command_line_history"
			if envirnoment_used == "test03"
				if needed_parameter == "Customer Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Customer Count"
					return 1
				elsif needed_parameter == "AP Parameters"
					return Hash["Serial Number" => "X306519043B60", "Name" => "Romania-XR620-Auto"]
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "Customer Name"
					return "1-Macadamian Child XR-620"
				elsif needed_parameter == "Customer Count"
					return 2
				elsif needed_parameter == "AP Parameters"
					return Hash["Serial Number" => "X6065440515BE", "Name" => "Romania-XR620"]
				end
			end
		when "supportTools/customrs/"
			if envirnoment_used == "test03"
				return "Macadamian - Avaya MSP"
			elsif envirnoment_used == "test01"
				return "Macadamian Avaya Parent"
			end
		when "troubleshooting/my_network/audit_trail_block_unblock_clients.rb"
			if envirnoment_used == "test03"
				if needed_parameter == "Tenant Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Client Name"
					return "HUAWEI_nova"
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "Tenant Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Client Name"
					return "Adrians-iPhone"
				end
			end
		when "troubleshooting/my_network/audit_trail_alerts.rb"
			if envirnoment_used == "test03"
				return ["1-Macadamian Child XR-620-Auto", 1, "Romania-XR620-Auto"]
			elsif envirnoment_used == "test01"
				return ["1-Macadamian Child XR-620-Auto", 1, "Romania-XR620-Auto"]
			end
		when "/my_network/clients_search_for_entries.rb"
			if envirnoment_used == "test03"
				if needed_parameter == "Tenant Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Tenant Count"
					return 1
				elsif needed_parameter == "Clients Hash"
					return Hash["First Client" => Hash["Hostname" => "iPhone4aladesus", "Device Class" => "Phone", "Device Icon" => ".xc-icon-nssg-deviceicon-phone"], "Second Client" => Hash["Hostname" => "Adrians-iMac", "Device Class" => "Notebook", "Device Icon" => ".xc-icon-nssg-deviceicon-notebook"], "Third Client" => Hash["Hostname" => "44:2a:60:70:83:72", "Device Class" => "Tablet", "Device Icon" => ".xc-icon-nssg-deviceicon-tablet"], "Fourth Client" => Hash["Hostname" => "adriandlocal-System-Product-Name", "Device Class" => "Notebook", "Device Icon" => ".xc-icon-nssg-deviceicon-notebook"]]
				end
			elsif envirnoment_used == "test01"
				if needed_parameter == "Tenant Name"
					return "1-Macadamian Child XR-620-Auto"
				elsif needed_parameter == "Tenant Count"
					return 1
				elsif needed_parameter == "Clients Hash"
					return Hash["First Client" => Hash["Hostname" => "FLAVIU", "Device Class" => "Phone", "Device Icon" => ".xc-icon-nssg-deviceicon-phone"], "Second Client" => Hash["Hostname" => "Adrians-iMac", "Device Class" => "Notebook", "Device Icon" => ".xc-icon-nssg-deviceicon-notebook"], "Third Client" => Hash["Hostname" => "android-a7ab7890fae3b6fe", "Device Class" => "Tablet", "Device Icon" => ".xc-icon-nssg-deviceicon-tablet"], "Fourth Client" => Hash["Hostname" => "Gabriels-MBP", "Device Class" => "Notebook", "Device Icon" => ".xc-icon-nssg-deviceicon-notebook"]]
				end
			end
		when "steelconnect/go_directly_to_tenant.rb"
			if envirnoment_used == "test03"
				return Hash["First Tenant ID" => "1ddf2600-9f90-11e7-abc8-06494a71b581", "First Tenant Name" => "Adrian-Automation-Chrome-SteelConnect-Child", "Second Tenant ID" => "6e297540-a29f-11e7-9668-06c05ef2ae8d", "Second Tenant Name" => "Adrian-Automation-Chrome-SteelConnect-Child-SELF-No-Profiles"]
			elsif envirnoment_used == "test01"
				return Hash["First Tenant ID" => "292e1a41-d0fd-11e7-9084-0a225c12ebbd", "First Tenant Name" => "Adrian-Automation-Chrome-SteelConnect-Child", "Second Tenant ID" => "271a1c70-d0ff-11e7-9084-0a225c12ebbd", "Second Tenant Name" => "Adrian-Automation-Chrome-SteelConnect-Child-SELF-No-Profiles"]
			end
	end
end

def return_proper_value_based_on_the_used_account(account_used, test_file_name, needed_parameter)
	puts "THE ACCOUNT USED : #{account_used}"
	puts "TEST FILE : #{test_file_name}"
	puts "NEEDED PARAMETER: #{needed_parameter}"
	case account_used
		when "adinte+automation+chrome@macadamian.com"
      return "Adrian-Automation-Chrome"
    when "adinte+automation+chrome+second@macadamian.com"
      return "Adrian-Automation-Chrome-Second"
    when "adinte+automation+chrome+third@macadamian.com"
      return "Adrian-Automation-Chrome-Third"
    when "adinte+automation+chrome+fourth@macadamian.com"
      return "Adrian-Automation-Chrome-Fourth"
    when "adinte+automation+chrome+fifth@macadamian.com"
      return "Adrian-Automation-Chrome-Fifth"
    when "adinte+automation+chrome+tenth@macadamian.com"
      return "Adrian-Automation-Chrome-Tenth"
    when "adinte+automation+chrome+twelfth@macadamian.com"
      return "Adrian-Automation-Chrome-Twelfth"
    when "adinte+automation+chrome+thirteenth@macadamian.com"
      return "Adrian-Automation-Chrome-Thirteenth"
    when "adinte+automation+chrome+fourteenth@macadamian.com"
      return "Adrian-Automation-Chrome-Fourteenth"
    when "adinte+automation+avaya+chrome@macadamian.com"
      return "Adrian-Automation-Avaya-Chrome"
    when "adinte+automation+eircom+chrome@macadamian.com"
      return "Adrian-Automation-Eircom-Chrome"
	end
end