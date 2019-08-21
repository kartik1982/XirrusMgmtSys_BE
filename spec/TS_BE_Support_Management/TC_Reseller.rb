require_relative "../context.rb"
require_relative "./local_lib/supportmgmt_lib.rb"
################################################################################################################
############################TEST CASE: Add reseller as an admin############################################
################################################################################################################

if RSpec.configuration.spec_settings[:env] == "test03"
  tenant = {
    name: "RESELLER-TEST-03",
    sfdc_id: "001W000000OZs3u"
  }
  user = {
    email: "reseller_test_user_test03@yopmail.com",
    firstName: "rs_user_name",
    lastName: "rs_user_surename",
    roles: ["ROLE_XMS_ADMIN"]
  }
  reseller = {
    email: "reseller_partner_cloud_test03@yopmail.com",
    firstName: "Reseller name",
    lastName: "Reseller last name",
    roles: ["ROLE_MSP_ADMIN"]
  }
  ap = {
    serial: "RESELLER003"
  }
else
  tenant = {
    name: "RESELLER-TEST-01",
    sfdc_id: "001W000000NpYb6"
  }
  user = {
    email: "reseller_test_user@yopmail.com",
    firstName: "rs_user_name",
    lastName: "rs_user_surename",
    roles: ["ROLE_XMS_ADMIN"]
  }
  reseller = {
    email: "reseller_partner_cloud@yopmail.com",
    firstName: "Reseller name",
    lastName: "Reseller last name",
    roles: ["ROLE_MSP_ADMIN"]
  }
  ap = {
    serial: "RESELLER001"
  }
end

describe "******TEST CASE: Add reseller as an admin**************" do
  context "new reseller" do
  before :all do
    # Remove tenant, users and AP from XMS if any.
    res_del_ten = @ng.delete_tenant_if_name_or_erp_exists(tenant[:name])
    res_del_ap = @ng.delete_array_by_serial(ap[:serial])
    res_del_user = @ng.delete_user_by_email(user[:email])
    res_del_reseller = @ng.delete_user_by_email(reseller[:email])
  end

    it "Add New tenant from API" do 
       puts "Add tenant from API"
       res = @ng.post("/tenants.json/", {name: tenant[:name], erpId: tenant[:sfdc_id], products: ["MSP"]})
       log_body(res.body)
       expect(res.code).to eql(200)
       @@tenant_id = res.body['id']
     end
     it "add new user from API" do
       puts "Add user from API"
       res = @ng.add_user_for_tenant(@@tenant_id, user)
       expect(res.code).to eql(200)
     end
     it "add new reseller from API" do
       puts "Add reseller from API"
       res = @ng.add_user_for_tenant(@@tenant_id, reseller)
       expect(res.code).to eql(200)
     end
     it "add ap from API" do
       puts "Add Array from API"
       xirrus_array = @ng.add_array([serialNumber: ap[:serial], baseMacAddress: "00:0f:7d:11:22:33", baseIapMacAddress: "00:0f:7d:11:22:44", hostName: ap[:serial], arrayModel: "XR620", licensedAosVersion: "9.9"])
     end
     it "get ap for tenant" do
       puts "get ap for tenant"
       get_arrays_for_tenant_res = @ng.get("/tenants.json/#{@@tenant_id}/arrays")
       expect(get_arrays_for_tenant_res.code).to eql(200)
     end #it   
     
  end # Context
end # describe