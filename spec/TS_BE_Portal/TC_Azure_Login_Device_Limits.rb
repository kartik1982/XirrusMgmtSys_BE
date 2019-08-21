require_relative "../context.rb"
require_relative "./local_lib/supportmgmt_lib.rb"
################################################################################################################
##########################TEST CASE: Azure Login - Add device limits############################################
################################################################################################################

SPECIAL_AZURE_ACCOUNT_CREDENTIALS = {
  email: "simon-admin@alexxirrusoutlook.onmicrosoft.com", # Armen.Zakaryan@alexxirrusoutlook.onmicrosoft.com
  password: "Xirrus!23"
}
PORTAL = {name: "Microsoft Azure", type: "AZURE_AD"}
PROFILE = "8_23_AZURE"
GAP = "8_23_AZURE_GAP"
users = [
  {email: "armen.zakaryan@alexxirrusoutlook.onmicrosoft.com", password: "Xirrus123"}
]

describe "*********TEST CASE: Azure Login - Add device limits************" do

  include_context "gap splash setup", {profile_name: PROFILE, gap_name: GAP, gap_type: PORTAL[:type], serial: "use current serial", device_mac: "use current device_mac", mac: "use current mac"}

  context "Azure Add and Verify Max Number of Devises" do
    include_examples "GAP Max Devices", {users: users, maxDeviceCount: 2, portal_type: PORTAL[:type]}, GAP
  end

  # Make cleanup
  after :all do |scenario| gap_splash_cleanup(PROFILE, GAP) end

end

