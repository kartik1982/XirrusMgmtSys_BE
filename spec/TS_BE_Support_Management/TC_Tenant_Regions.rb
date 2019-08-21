require_relative "../context.rb"
require_relative "./local_lib/supportmgmt_lib.rb"
################################################################################################################
###########################TEST CASE: Add support for tenant region############################################
################################################################################################################

if RSpec.configuration.spec_settings[:env] == "test03"
tenant = {
  name: "REGION_TEST_03",
  erp_id: "001W000000LWqVk"
}
user = {
  email: "region_test_03@yopmail.com"
}
else
  tenant = {
    name: "REGION_TEST",
    erp_id: "001W000000NYbr7IAD"
  }
  user = {
    email: "region_test@yopmail.com"
  }
end
regions = ["NORTH_AMERICA", "EMEA", "LATIN_AMERICA", "APJ"]

shared_context "Api" do |region, current_region|
  context "Api - add new tenant w/ region #{region}" do
    it "delete old tenant if any, before start test" do
      res_del_ten = @ng.delete_tenant_if_name_or_erp_exists(tenant[:name])
    end
    it "Update API Account '#{@api_account}' region to be #{region}" do
      #Update API Account Region
      res = @ng.add_tenant({name: tenant[:name], erpId: tenant[:erp_id], products: ["XMS"], region: region})
      expect(res.code).to eql(200)
    end
    it "Go to backoffice API-doc and Search for tenant region to be set #{region}" do
      res = @ng.tenant_by_name(@api_account)
      xms_region = res.body["data"][0]["region"].downcase
      xms_region.gsub!(' ')
    end #it
  end # context END
end # shared context END
describe "*************TEST CASE: Add support for tenant region************" do
  before :all do
  @api_account = tenant[:name]
  end
  regions.each do |region|
    include_context "Api", region
  end
end # describe US