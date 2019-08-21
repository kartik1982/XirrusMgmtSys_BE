###########################################
############# LOGIN ATTEMPTS ##############
###########################################
shared_examples "trigger incorrect login attempts" do |max_attempts, expect_error=false|
  it "try #{max_attempts} wrong attempts" do
    max_attempts.times do |attempt|
      @ui.login(@login_url, @username, "#{@password}_#{attempt}", true)
      sleep 2
      error_msg = @ui.div(class: "error").text

      expect(error_msg).to include("You have entered an invalid username and/or password. Please check your spelling and try again.")
    end
  end

  if expect_error
    it "Username locked after max failed login attempts" do
      @ui.login(@login_url, @username, "#{@password}_#{max_attempts + 1}", true)
      sleep 1
      error_msg = @ui.div(class: "error").text
      expect(error_msg).to include("The maximum number of login attempts has been exceeded for this user. Please wait a while before trying again.")
    end
  end
end

shared_examples "reset user login attempts" do
  it "Reset User login attempts" do
    reset_user_login_attempts()
    sleep 8
  end
end

shared_context "UI: Verify Message" do |opt|
  it " Notification Popup message correctness" do
    @browser.refresh
    sleep 8
    @ui.main_container.wait_until_present
    sleep 12

    popup_containers = @browser.divs(css: ".toast-warning")
    #popup_container.wait_until_present
    sleep 2
    popup_container = popup_containers[-1]

    sleep 2
    title = popup_container.div(css: ".toast-title").text
    message = popup_container.div(css: ".toast-message").text
    startDate = popup_container.div(class: "toast-timestamp-posted").span(:index, 1).text
    endDate = popup_container.div(class: "toast-timestamp-expiry").span(:index, 1).text
    expect(message).to include(@@system_message["message"])
    expect(title).to eql(@@system_message["title"])
  end
end

shared_examples "API: Verify Message" do
  it "Message has been added" do
    expect(@@system_message.code).to eql(200)
    @@system_message = @@system_message.body
  end
end

shared_examples "Remove and verify Message has been removed" do
    it "Remove Message" do
      remove_messages([@@system_message]) if @@system_message
    end
end

def remove_messages(messages)
  messages.each do |msg|
    @ng.delete_system_message(msg["id"])
  end
end

def clean_up
  # Delete Tenant if exist
  @ng.delete_tenant_if_name_or_erp_exists(TENANT_8_12_0[:name])
  # Delete User if exist
  @ng.delete_user_by_email(USER_8_12_0[:email])
  # Delete Circle
  @ng.delete_circle_by_name(CIRCLE[:name])
  # Delete AOS Box By Name
  @ng.delete_box_by_name(AOS_BOX[:name])
end

def add_minutes_to_current_date(m = 0)
  (Time.new + (m * 60)).to_time.to_i
end