require_relative "../context.rb"
require_relative "./local_lib/supportmgmt_lib.rb"
################################################################################################################
##############TEST CASE: Make customer aware of scheduled service to cloud#############################################
################################################################################################################

TENANT_8_12_0 = {
  name: "TEST_TENANT_8_12_0",
  erpId: "TEST_TENANT_8_12_0",
  products: ["XMS","BACKOFFICE"],
  suspended: false,
  description: "Test Tenant for 8.12.0",
  brand: "XIRRUS"
}

AOS_BOX = {
  "name": "8.12.0",
  "description": "test box for 8.12.0",
  "circleCount": 0,
  "mainlineDefaultAosVersionId": nil,
  "mainlineDefaultAosVersionName": nil,
  "versionRestrictions": []
}

CIRCLE = {
  "name": "8.12.0",
  "description": "circle for 8.12.0",
  "boxName": "8.12.0",
  "tenantCount": "1",
  "boxId": ""
}

USER_8_12_0 = {
  firstName: "test_user",
  lastName: "12_8_0",
  password: {"value": "Xirrus!23", "isSet": true},
  email: "test_user_12_8_0@yopmail.com",
  roles: ["ROLE_BACKOFFICE_SUPER_ADMIN", "ROLE_XMS_ADMIN"],
  status: "ACTIVE",
  showWelcome: false,
  forceResetPassword: false,
  acceptedEula: false,
  tenantUsers: [],
  showWhatsNew: true,
  tenantIsSuspended: false,
  tenantExpired: false
}

MESSAGE = {
  "circleId": nil,
  "startDate": add_minutes_to_current_date(0),
  "endDate": add_minutes_to_current_date(60),
  "title": "XMS-Cloud System - XMS Automation TEST Message",
  "severity": "WARNING",
  "message": "Hey!!! You are seeing the test Warrning Message created by AUTHOMATION ENGENEER",
  "tenantIds": [],
  "brand":"XIRRUS",
  "messageType": "SYSTEM"
}

describe "*************Make customer aware of scheduled service to cloud*************" do

  before :all do

    clean_up()
    # Create new Tenant and User
    @_tenant = @ng.add_tenant(TENANT_8_12_0)
    expect(@_tenant.code).to eql(200)
    @_tenant = @_tenant.body
    @_user = @ng.add_user(USER_8_12_0).body
    # Add user to the new tenant
    @ng.add_user_for_tenant(@_tenant["id"], @_user)
    # Remove User from curent tenant
    @ng.delete_user_for_current_tenant(@_user["id"])

    MESSAGE[:tenantIds] = [@_tenant["id"]]

    # Add AOS-Box
    @_box = @ng.add_box(AOS_BOX).body
    # Add Circle
    CIRCLE[:boxId] = @_box["id"]
    @_circle = @ng.add_circle(CIRCLE).body
    # Assign tenant to circle
    @ng.tenants_to_circle(@_circle["id"], [@_tenant["id"]])


    @browser = Watir::Browser.new @browser_name.to_sym
    @ui = GUI::UI.new(browser: @browser)
    sleep 5
    @ui.login(@login_url, @_user["email"], @password)
    sleep 2

  end

  context "Add system message from API and verify" do
    it "Add message" do
      @@system_message = @ng.add_system_message(MESSAGE)
    end

    include_examples "API: Verify Message"

    include_context "UI: Verify Message"

    include_examples "Remove and verify Message has been removed"
  end

  context "List notification message history" do
    it "verify notification message list" do
      puts "Add 3 messages and verify"
      messages = []
      (0..2).each do |i|
        MESSAGE[:message] = "Test Message number: #{i}, for List Notification History"
        messages << @ng.add_system_message(MESSAGE).body
        expect(messages.to_json).to include(MESSAGE[:message])
      end
      remove_messages(messages)
    end
  end

  context "Edit Message" do
    it "Add and verify that the message has been added" do
      MESSAGE[:message] = "This is the new test message."
      @@system_message = @ng.add_system_message(MESSAGE)
    end

    include_examples "API: Verify Message"

    it "Update the message" do
      MESSAGE[:message] = "This is an updated test message."
      resp = @ng.update_system_message(@@system_message["id"], MESSAGE)

      expect(resp).to include("System Message updated")

      @@system_message = @ng.get_system_message(@@system_message["id"])
    end

    include_examples "API: Verify Message"

    include_examples "Remove and verify Message has been removed"
  end

  context "API - post message to list of admin in a tenant circle" do
    it "Check that only accounts in the specified circle will get posted maintenance message" do
      MESSAGE[:message] = "TEST CIRCLE MESSAGE POST"
      MESSAGE[:tenantIds] = []
      #MESSAGE[:circleId] = @_circle["id"]
      @@system_message = @ng.add_system_message(MESSAGE)
    end

    include_examples "API: Verify Message"

    include_examples "Remove and verify Message has been removed"
  end


  after :all do
    @browser.quit
    clean_up()
  end

  # Make sure to do a cleanup in case at least one test fails
  after do |scenario|
    if scenario.exception
      @browser.quit
      clean_up()
    end
  end

end # describe US