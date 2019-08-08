# bin/bash
echo $release
echo $environment
echo $browser
case $1 in
	"TS_AOS_Light")
		for testToRun in "TS_AOS_Light/TC_SSIDs_Access_Control_Easypass_Portals_Creation_And_Gap_All.rb" "TS_AOS_Light/TC_SSIDs_Access_Control_Easypass_Onboarding_And_Self_Reg.rb" "TS_AOS_Light/TC_SSIDs_Access_Control_Easypass_Personal.rb" "TS_AOS_Light/TC_SSIDs_Access_Control_AOS_Light_Disabled_Features.rb" "TS_AOS_Light/TC_SSIDs_Access_Control_Login_Page_External.rb" "TS_AOS_Light/TC_SSIDs_Access_Control_Splash_Page_External.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username aoslite+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Eircom")
		for testToRun in "TS_Eircom/TC_Eircom_Settings_Create_Users.rb" "TS_Eircom/TC_Eircom_General.rb" "TS_Eircom/Profile/TC_Eircom_Services.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+eircom+chrome+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Eircom/TC_Eircom_Settings_Addon_Solutions_Webtitan_Positive_Testing.rb" "TS_Eircom/TC_Eircom_Settings_Addon_Solutions_Webtitan_No_Space_To_Add.rb" "TS_Eircom/TC_Eircom_Settings_Addon_Solutions_Webtitan_Incorrect_Configurations.rb" "TS_Eircom/TC_Eircom_Settings_Addon_Solutions_Airwatch.rb" "TS_Eircom/TC_Eircom_Profiles.rb" "TS_Eircom/TC_Eircom_Portals.rb" "TS_Eircom/TC_Eircom_Settings_My_Account.rb" "TS_Eircom/TC_Eircom_Reports.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+eircom+chrome+user@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Eircom/TC_Eircom_GuidedTour.rb" "TS_Eircom/msp/TC_Eircom_MSP_Contact_Support_Ticketing_System.rb" "TS_Eircom/msp/TC_Eircom_MSP_Cleanup_Environment.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+eircom+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_General")
		for testToRun in "TS_General/Cloud_Admin/TC_Support_Management_Visible_Not_Editable.rb" "TS_General/Localized_Time_Display/TC_Localized_Mynetwork_AccessPoints_Tab.rb" "TS_General/Localized_Time_Display/TC_Globalized_Mynetwork_AccessPoints_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+realuser+cloud+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/Localized_Time_Display/TC_Globalized_MSP_AccessPoints.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+realuser+commandcenter+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_General/Domain_Admin/TC_DomainAdmin_General_Features.rb" "TS_General/TC_Guidedtour_Hidden_For_MSP_Parent.rb" "TS_General/TC_GuidedTour.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username general+msp+automation+domain+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/Domain_Admin/TC_Create_Child_Tenant_Assign_User.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username general+msp+automation+domain+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/Domain_Admin/TC_DomainAdmin_Create_Duplicate_Delete_Portals.rb" "TS_General/Domain_Admin/TC_DomainAdmin_Create_Favorite_Duplicate_Delete_Reports.rb" "TS_General/Domain_Admin/TC_DomainAdmin_Create_Default_Duplicate_Delete_Profiles.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username general+automation+domain+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/Domain_Admin/TC_DomainAdmin_Delete_Tenant.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username general+msp+automation+domain+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/Localized_Time_Display/TC_Localized_SupportManagement_AccessPoints_Tab.rb" "TS_General/Localized_Time_Display/TC_Localized_Troubleshooting_Audit_Trail.rb" "TS_General/Localized_Time_Display/TC_Localized_SupportManagement_Firmware.rb" "TS_General/Domain_Admin/TC_DomainAdmin_General_Features_Child_Domain.rb" "TS_General/TC_Feedback.rb" "TS_General/Localized_Time_Display/TC_Globalized_SupportManagement_AccessPoints_Tab.rb" "TS_General/Localized_Time_Display/TC_Globalized_SupportManagement_Firmware.rb" "TS_General/Localized_Time_Display/TC_Localized_Portals_Self_Reg_Guests.rb" "TS_General/Localized_Time_Display/TC_Globalized_Report_Analytics.rb" "TS_General/Localized_Time_Display/TC_Globalized_Reports_Creation.rb" "TS_General/Localized_Time_Display/TC_Globalized_Portals_Self_Reg_Guests.rb" "TS_General/Localized_Time_Display/TC_Globalized_Troubleshooting_Audit_Trail_Area.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username general+time+format+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/TC_Whatsnew.rb" "TS_General/TC_Whatsnew_banner.rb" "TS_General/TC_Filter_Groups_Profiles_SSIDs.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username general+filter+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/TC_Riverbed_Eircom_Branding.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+eircom+chrome+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/TC_Riverbed_Eircom_XMSE_Branding.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+eircom+chrome+xmse@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/TC_Riverbed_Avaya_Branding.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+avaya+chrome+admin@macadamian.co --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/TC_Riverbed_Avaya_XMSE_Branding.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+avaya+wose+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/TC_Riverbed_Xirrus_Branding.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+realuser+commandcenter+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_General/TC_Riverbed_Xirrus_XMSE_Branding.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+xmse@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Help_Links")
		for testToRun in "TS_Help_Links/TC_Command_Center.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username help+link+automation+msp+domain+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Help_Links/TC_Portal_Pages.rb" "TS_Help_Links/TC_Profile_Pages.rb" "TS_Help_Links/TC_Reports.rb" "TS_Help_Links/TC_Profiles_Landing_Page.rb" "TS_Help_Links/TC_Portals_Landing_Page.rb" "TS_Help_Links/TC_Mynetwork_Map.rb" "TS_Help_Links/TC_Mynetwork_Alerts.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username help+link+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done			
	;;
	"TS_MSP")
		for testToRun in "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_MSP/TC_MSP_Environment_Preparation.rb" "TS_MSP/TC_MSP_Navigation_Through_Tabs.rb" "TS_MSP/TC_MSP_Access_Points_Put_In_Out_Of_Service.rb" "TS_MSP/TC_MSP_Assign_Access_Point.rb" "TS_MSP/TC_MSP_Assign_Several_Access_Points.rb" "TS_MSP/TC_MSP_Domains.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Detailed_View_Navigation.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Detailed_View_OK_Domain.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Healthy_Sorting.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_MSP/TC_MSP_Access_Points_Put_Into_Service_All.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_AP_Warning.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Search.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Profile_Warning.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Tab_Notifications.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Detailed_View_Critical_Domain.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Unhealthy_Sorting.rb" "TS_MSP/Dashboard/TC_MSP_Verify_Dashboard_Out_Of_Service_No_Warning.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_MSP/TC_MSP_General_Features.rb" "TS_MSP/TC_MSP_Access_Points_Export.rb" "TS_MSP/TC_MSP_Domains_Export.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_MSP_Non_MSP_Owned_Equipment.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_MSP/Users/TC_MSP_Users_Tab_Create_Users.rb" "TS_MSP/Users/TC_MSP_Domains_Tab_Create_Users.rb" "TS_MSP/Users/TC_MSP_Verify_Created_Users.rb" "TS_MSP/Users/TC_MSP_Verify_Filters.rb" "TS_MSP/Users/TC_MSP_Delete_Users.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+second@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_MSP_Contact_Support_Ticketing_Email_System.rb" "TS_MSP/TC_MSP_Contact_Support_Ticketing_System.rb" "TS_MSP/TC_MSP_Contact_Support_Ticketing_System_Not_Present_Child_Domain.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Deploy_Domains.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Composite_Verify_No_Deploy.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Google_Deploy_Verify.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Onetouch_Deploy_Verify.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Ambassador_Deploy_Verify.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Self_Reg_Deploy_Verify.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Personal_Deploy_Verify.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Voucher_Deploy_Verify.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Azure_Deploy_Verify.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Verify_Duplicate_Deploy.rb" "TS_MSP/Domains/TC_DeployPortals_Create_Portal_Onboarding_Deploy_Verify.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+sixth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_MSP/Domains/TC_Deploy_To_Domain_Create_Profile.rb" "TS_MSP/Domains/TC_Deploy_To_Domain_Deploy.rb" "TS_MSP/Domains/TC_Deploy_To_Domain_Verify_Deployment.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_MSP/TC_MSP_Negative_Testing_Domains.rb" "TS_MSP/TC_MSP_Negative_Testing_Users_General.rb" "TS_MSP/TC_MSP_Negative_Testing_Users_Duplicate_Emails.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+tenth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Mynetwork")
		for testToRun in "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_Optimizations_Band.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_Optimizations_Channel.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_Optimizations_Power.rb" "TS_Mynetwork/TC_Mynetwork_Rogues.rb" "TS_Mynetwork/TC_Mynetwork_Clients_General_Features.rb" "TS_Mynetwork/TC_Mynetwork_Clients_Details_Slideout.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Applications_Drilldown.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Clients_Over_Time.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Data_Throughput_For_AP.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Data_Throughput_For_Clients.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Top_Clients_Application_Drilldown.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Top_Clients_Block.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Top_Access_Points_By_Usage.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Top_Application_Categories_By_Usage.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Top_Applications_By_Usage.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Top_Clients_By_Usage.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Top_Devices_Types_By_Usage.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Top_Manufacturers_By_Usage.rb" "TS_Mynetwork/TC_Mynetwork_Clients_Profile_Group_Filter.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Widget_Clients_Band.rb" "TS_Mynetwork/Dashboard_Tiles/TC_Dashboard_Application_Descrption_For_Top_App.rb" "TS_Mynetwork/TC_Mynetwork_Alerts_Grid.rb" "TS_Mynetwork/TC_Mynetwork_Clients_Search_For_Entries.rb" "TS_Mynetwork/TC_Mynetwork_Clients_Go_Direct_To_Details_Slideout.rb" "TS_Mynetwork/Floorplans/TC_Floorplan_Rogue_Details_Popup.rb" "TS_Mynetwork/TC_Mynetwork_AP_Clients_Go_Direct_To_Details_Slideout_With_Timefilter.rb" "TS_Mynetwork/TC_Mynetwork_Clients_Export.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_AccessPoints_Exports.rb" "TS_Mynetwork/TC_Mynetwork_Rogues_Filter_Export.rb" "TS_Mynetwork/TC_Mynetwork_Alerts_Rogues_List_Cleanup.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_AP_Details_Slideout_Clients_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+realuser@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_General_Features_Child_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done		
		for testToRun in "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_Access_Point_Reset.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_Access_Point_Sorting_Columns.rb" "TS_Mynetwork/TC_Add_Edit_Profile_Groups_Verify_Clients_Filter.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username mynetwork+accesspointreset+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Mynetwork/Floorplans/TC_Floorplan_Create_Edit_Delete.rb" "TS_Mynetwork/Floorplans/TC_Floorplan_AP_Details_General_Tab_Profile_Location_AP_Name.rb" "TS_Mynetwork/Floorplans/TC_Mynetwork_AP_Details_General_Tab_Add_Delete_Tags.rb" "TS_Mynetwork/Floorplans/TC_Floorplan_Create_Delete.rb" "TS_Mynetwork/Floorplans/TC_Floorplan_Create_Add_Several_Floors_Delete.rb" "TS_Mynetwork/Floorplans/TC_Floorplan_Access_Point_Channels.rb" "TS_Mynetwork/Floorplans/TC_Floorplan_Create_Use_Heatmap_Delete.rb" "TS_Mynetwork/Floorplans/TC_Floorplan_Access_point_Location_Reporting.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username mynetwork+floorplan+automation+xms+user@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_Group_Filter_Dashboard_Delete_Group.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_Group_Verify_Dashboard.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_Group_Verify_Dashboard_Navigation.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_Edit_Delete.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_Edit_Delete_From_Profile.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_General_Features.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_Groups_Verify_Max_Limit.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_Groups_Verify_Search.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Verify_Scope_Delete_Group.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_Edit_Delete_Verify_Tile_View.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Add_APs_From_AP_Tab_Verify_Delete.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Schedule_Filtered_Report.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Verify_Scheduled_Report_Grid.rb" "TS_Mynetwork/Access_Points_Tab/TC_Group_Export.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username mynetwork+group+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_General_Features_Parent_Domain.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_AP_Put_Out_Of_Service_Put_In_Service_Profile.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_Put_In_Out_Of_Service_With_Profile.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_AP_Put_In_Out_Of_Service_Without_Profile.rb" "TS_Mynetwork/TC_Mynetwork_Dashboard.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_Readonly_Profile.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetowkr_Access_Point_Grid_Editing.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetwork_Normal_Profile.rb" "TS_Mynetwork/Access_Points_Tab/TC_Mynetowkr_AP_Decommission.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username mynetwork+accesspointtab+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Mynetwork/TC_Mynetwork_Clients_Details_Aternity_Tenant.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+aternity+xms+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Portal")
		for testToRun in "TS_Portal/General/TC_Portal_General_Features.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Languages_Ambassador.rb" "TS_Portal/Look_Feel/TC_portal_LookFeel_Languages_Onetouch.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Languages_Composite.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Languages_Self_Reg.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Languages_Voucher.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Background_Image.rb" "TS_Portal/Guests/TC_Portal_User_Guest_Tabs_General_Features.rb" "TS_Portal/Guests/TC_Portal_Guests.rb" "TS_Portal/Guests/TC_Portal_Guests_Creation_Ambassador.rb" "TS_Portal/Guests/TC_Portal_Guests_Creation_Self_Reg.rb" "TS_Portal/Guests/TC_Portal_Users_Creation.rb" "TS_Portal/Guests/TC_Portal_Users_Onboarding_Send_Upsks_All.rb" "TS_Portal/Guests/TC_Portal_Users_Onboarding_Send_Upsks.rb" "TS_Portal/TC_Portal_Template_Export_Import.rb" "TS_Portal/Guests/TC_Portal_Users_Creation_User_Group_With_Profile.rb" "TS_Portal/TC_Portal_Vouchers.rb" "TS_Portal/Guests/TC_Portal_Users.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username portal+looknfeel+automation+xms+user@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Portal/SSIDs/TC_Portal_SSIDs_Ambassador.rb" "TS_Portal/SSIDs/TC_Portal_SSIDs_Azure.rb" "TS_Portal/SSIDs/TC_Portal_SSIDs_Google.rb" "TS_Portal/SSIDs/TC_Portal_SSIDs_Onboarding.rb" "TS_Portal/SSIDs/TC_Portal_SSIDs_Onetouch.rb" "TS_Portal/SSIDs/TC_Portal_SSIDs_Personal.rb" "TS_Portal/SSIDs/TC_Portal_SSIDs_Self_Reg.rb" "TS_Portal/SSIDs/TC_Portal_SSIDs_Voucher.rb" "TS_Portal/SSIDs/TC_Portal_SSIDs_Composite.rb" "TS_Portal/General/TC_Portal_General_Azure.rb" "TS_Portal/General/TC_Portal_General_Ambassador.rb" "TS_Portal/General/TC_Portal_General_Google.rb" "TS_Portal/General/TC_Portal_Ggeneral_Onboarding.rb" "TS_Portal/General/TC_Portal_General_Onetouch.rb" "TS_Portal/General/TC_Portal_General_Personal.rb" "TS_Portal/General/TC_Portal_General_Voucher.rb" "TS_Portal/General/TC_Portal_General_Self_Reg.rb" "TS_Portal/General/TC_Portal_General_Composite.rb" "TS_Portal/General/TC_Portal_General_Whitelist_Configurations.rb" "TS_Portal/General/TC_Portal_General_Google_Max_Domains.rb" "TS_Portal/General/TC_Portal_General_Self_Reg_Max_Sponsors.rb" "TS_Portal/General/TC_Portal_General_Onboarding_Self_Directory_Google.rb" "TS_Portal/General/TC_Portal_General_Onboarding_Self_Directory_Azure.rb" "TS_Portal/General/TC_Portal_General_Onboarding_Self.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Ambassador.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Google.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Azure.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Self_Reg.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Self_Reg_Auth_Languages.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Voucher.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Personal.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Onetouch.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Onboarding.rb" "TS_Portal/Look_Feel/TC_Portal_LookFeel_Composite.rb" "TS_Portal/TC_Portal_Access_Control_Azure.rb" "TS_Portal/TC_Portal_Access_Control_Google.rb" "TS_Portal/TC_Portal_Easypassportal_Landingpage_Defaul.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username portal+lookNfeel+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done		
	;;
	"TS_Portals")
		for testToRun in "TS_Portals/TC_Portals_Enterprise.rb" "TS_Portals/TC_Portals_Guestambassador.rb" "TS_Portals/TC_Portals_Onboarding.rb" "TS_Portals/TC_Portals_Personalwifi.rb" "TS_Portals/TC_Portals_Publicaccess.rb" "TS_Portals/TC_Portals_Selfregistrtion.rb" "TS_Portals/TC_Portals_Voucher.rb" "TS_Portals/TC_Portals_Azure.rb" "TS_Portals/TC_Portals_Composite.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+xms+admin+eleventh@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Portals/TC_Expired_Portals.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username expired+portal+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done		
	;;
	"TS_Profile")
		for testToRun in "TS_Profile/TC_Profile_AP_Grid_Other_Tests.rb" "TS_Profile/TC_Profile_AP_Assign.rb" "TS_Profile/TC_Profile_AP_Test_Normal_Profile.rb" "TS_Profile/Network/TC_Profile_Network.rb" "TS_Profile/Network/TC_Profile_Network_LACP_Support.rb" "TS_Profile/Network/TC_Profile_Network_DHCP_Pool_Single_SSID.rb" "TS_Profile/Optimization/TC_Profile_Optimize.rb" "TS_Profile/Services/TC_Profile_Services_Positive.rb" "TS_Profile/Services/TC_Profile_Services_AOS_Light.rb" "TS_Profile/Services/TC_Profile_Services_Negative.rb" "TS_Profile/Services/TC_Profile_Services_MAC_Address_Hashing.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username profile+config+automation+xms+user@xirrus.com --password Qwerty1@ --browser_name $browser
		done		
		for testToRun in "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA2_AES_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA2_AES_TKIP_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA2_TKIP_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA_AES_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA_AES_TKIP_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA_TKIP_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA_WPA2_AES_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA_WPA2_AES_TKIP_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Auth_WPA_WPA2_TKIP_All.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Encry_Authentication.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Honeypot.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_VLANs.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_General.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Splash_Page_Internal_Image.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username profile+ssid+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done		
		for testToRun in "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Landing_Page.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Login_Page_Internal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Login_Page_External.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Splash_Page_Host_External.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Splash_Page_External_Image.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Create_New_Easypass_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Self_Registration_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Azure_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Google_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Guest_Ambassador_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_One_Click_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Personal_WIFI_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Voucher_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Onboarding_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Composite_Portal.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Create_Max.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username profile+ssid+automation+xms+user@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Profile/Polices/TC_Profile_Policies_Schedule_rules.rb" "TS_Profile/Polices/TC_Profile_Policies_Schedule_Policies.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_Aircleaner_Rules.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_Aircleaner_Rules_Edit_Delete.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_Aircleaner_Rules_Not_Possible.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_SSID_Device_Policies.rb" "TS_Profile/Polices/TC_Profile_Policies_SSID_Policy_Show_Advanced.rb" "TS_Profile/Admin/TC_Profile_Admin.rb" "TS_Profile/Bonjour/TC_Profile_Bonjour.rb" "TS_Profile/General/TC_Profile_General_Tab_All_Countries.rb" "TS_Profile/General/TC_Profile_General_Tab_All_Time_Zones.rb" "TS_Profile/General/TC_Profile_General_Tab_General_And_Advanced.rb" "TS_Profile/TC_Profile_Schedule_Config_Push.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username profile+policies+automation+xms+user@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Profile/Polices/TC_Profile_Policies_AOSLight_Appcon_General_Features.rb" "TS_Profile/Polices/TC_Profile_Policies_AOSLight_Appcon.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username profile+policies+noappcon+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Profile/Polices/TC_Profile_Policies_General_Features.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_Max_Rules_For_Device_Policy.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_Max_Rules_For_Global_Policy.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_Max_Rules_For_UG_Policy.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_Max_Rules_For_SSID_Policy.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_Max_Rules_For_Personal_SSID_Policy.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+domain+admin+eleventh@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Profile/Polices/TC_Profile_Policies_Create_Max_Policies.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_All_Application_Control_Configs.rb" "TS_Profile/Polices/TC_Profile_Policies_Create_All_Firewall_Control_Configs.rb" "TS_Profile/SSIDs/TC_Profile_SSIDs_Access_Control_Easypass_Portals.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username profile+policies+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Profiles")
		for testToRun in "TS_Profiles/TC_Profiles_Create_From_All_Locations.rb" "TS_Profiles/TC_Profiles_Duplicate.rb" "TS_Profiles/TC_Profiles_Readonly_Create_From_All_Locations.rb" "TS_Profiles/TC_Profiles_Set_As_Default.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+user+fifth@macadamian.com --password Qwerty1@ --browser_name $browser
		done				
	;;
	"TS_ReadOnly")
		for testToRun in "TS_ReadOnly/MSP/TC_MSP_Prerequisites_Read_Only.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_ReadOnly/TC_Prerequisites_Read_Only.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_ReadOnly/TC_Readonly_Settings.rb" "TS_ReadOnly/TC_Readonly_Reports.rb" "TS_ReadOnly/TC_Readonly_Profiles.rb" "TS_ReadOnly/TC_Readonly_General_Features.rb" "TS_ReadOnly/TC_Readonly_Mynetwork.rb" "TS_ReadOnly/TC_Readonly_Portals.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+readonly@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_ReadOnly/MSP/TC_MSP_Readonly_Settings.rb" "TS_ReadOnly/MSP/TC_MSP_Readonly_Reports.rb" "TS_ReadOnly/MSP/TC_MSP_Readonly_Profiles.rb" "TS_ReadOnly/MSP/TC_MSP_Readonly_General_Features.rb" "TS_ReadOnly/MSP/TC_MSP_Readonly_Command_Center_Admin.rb" "TS_ReadOnly/MSP/TC_MSP_Readonly_Portals.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+msp+readonly@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_Unassign_All_Access_Points_From_Child_Domain.rb" "TS_MSP/TC_MSP_Cleanup_Environment.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Refresh_Grids")
		for testToRun in "TS_Refresh_Grids/TC_Mynetwork_Alerts_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+realuser@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Refresh_Grids/TC_Command_Center_All_Tabs.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+second@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Refresh_Grids/TC_Backoffice_Access_Points_Tab.rb" "TS_Refresh_Grids/TC_Backoffice_Customers_Tab_and_Browsing_Tenant_Tabs.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+user+fifth@macadamian.com --password Qwerty1@ --browser_name $browser
		done	
		for testToRun in "TS_Refresh_Grids/TC_Portals_All_Types_Guests_Users_Vouchers_Tabs.rb" "TS_Refresh_Grids/TC_Settings_Provider_Management_Tab.rb" "TS_Refresh_Grids/TC_Settings_User_Accounts_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username refresh+grids+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Refresh_Grids/TC_Mynetwork_Access_Points_Tab.rb" "TS_Refresh_Grids/TC_Profile_Access_Points_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username refresh+grids+automation+xms+user@xirrus.com --password Qwerty1@ --browser_name $browser
		done			
	;;
	"TS_Reports")
		for testToRun in  "TS_Reports/TC_Reports_Creation.rb" "TS_Reports/TC_Reports_Creation_Clients.rb" "TS_Reports/TC_Reports_Creation_Switch.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username report+creation+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in  "TS_Reports/TC_Reports_General_Features.rb" "TS_Reports/TC_Reports_Drilldown_Without_Results.rb" "TS_Reports/TC_Reports_Email_Non_Recurring.rb" "TS_Reports/TC_Reports_Verify_Report_Email_Received.rb" "TS_Reports/TC_Reports_View_Scheduled_Edit.rb" "TS_Reports/TC_Reports_View_Scheduled_Delete.rb" "TS_Reports/TC_Reports_Email_Recurring.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin+fourth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in  "TS_Reports/TC_Reports_Editing.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin+fourth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Reports/TC_Reports_Drilldown_With_Results_Custom_Time_Interval.rb" "TS_Reports/TC_Reports_Drilldown_With_Results_Time_Interval_30_Days.rb" "TS_Reports/TC_Reports_Drilldown_With_Results_Time_Interval_7_Days.rb" "TS_Reports/TC_Reports_Drilldown_With_Results_Time_Interval_Last_Day.rb" "TS_Reports/TC_Reports_Drilldown_With_Results_Time_Interval_Last_Hour.rb" "TS_Reports/TC_Reports_Email_Recurring_Not_Available.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+realuser@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Reports/Analytics/TC_Analytics_Create_From_Previous_Delete.rb" "TS_Reports/Analytics/TC_Analytics_Create_Edit_Delete.rb" "TS_Reports/Analytics/TC_Analytics_Create_Analytics_With_Group_Delete_Group_Verify.rb" "TS_Reports/Analytics/TC_Analytics_General_Features.rb" "TS_Reports/Analytics/TC_Analytic_Report_Email_Option.rb" "TS_Reports/Analytics/TC_Analytics_Create_Max_Reports.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username report+analytic+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Search_Box")
		for testToRun in "TS_Search_Box/TC_Mynetwork_Clients_Tab_Parent.rb" "TS_Search_Box/TC_Mynetwork_Access_Points_Tab_Parent.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+realuser@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Search_Box/TC_Support_Management_Access_Points_Tab.rb" "TS_Search_Box/TC_Support_Management_Browsing_Tenant_Access_Points_Tab.rb" "TS_Search_Box/TC_Support_Management_Customers_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin+sixth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/Domains/TC_Create_Child_Tenant.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+sixth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Search_Box/TC_Portals_Ambassador_Guests_Tab.rb" "TS_Search_Box/TC_Portals_Self_Registration_Guests_Tab.rb" "TS_Search_Box/TC_Portals_Google_Azure_Users_Tab.rb" "TS_Search_Box/TC_Portals_Onboarding_Users_Tab.rb" "TS_Search_Box/TC_Profile_Clients_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin+sixth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Search_Box/TC_Portals_Voucher_Vouchers_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+user+sixth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/Domains/TC_Delete_Child_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+sixth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_Assign_All_Access_Points_To_Child_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+tenth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Search_Box/TC_Search_Profile_Access_Points_Tab.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+domain+admin+tenth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_Unassign_All_Access_Points_From_Child_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+tenth@macadamian.com --password Qwerty1@ --browser_name $browser
		done		
	;;
	"TS_Settings")
		for testToRun in "TS_Settings/TC_Firmware_Upgrades_Support_Management.rb" "TS_Settings/TC_Firmware_Upgrades_Different_Domains.rb" "TS_Settings/TC_Firmware_Upgrades_General_Features.rb" "TS_Settings/TC_Settings_Myaccount_Notifications.rb" "TS_Settings/TC_Settings_Myaccount_Subscription.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+fourth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Settings/TC_Settings.rb" "TS_Settings/TC_Settings_Addonsolutions_Airwatch.rb" "TS_Settings/TC_Settings_Addonsolutions_Twilio.rb" "TS_Settings/TC_Settings_User_Accounts_General_Features.rb" "TS_Settings/TC_Settings_User_Accounts_Create_Several_Users.rb" "TS_Settings/TC_Settings_Admin_User_Delete.rb" "TS_Settings/TC_Settings_AddonSolutions_Content_Filtering.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin+fourth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/Domains/TC_Create_Child_Tenant.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+fourth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Settings/TC_Settings_First_Name.rb" "TS_Settings/TC_Settings_Mobileproviders_New.rb" "TS_Settings/TC_Settings_Mobileproviders.rb" "TS_Settings/TC_Settings_Myaccount.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin+fourth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/Domains/TC_Delete_Child_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+fourth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Settings/Single_SignOn/TC_Settings_SSO_Configure_G_Suite.rb" "TS_Settings/Single_SignOn/TC_Settings_SSO_Configure_Azure.rb" "TS_Settings/Single_SignOn/TC_Settings_SSO_Configure_SAML.rb" "TS_Settings/TC_Settings_User_Accounts_Password_Expiration.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username settings+sso+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_Settings/TC_Settings_Mobileproviders_Deactivate_All.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+fifth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Settings/TC_Settings_Firmware_Upgrades_Mainline_Technology_Feature.rb" "TS_Settings/TC_Settings_Firmware_Upgrades_Tech_To_Main_Admin_Feedback.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+domain+admin+eleventh@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Steel_Connect")
		for testToRun in "TS_Steel_Connect/General/TC_SteelConnect_First_Login_Information_Modal.rb" "TS_MSP/TC_Assign_All_Access_Points_To_Child_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+steelconnect@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Steel_Connect/Mynetwork/TC_SteelConnect_Go_Directly_To_AP_Details_Slideout.rb" "TS_Steel_Connect/Profiles/TC_SteelConnect_Profile_Configurations_Are_Read_Only.rb" "TS_Steel_Connect/Profiles/TC_SteelConnect_Create_Profile_Disabled.rb" "TS_Steel_Connect/Mynetwork/TC_SteelConnect_General_Features.rb" "TS_Steel_Connect/General/TC_SteelConnect_Tag_Controls_Are_Hidden.rb" "TS_Steel_Connect/General/TC_SteelConnect_Go_Directly_To_Tenant.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+xms+admin+steelconnect@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_Unassign_All_Access_Points_From_Child_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+steelconnect@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_SupportManagement")
		for testToRun in "TS_SupportManagement/AccessPoints/TC_Access_Points_Verify_Icons.rb" "TS_SupportManagement/AccessPoints/TC_Access_Points_Verify_Columns.rb" "TS_SupportManagement/AccessPoints/TC_Action_Assign_To_Customer.rb" "TS_SupportManagement/AccessPoints/TC_Action_Clear_Penalty.rb" "TS_SupportManagement/AccessPoints/TC_Action_Command_Line_Interface.rb" "TS_SupportManagement/AOS_Boxes/TC_SupportMgmt_Duplicate_AOS_Box.rb" "TS_SupportManagement/AOS_Boxes/TC_SupportMgmt_Verify_Sorting_Feature.rb" "TS_SupportManagement/Customers/TC_Customers_Tab_Change_Circle.rb" "TS_SupportManagement/Customers/TC_Customers_Tab_grid_Verifications.rb" "TS_SupportManagement/Customers/TC_Customers_Tab_Search_For_Customer.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_AP_Installer.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Uers_Tab_Create_Users_Command_Center_Admin.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_Domain_User.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_Domain_Admin.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_Domain_Readonly.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_XMS_Admin.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_XMS_User.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_XMS_Readonly.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_Guest_Ambassador.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Create_Users_XMSE_Guest_Admin.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Delete_Users.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Grid_Verifications.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_AP_Tab_Grid_Verifications.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_AP_Tab_Command_Line_Interface.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_AP_Tab_Clear_Penalty.rb" "TS_SupportManagement/TC_SupportMgmt_Firmware.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_SupportManagement/TC_SupportMgmt_Circles.rb" "TS_SupportManagement/TC_SupportMgmt_Circles_Move_Tenants.rb" "TS_SupportManagement/Customers/TC_Browsing_Tenant_Users_Tab_Edit_Users.rb" "TS_SupportManagement/AOS_Boxes/TC_SupportMgmt_Create_Add_Circles_Delete.rb" "TS_SupportManagement/AOS_Boxes/TC_SupportMgmt_Create_Delete_Mainline_AOS_Box.rb" "TS_SupportManagement/AOS_Boxes/TC_SupportMgmt_Create_Delete_Technology_AOS_Box.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_SupportManagement/Customers/TC_Browsing_Tenant_AP_Tab_Delete_AP.rb" "TS_SupportManagement/AccessPoints/TC_Action_Delete.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome@macadamian.com --password Qwerty1@ --browser_name $browser --telnet false --serial 'AUTODELETEAP01'
		done
		for testToRun in "TS_SupportManagement/AccessPoints/TC_Access_Points_Verify_Error_More_Less_Info_Link.rb" "TS_SupportManagement/TC_SupportMgmt_Firmware_Sorting.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+xms+admin+eight@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_SupportTools")
		for testToRun in "TS_SupportTools/TC_Customers_General_Features.rb" "TS_SupportTools/TC_Customers_Search_For_Customer.rb" "TS_SupportTools/TC_AccessPoints_Search_For_AP.rb" "TS_SupportTools/TC_Orders_Verify_Orders_Grid.rb" "TS_SupportTools/TC_SupportUsers_Create_Edit_Delete_User.rb" "TS_SupportTools/TC_SupportUsers_Support_Tools_Cleanup.rb" "TS_SupportTools/TC_Customers_Browsing_Tenant_View.rb" "TS_SupportTools/TC_Customers_Browsing_Tenant_Add_Delete_Users.rb" "TS_SupportTools/TC_Customers_Scope_To_Customer.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+avaya+bo+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Switches")
		for testToRun in "TS_Switches/TC_Switches_Reboot.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username switch+automation+realuser+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Switches/SupportManagement/TC_Switches_Verify_Columns.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username mynetwork+switchtab+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Switches/Profile/TC_Switch_Assign_Unassign_Profile.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username mynetwork+switchtab+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Switches/TC_Switch_Port_Details_Panel.rb" "TS_Switches/TC_Switch_Port_Templates_Details_Panel.rb" "TS_Switches/TC_Switches_Export.rb" "TS_Switches/TC_Switch_Port_Stats.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username mynetwork+switchtab+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Switches/Templates/TC_Switch_Port_Template_Configuration.rb" "TS_Switches/Templates/TC_Switch_Template_Configuration.rb" "TS_Switches/Templates/TC_Switch_Template_Profile_Configuration.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username mynetwork+switchtab+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Switches/MSP/TC_Assign_Several_Switches_To_Child_Domain.rb" "TS_Switches/MSP/TC_Deploy_Switch_Template_To_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username msp+switches+automation+msp+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_Troubleshooting")
		for testToRun in "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_Troubleshooting/MSP/TC_Audit_Trail_MSP_Users.rb" "TS_Troubleshooting/MSP/TC_Audit_Trail_MSP_Domains.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+third@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Troubleshooting/Reports/TC_Audit_Trail_Reports.rb" "TS_Troubleshooting/Settings/TC_Audit_Trail_Firmware_Upgrades.rb" "TS_Troubleshooting/Settings/TC_Audit_Trail_Addon_Solutions_Content_Filtering.rb" "TS_Troubleshooting/TC_Audit_New_User_Email.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin+third@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/Domains/TC_Create_Child_Tenant.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+third@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Onboarding_Add_Edit_Delete_Users.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Self_Reg_Add_Edit_Delete_Guests.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Ambassador_Add_Edit_Delete_Guests.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Add_Delete_Vouchers.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Ambassador.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Google.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Onboarding.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_One_Click.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Personal.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Self_Reg.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Voucher.rb" "TS_Troubleshooting/Portal/TC_Audit_Trail_Portals_Azure.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin+third@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/Domains/TC_Delete_Child_Domain.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+third@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Troubleshooting/TC_Troubleshoot_Grid_Verifications.rb" "TS_Troubleshooting/TC_Troubleshoot_General_Features.rb" "TS_Troubleshooting/TC_Troubleshoot_Command_Line_History.rb" "TS_Troubleshooting/TC_Troubleshoot_Messages.rb" "TS_Troubleshooting/Mynetwork/TC_Audit_Trail_Access_Points_Optimizations.rb" "TS_Troubleshooting/Mynetwork/TC_Audit_Trail_Access_Points_Enable_Disable_Monitor.rb" "TS_Troubleshooting/Mynetwork/TC_Audit_Trail_Alerts.rb" "TS_Troubleshooting/Mynetwork/TC_Audit_Trail_Block_Unblock_Clients.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+realuser@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Troubleshooting/Settings/TC_Audit_Trail_My_Account.rb" "TS_Troubleshooting/Settings/TC_Audit_Trail_Add_Edit_Delete_User.rb" "TS_Troubleshooting/Reports/TC_Audit_Trail_Reports_Scheduling.rb" "TS_Troubleshooting/Settings/TC_Audit_Trail_Addon_Solutions_Twillio.rb" "TS_Troubleshooting/Settings/TC_Audit_Trail_Addon_Solutions_Airwatch.rb" "TS_Troubleshooting/Profile/TC_Audit_Trail_Profile_Configuration_Changes.rb" "TS_Troubleshooting/Profile/TC_Audit_Trail_Profile_Name_Change.rb" "TS_Troubleshooting/Profile/TC_Audit_Trail_Profile_Readonly.rb" "TS_Troubleshooting/Settings/TC_Audit_Trail_Provider_Management.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+xms+admin+thirteenth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_MSP/TC_MSP_Cleanup_Environment.rb" "TS_Troubleshooting/Profile/TC_Audit_Trail_Profile_Add_AP.rb" "TS_Troubleshooting/Profile/TC_Audit_Trail_Profile_Readonly_Add_AP.rb" "TS_Troubleshooting/MSP/TC_Audit_Trail_MSP_Arrays.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+fourteenth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Troubleshooting/TC_Troubleshoot_Audit_Trail_Search.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+xms+admin+fourteenth@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_Troubleshooting/Mynetwork/TC_Audit_Trail_Access_Points_Add_Remove_From_Profile.rb" "TS_Troubleshooting/Mynetwork/TC_Audit_Trail_Floorplans_Create_Delete.rb" "TS_Troubleshooting/Mynetwork/TC_Audit_Trail_Floorplans_Edit.rb" "TS_Troubleshooting/Mynetwork/TC_Audit_Trail_Floorplans_Edit_Add_Remove_AP.rb" "TS_Troubleshooting/TC_Troubleshoot_Audit_Trail_Export.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username troubleshooting+mynetwork+automation+xms+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_XMSE")	
		for testToRun in  "TS_XMSE/TC_XMSE_General.rb" "TS_XMSE/TC_XMSE_Self_Reg_Look_Feel.rb" "TS_XMSE/TC_XMSE_Self_Reg_General.rb" "TS_XMSE/TC_XMSE_Onboarding_Look_Feel.rb" "TS_XMSE/TC_XMSE_Onboarding_General.rb" "TS_XMSE/TC_XMSE_Portals.rb" "TS_XMSE/TC_XMSE_Settings.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username xmse+gap+automation+admin@xirrus.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_XMSGuest")
		for testToRun in "TS_XMSGuest/TC_XMSGuest_Preparation.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+admin@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_XMSGuest/TC_XMSGuest.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+guest@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_XMSLight")
		for testToRun in "TS_XMSLight/TC_Google_Portal_Directory_Sync_Same_Account_Different_Portals.rb" "TS_XMSLight/TC_Google_Portal_Directory_Sync_Change_Organization_Units.rb" "TS_XMSLight/TC_Google_Portal_Directory_Sync_Positive_Testing.rb" "TS_XMSLight/TC_Google_Portal_Directory_Sync_Invalid_User.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+chrome+xms+admin+eight@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_XMSLight/TC_Create_Default_Duplicate_Delete_Profiles.rb" "TS_XMSLight/TC_Create_All_Types_Of_Portals.rb" "TS_XMSLight/TC_Create_Guests_Self_Reg_Verify_Max_Limit.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+xms+light+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done
		for testToRun in "TS_XMSLight/TC_Import_Users_Verify_Max_Limit.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username adinte+automation+xms+light+chrome@macadamian.com --password Qwerty1@ --browser_name $browser
		done
	;;
	"TS_XMSUser")
		for testToRun in "TS_XMSUser/TC_Put_In_Out_Of_Service_Not_Disabled.rb" "TS_XMSUser/TC_XMSUser_Create_Default_Duplicate_Delete_Profiles.rb" "TS_XMSUser/TC_Create_Duplicate_Delete_Portals.rb" "TS_XMSUser/TC_Create_Favorite_Duplicate_Delete_Reports.rb" "TS_XMSUser/TC_Verify_Settings_Command_Center_Tab_Not_Visible.rb"
		do
			ruby run_spec.rb --spec $testToRun --release_id $release --testcycle_id $environment --skip_api true --username xmsuser+automation+xms+user@xirrus.com --password Qwerty1@ --browser_name $browser
		done
	;;
	esac