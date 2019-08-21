require_relative "../context.rb"
require_relative "./local_lib/supportmgmt_lib.rb"
################################################################################################################
##########################TEST CASE: Security Audit - Prevent user login brute-force############################
################################################################################################################
# Have to provide secondary account to reset the lock time period.
BACKOFFICE_PROFILE = {
  email: "xmsc.auto@gmail.com",
  tenant: "TEST_01_XR-620_1"
}

MAX_ATTEMPTS = 5

describe "*********TEST CASE: Security Audit - Prevent user login brute-force***********" do

  before :all do
    @_ng = API.api({tenant: BACKOFFICE_PROFILE[:name], username: BACKOFFICE_PROFILE[:email], env: @env, password: "Xirrus!23"})
  end

  after :all do
    puts "CleanUP max user login attemp"
    reset_user_login_attempts()
  end

  context "Username lock time period" do
    include_examples "trigger incorrect login attempts", MAX_ATTEMPTS, true

    it "Wait 1 hour to check for Username lock time period" do
      # the rate at which attempts are restored will be 1 every 5 minutes, with the maximum number of attempts being 5. (So it will take 25 minutes for an account to 'reset' fully).
      UTIL.wait_helper(3800, "username lock time", "checking whether account is unlocked", 10)
      sleep 2
    end

    it "Try login with correct username and password and Verify that login is successful" do
      @ui.login(@login_url, @username, @password)
      sleep 2
    end
  end

  context "Unlock username" do
    include_examples "trigger incorrect login attempts", MAX_ATTEMPTS, true

    include_examples "reset user login attempts"

    it "Try login with correct username and password and Verify that login is successful" do
      @ui.login(@login_url, @username, @password)
      sleep 1
    end
  end

  context "Password reset should reset login attempts" do
    include_examples "trigger incorrect login attempts", MAX_ATTEMPTS, true

    it "reset password and verify it resets login attempts" do
      temp_pass = "#{@password}_temp"
      resp = @_ng.update_users_password_by_e_mail({email: @username, password: temp_pass})
      expect(resp.body).to include("Password updated")

      puts "Change Password in UI and try to l"
      @ui.login(@login_url, @username, temp_pass, true)

      sleep 4

      @browser.text_field(name: "j_currentpassword").set(temp_pass)
      @browser.text_field(name: "j_newpassword").set(@password)
      @browser.text_field(name: "j_newpassword_confirm").set(@password)
      sleep 1
      @ui.input(css: ".button.submitBtn").click
      sleep 1
      @ui.main_container.wait_until_present
      expect(@ui.main_container.present?).to be true
    end

    it "Try login with correct username and password and Verify that login is successful" do
      @ui.login(@login_url, @username, @password)
      sleep 2
    end
  end

  context "Successful login resets number of login attempts" do
    include_examples "trigger incorrect login attempts", MAX_ATTEMPTS - 1

    it "Try login with correct username and password and Verify that login is successful" do
      @ui.login(@login_url, @username, @password)
      sleep 2
    end

    include_examples "trigger incorrect login attempts", MAX_ATTEMPTS, true

    it "Use API to reset wrong number of login attempts" do
      resp = @_ng.reset_user_login_attempts_by_email_address(@username)
      expect(resp.body).to include("User login attempts have been reset")
    end

  end

end # describe