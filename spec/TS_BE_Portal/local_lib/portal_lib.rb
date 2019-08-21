#shared_context "GuestPortalView"
require_relative '../api_client/context.rb'
require_relative "../profiles/context.rb"


def header_left_nav
  @ui.id("header_left_nav")
end

def header_guests
  @ui.id("header_nav_guestportals")
end

def view_all_guestportals_link
  #@browser.a(id: "view_all_nav_item")
  @browser.span(text: "View All Portals")
end

def header_new_portal_btn
  @ui.a(id: "header_new_guestportals_btn")
end

def random_title_url
  "#{@ui.random_title.gsub('_','-').downcase}.com"
end

# NEW GUEST PORTAL MODAL
def newportal_modal
  @ui.div(id: "guestportals_newportal")
end

def newportal_closemodalbtn
  newportal_modal.a(id: "guestportals_newportal_closemodalbtn")
end

def new_self_btn
  @ui.a(css: ".portal_type.self_reg")
end

def new_ambassador_btn
  @ui.a(css: ".portal_type.ambassador")
end

def new_name_field_id
  "guestportal_new_name_input"
end

def new_desc_field_id
  "guestportal_new_description_input"
end

def create_new_portal(args = {})
  @ui.create_gap(args)
end

def goto_all_guestportals_view
  header_left_nav.wait_until_present
  header_guests.wait_until_present
  header_guests.click
  sleep 1
  view_all_guestportals_link.wait_until_present
  view_all_guestportals_link.click
end

def goto_portal(name)
  goto_all_guestportals_view
  sleep 5
  tile = @ui.gpv.tile(name)
  tile.wait_until_present
  tile.fire_event("onmouseover")
 # tile.fire_event("onclick")
  tile.element(text: name).fire_event("onclick")
  sleep 2
  @browser.a(text: "Save All").wait_until_present
end

def goto_guests_tab
  @ui.id("profile_tabs").wait_until_present
  @ui.id("profile_tabs").div(text: "Guests").wait_until_present
  @ui.id("profile_tabs").div(text: "Guests").click
  expect_no_error
  @ui.div(css: ".manageguests_grid_container.base_grid").wait_until_present
  expect_no_error
end

def add_new_guest(args = {})
  name = args[:name] || ""
  email = args[:email] || ""
  new_guest_btn.wait_until_present
  new_guest_btn.click
  @ui.set_text_field_by_id("guestmodal_name_input", name)
  @ui.set_text_field_by_id("guestmodal_email_input", email)
  @ui.div(text: "Save & Send Password").click
  @ui.id("guestambassador_guestpassword").wait_until_present
  @ui.div(text: "THANKS! Close window").wait_until_present
  @ui.div(text: "THANKS! Close window").click
end

def chars_256
  "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis,."
end

def url_longer_than_256
  "#{XMS.random_title.gsub(' ','-')}#{chars_256.gsub(' ','-').gsub('.','-').gsub('_','-').gsub(',','')}.com"
end

def goto_config_view(viewname)
  @ui.guest_portal_config_view.wait_until_present
  icon = @ui.guest_portal_config_view.tile(viewname)
  icon.wait_until_present
  icon.click
  sleep 3
  @ui.id("guestportal_config_#{viewname}_view").wait_until_present
end

def innertab_content
  @ui.div(css: ".innertab_content")
end

def name_field_id
  "guestportal_config_basic_guestportalname"
end

def description_field_id
  "guestportal_config_basic_description"
end

def description_textarea
  @ui.textarea(id: "guestportal_config_basic_description")
end

def session_expiration_heading
  @ui.id("guestportal_config_general_expiration_heading")
end

def session_expiration_info_btn
  session_expiration_heading.div(css: ".infoBtn")
end

def session_expiration_tooltip_text
  "Changes to this setting will be applied to the new guests going forward. Existing guests will not be altered."
end

def session_expiration_field_div
  @ui.id("guestportal_config_general_expiration")
end

def session_expiration_togglebox_heading
  session_expiration_field_div.span(css: ".togglebox_heading")
end

def session_expiration_togglebox_subheading
  session_expiration_field_div.span(css: ".togglebox_heading.subheading")
end

def session_expiration_dl
  session_expiration_field_div.span(id: "general_expiration_days")
end

def session_expiration_dl_btn
    session_expiration_dl.a(css: ".ko_dropdownlist_button")
end

def session_expiration_options
  ["15 minutes", "1 hour", "1 day", "1 month", "End of Day (midnight)", "End of week (saturday)", "Forever", "Custom"]
end

def set_session_expiration(option)
 session_expiration_dl_btn.click
 dd = @ui.dd_active
 li = dd.li(text: option)
 li.wd.location_once_scrolled_into_view
 li.click
end

def current_expiration_option
  session_expiration_dl_btn.span(css: '.text').text
end

def session_timeout_heading
  @ui.div(text: "Session Timeout")
end

def session_timeout_field_div
  @ui.id("guestportal_config_general_timeout")
end

def session_timeout_heading
  session_timeout_field_div.span(css: ".togglebox_heading")
end

def session_timeout_highlight
  session_timeout_heading.span(css: ".highlight")
end

def session_timeout_switch_id
  "has_timeoutSwitch_switch"
end

def toggle_session_timeout(value)
  val = false
  if(value == true || value == "yes" || value == "Yes" || value == "YES")
    val = true
  end
  @ui.ng_toggle_set(session_timeout_switch_id, val)
end

def session_timeout_duration_field_id
  "guestportal_config_basic_timeout"
end

def session_duration_label
  session_timeout_field_div.span(text: "Duration before timeout:")
end

def session_timeout_duration_dl
  session_timeout_field_div.span(id: "guestportal_config_general_timeouttype")
end

def session_timeout_duration_dl_btn
  session_timeout_duration_dl.a(css: ".ko_dropdownlist_button")
end

def session_timeout_duration_options
  [ "Minutes","Hours","Days"]
  [{set_val: "61", expected_val: "60", opt: "Minutes"}, {set_val: "61", expected_val: "24", opt: "Hours"}, {set_val: "1000", expected_val: "999", opt: "Days"}]
end

def set_session_timeout(duration, timeframe)
  toggle_session_timeout("YES")
  session_timeout_duration_dl_btn.click
  dd = @ui.dd_active
  li = dd.li(text: timeframe)
  li.wd.location_once_scrolled_into_view
  li.click
  sleep 2
  @ui.set_text_field_by_id(session_timeout_duration_field_id, duration)
end

def landing_heading
  @ui.div(text: "Landing")
end

def landing_section
  @ui.input(id: landingpage_field_id).parent.parent.parent
end

def landing_section_text
  landing_section.span(css: ".togglebox_heading").text
end

def landingpage_field_id
  "landingpage"
end

def set_landingpage(url)
  @ui.set_text_field_by_id(landingpage_field_id, url)
end

def leave_landing_field
  @ui.text_field(id: landingpage_field_id).fire_event("onblur")
end

def expect_landing_url_error(type=nil)
  type = type || :general
  error_types = { protocol: "Please include a valid url protocol.", general: "Please enter a valid url."}
  sleep 2
  expect(landing_section.span(css: ".xirrus-error")).to be_visible
  expect(landing_section.span(text: error_types[type]).present?).to eql(true)
end

def expect_no_landing_url_error
  sleep 2
  expect(landing_section.span(css: ".xirrus-error")).to_not be_visible
  expect(landing_section.span(text: "Please include a valid url protocol.").present?).to eql(false)
end

def require_sponsor_switch_id
  "has_sponsor_switch"
end

def toggle_require_sponsor(value)
  val = false
  if(value == true || value == "yes" || value == "Yes" || value == "YES")
    val = true
  end
  @ui.ng_toggle_set(require_sponsor_switch_id, val)
end

def sponsor_email_field_id
  "new_sponsor_item"
end

def add_sponsor_btn
  @ui.a(id: "add_sponsor_item")
end

def add_sponsor(sponsor_email_address)
  @ui.set_text_field_by_id(sponsor_email_field_id, sponsor_email_address)
  add_sponsor_btn.click
end

def sponsor_list
  @ui.id("guestportal_config_general_sponsors")
end

def sponsor_items
  sponsor_list.lis
end

def current_sponsors
  sponsor_items.map{|s| s.text}
end

def delete_sponsor_item(value)
  item = sponsor_items.select{|l| l.text == value}
  li = item[0]
  li.wd.location_once_scrolled_into_view
  li.hover
  li.a(css: ".deleteIcon").wait_until_present
  li.a(css: ".deleteIcon").fire_event("click")
  sleep 1
  @browser.div(css: ".dialogOverlay.confirm.top").wait_until_present
  box = @browser.div(css: ".dialogOverlay.confirm.top")
  box.a(text: "Delete").click
end

def sponsor_types
  ["Manual Confirmation", "Auto-Confirmation"]
end

def sponsor_type_dl
  @browser.span(id: "guestportal_config_basic_autoAcceptSponsor")
end

def sponsor_type_dl_btn
  sponsor_type_dl.a(css: ".ko_dropdownlist_button")
end

def set_sponsor_type(sponsor_type)
  sponsor_type_dl_btn.click
  dd = @ui.dd_active
  li = dd.li(data_value: sponsor_type)
  li.wd.location_once_scrolled_into_view
  li.click
end

def current_sponsor_type
  sponsor_type_dl.span(css: ".text").text
end

def guestportal_general_config_advanced_link
  @ui.id("general_show_advanced")
end

def show_general_advanced
  guestportal_general_config_advanced_link.wait_until_present
  if guestportal_general_config_advanced_link.text.include?"Show"
    guestportal_general_config_advanced_link.click
  end
end

def hide_general_advanced
  guestportal_general_config_advanced_link.wait_until_present
  if guestportal_general_config_advanced_link.text.include?"Hide"
    guestportal_general_config_advanced_link.click
  end
end

def whitelist_heading
  @ui.div(text: "Whitelist")
end

def whitelist_togglebox
  @ui.id("whitelist_switch").parent
end

def whitelist_togglebox_heading
  whitelist_togglebox.span(css: ".togglebox_heading")
end

def whitelist_switch_id
  "whitelist_switch_switch"
end

def set_whitelist_switch(value)
  val = false
  if(value == true || value == "yes" || value == "Yes" || value == "YES")
    val = true
  end
  @ui.ng_toggle_set(whitelist_switch_id, val)
end

def new_whitelist_item_id
  "new_whitelist_item"
end

def new_whitelist_input
  whitelist_togglebox.input(id: "new_whitelist_item")
end

def whitelist_add_btn
  whitelist_togglebox.button(id: "add_whitelist_item")
end

def add_whitelist_item(url_or_ip)
  @ui.set_text_field_by_id(new_whitelist_item_id, url_or_ip)
  whitelist_add_btn.click
end

def general_whitelist
  @ui.id("guestportal_config_general_whitelist")
end

def whitelist_items
  general_whitelist.lis
end

def delete_whitelist_item(value)
  item = whitelist_items.select{|l| l.text == value}
  li = item[0]
  li.wd.location_once_scrolled_into_view
  li.hover
  delete_btn = li.button(css: '.deleteIcon')
  delete_btn.wait_until_present
  delete_btn.fire_event("click")
  dialog = @browser.div(css: ".dialogOverlay.confirm.top")
  dialog.wait_until_present
  dialog.a(text: "Delete").click
end

def goto_general_config
  goto_config_view("general")
  @ui.element(text: "Guest Portal Name:").wait_until_present
  @ui.element(text: "Description:").wait_until_present
  @ui.element(text: "Session Expiration").wait_until_present
  @ui.element(text: "Session Timeout").wait_until_present
end

def goto_lookfeel_config
  goto_config_view("lookfeel")
  @browser.div(text: "Design the pages guests will see.").wait_until_present
  @ui.id("guestportal_config_lookfeel_logobutton").wait_until_present
  @ui.id("guestportal_config_lookfeel_customtext_input").wait_until_present
end

def select_image_btn
  @ui.a(text: "Select Image")
end

def gallery_modal
  @ui.div(id: "gallery_modal")
end

def upload_new_image_btn
  gallery_modal.span(text: "Upload new image...")
end

def image_input
  gallery_modal.file_field(id: "gallery_image_input")
end

def upload_logo(filepath)
  puts "filepath : #{filepath}"
  select_image_btn.wait_until_present
  select_image_btn.click
  gallery_modal.wait_until_present
  upload_new_image_btn.wait_until_present
  sleep 1
  @browser.file_field(id: "gallery_image_input").set(filepath)
  sleep 1
 # upload_new_image_btn.click
  sleep 1
 # @browser.send_keys :enter
 @ui.id("image0").click
 @browser.a(text: "OK").click
end

def goto_ssids_config
  goto_config_view("ssids")
  @ui.id("ssid_addnew_btn").wait_until_present
end

def ssid_add_modal
  @ui.id("ssid_add_modal")
end

def ssid_filter
  @ui.id("ssid_filter")
end

def move_btn
  @ui.a(text: "Move")
end

def ssid_modal_move_btn
  @ui.id("ssids_add_modal_move_btn")
end

def ssid_modal_moveall_btn
  @ui.id("ssids_add_modal_moveall_btn")
end

def ssid_modal_remove_btn
  @ui.id("ssids_add_modal_remove_btn")
end

def ssid_modal_removeall_btn
  @ui.id("ssids_add_modal_removeall_btn")
end

def ssid_modal_select_profile( profile_name="All" )
  ssid_filter.a(css: ".ko_dropdownlist_button").wait_until_present
  ssid_filter.a(css: ".ko_dropdownlist_button").click
  sleep 2
  ul =  @ui.dd_active.ul

  if profile_name == "All"
    ul.li(text: "View All SSIDs").wd.location_once_scrolled_into_view
    ul.li(text: "View All SSIDs").click
  else
    ul.li(xpath: "//li[@data-value='#{profile_name}']").wd.location_once_scrolled_into_view
    ul.li(xpath: "//li[@data-value='#{profile_name}']").click
  end
end


def select_ssids( names = [] )
  div = ssid_add_modal.div(css: ".select_list.sortable.scrollable")
  div.wait_until_present
  ul = div.ul
  names.each {|name|
    li = ul.li(text: name)
    li.wd.location_once_scrolled_into_view
    li.click
    sleep 1
    ssid_modal_move_btn.click
    sleep 1
  }
 # ssid_modal_move_btn.click
end

def assign_ssids(profile_name = "All", names = [] )
  btn = @ui.id("ssid_addnew_btn")
  btn.wait_until_present
  btn.click
  sleep 10
  ssid_modal_select_profile( profile_name )
  select_ssids(names)
  sleep 1
  @ui.a(text: "Assign SSIDs").click
  ssid_add_modal.wait_while_present
end

def assign_ssids_upsk(profile_name = "All", names = [])
    btn = @ui.id("ssid_addnew_btn")
    btn.wait_until_present
    btn.click
    sleep 10
    ssid_modal_select_profile( profile_name )
    select_ssids(names)
    sleep 1
    @ui.a(text: "Assign SSIDs").click

    sleep 1
    ## prompt for WPA when UPSK
    @ui.confirm_dialog
    sleep 1
    ssid_add_modal.wait_while_present
end

def select_all_gap_ssid
  @ui.th(css: ".nssg-th-select").label.wait_until_present
  @ui.th(css: ".nssg-th-select").label.click
end

def new_guest_btn
  @ui.id("manageguests_addnew_btn")
end

def goto_gap(gap)
  goto_portal(gap)
end

#################################################
shared_context "guestportals setup" do

  include_context "profiles"

  before :all do
    goto_all_guestportals_view
    sleep 7
  end

  let(:gpv){@ui.gpv}
end # guestportals setup
###################################################

###################################################
shared_context "auto-ambassador setup" do

  before :all do
   goto_portal("auto-ambassador")
  end

  let(:view){@ui.guest_portal_config_view}
end

shared_context "ambassador portal setup" do |title|

  before :all do
   goto_portal(title)
  end

  let(:view){@ui.guest_portal_config_view}
end

shared_context "portal setup" do |title|

  before :all do
   goto_portal(title)
  end

  let(:view){@ui.guest_portal_config_view}
end

def simulated_splash_page(args = {})
  "https://guest-#{@env}.cloud.xirrus.com/?challenge=1&uamip=#{args[:uamip]}&uamport=#{args[:uamport]}&apmac=#{args[:apmac]}&mac=#{args[:mac]}&userurl=http://www.google.com&ssid=#{args[:ssid_name]}"
end

def generic_login(u,p)
  text_fields = @browser.text_fields
  text_fields[0].send_keys u
  text_fields[1].send_keys p
  @browser.links[0].click
end

def facebook_login(b, u=nil, p=nil)
  u = u || "armen.zakaryan@xirrus.com"
  p = p || @password
  text_fields = b.text_fields

  text_fields[0].send_keys u
  text_fields[1].send_keys p

  # Have to check for several log in FB buttons
  if b.button(id: "loginbutton").present?
    fb_btn = b.button(id: "loginbutton")
  elsif b.input(id: "u_0_2").present?
    fb_btn = b.input(id: "u_0_2")
  end

  fb_btn.click
end

def google_login(b, u=nil, p=nil)
  u = u || "xmsc.auto@gmail.com"
  p = p || @password
  sleep 8
  e_block = b.text_field(id: "identifierId")
  e_block.wait_until_present
  e_block.send_keys u
  b.span(text: "Next").click
  sleep 8
  p_block = b.div(id: "password")
  p_block.wait_until_present
  p_block.input.send_keys p
  sleep 1
  b.span(text: "Next").click
end


def new_device_splash(new_mac = nil)
  begin
  if new_mac.nil?
    new_mac = XMS.random_mac
  end
  browser = Watir::Browser.new @browser_name
  @splash_url = @splash_url.gsub(@device_mac, new_mac)
  browser.goto @splash_url
  sleep 1
  browser
  rescue => e
    "New device Splash Error: #{e.message}"
  end
end

def replace_splash_device_mac(new_mac)
  @splash_url.gsub(/&mac=([0-9A-Fa-f]{2}[:-]){5}([0-9A-Fa-f]{2})/, "&mac=#{new_mac}")
end

def verify_guest_today(gap_name, guest_email)
  goto_portal(gap_name)
  sleep 3
  goto_guests_tab
  sleep 2
  gap_config_view = @ui.guest_portal_config_view
  guests_grid = gap_config_view.guest_grid_view
  guest_row = guests_grid.row( guest_email.to_s )
  puts guest_row.activation_value
  puts Time.now.strftime('%-m/%-d/%Y')
  expect(guest_row.activation_value).to include(Time.now.strftime('%-m/%-d/%Y'))
end

def api_update_gap_config(gap_id, args = {})
  @ng = @ng || ngapi
  get_gap_config_res = @ng.gap_configuration(@gap_id)

  new_gap_config = get_gap_config_res.body
  puts "GAP config before args: "
  puts new_gap_config
  if !args.empty?
    args.each do |key,value|
      new_gap_config[key.to_s] = value
    end
  else
    puts "update gap args empty"
  end
 # new_gap_config['lookAndFeel'] = {}
  puts "GAP config after args: "
  puts new_gap_config
  update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
  expect(update_gap_config_res.body).to eql("\"Portal Configuration updated\"")

  @ng.gap_configuration(@gap_id).body
end


shared_context "combine portals gap splash setup" do |args = {}|

  base_title = args[:base_title] || XMS.random_title
  profile_name = args[:profile_name]
  ssid_name = args[:ssid_name]
  gap_name = args[:gap_name] || "GAP-#{base_title}"
  gap_type = "MEGA"
  args[:locale] = args[:locale] || "en_US"

  before :all do

    @gap_name = gap_name
    @profile_name = profile_name
    @ssid_name = ssid_name
    @gap_type = gap_type

    puts "CleanUp before setting up a new Gap Splash"
    gap_splash_cleanup(nil, @gap_name)

    @create_gap_res = @ng.add_gap({name: @gap_name, type: @gap_type })
    expect(@create_gap_res.code).to eql(200)
    @gap_id = @create_gap_res.body['id']

    res = @ng.get_profile_by_name(@profile_name)
    @profile_id = res["id"]

    res = @ng.get_profile_configuration_by_name(@profile_name)
    expect(res.code).to eql(200)
    @basic_profile_config = res.body
    @basic_profile_config['ssids'][0]['ssidName'] = @ssid_name
    @basic_profile_config['ssids'][0]["guestPortalId"] = @gap_id
    @basic_profile_config['ssids'][0]['enabled'] = true
    @basic_profile_config['ssids'][0]['broadcast'] = true
    @basic_profile_config['locale']['country'] = "US"
    res = @ng.update_profile_configuration(@profile_id, @basic_profile_config)
    expect(res.code).to eql(200)
    expect(res.body).to eql("\"Profile Configuration updated\"")

    res = @ng.gap_configuration(@gap_id)
    expect(res.code).to eql(200)
    new_gap_config = res.body
    new_gap_config["subPortals"] = args[:subportals].inject([]) do |arr, sub_portal|
      res = @ng.get_gap_by_name(sub_portal)
      arr << {label: sub_portal, subPortalId: res["id"]}
    end

    update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
    log_body(update_gap_config_res)
    expect(update_gap_config_res.code).to eql(200)
    expect(update_gap_config_res.body).to eql("\"Portal Configuration updated\"")

  end # before all
end # shared context gap splash setup

shared_context "gap splash setup" do |args = {}|

  guest = args[:guest]
  guest_social = args[:guest]
  base_title = args[:base_title] || XMS.random_title
  profile_name = args[:profile_name] || "PRO-#{base_title}"
  ssid_name = args[:ssid_name] || "SSID-#{base_title}"
  gap_name = args[:gap_name] || "GAP-#{base_title}"
  gap_type = args[:gap_type] || "SELF"
  facebook = args[:facebook] || false
  google = args[:google] || false
  args[:locale] = args[:locale] || "en_US"
  args[:allowed_domains] = args[:allowed_domains] || []


  before :all do
    @ng = @ng || ngapi
    @base_title = base_title
    # ip to simulate redirect back to AP
    @uamip = args[:uaimp] || GAP_REDIRECT_IP #facebook.com
    @uamport = "80"
    @array_ip = args[:array_ip] || GAP_REDIRECT_IP # facebook.com not used in XMS-Cloud, used for Splash page redirect simulation

    if args[:mac] && args[:mac] == 'use current mac'
      @array_mac = @array.mac
    else
      @array_mac = args[:mac] || XMS.random_mac
    end
    if args[:iap_mac] && args[:iap_mac] == 'use current iap_mac'
      @array_iap_mac = @array.iapmac
    else
      @array_iap_mac = args[:iap_mac] || XMS.random_mac
    end
    if args[:device_mac] && args[:device_mac] == 'use current device_mac'
      @device_mac = @array.mac
    else
      @device_mac = args[:device_mac] || XMS.random_mac
    end
    if args[:serial] && args[:serial] == 'use current serial'
      @array_serial = @array.serial
    else
      @array_serial = args[:serial] || XMS.random_serial
    end

    @gap_name = gap_name
    @profile_name = profile_name
    @ssid_name = ssid_name
    @gap_type = gap_type

    attemt = 0
    max_attemts = 10
    while attemt < max_attemts
      puts "CleanUp before setting up a new Gap Splash"
      gap_splash_cleanup(@profile_name, @gap_name)
      @create_gap_res = @ng.add_gap({name: @gap_name, type: @gap_type })
      unless @create_gap_res.code == 200
        attemt += 1
        sleep 3
      else
        attemt = 10
      end
    end

    expect(@create_gap_res.code).to eql(200)
    @gap_id = @create_gap_res.body['id']

    @create_profile_res = @ng.add_profile({name: @profile_name})
    expect(@create_profile_res.code).to eql(200)

    @profile_id = @create_profile_res.body['id']

    @basic_profile_config = JSON.parse(File.read("#{XMS.fixtures_root}/json/profiles/basic_profile_config.json"))

    @basic_profile_config['ssids'][0]['ssidName'] = @ssid_name
    @basic_profile_config['ssids'][0]["guestPortalId"] = @gap_id
    @basic_profile_config['ssids'][0]['enabled'] = true
    @basic_profile_config['ssids'][0]['broadcast'] = true
    @basic_profile_config['locale']['country'] = "US"

    arrays_to_add = []

    if args[:serial]
      res = @ng.array_by_serial(@array_serial)
      expect(res.code).to eql(200)
      @fake_array = res.body
    else
      arrays_to_add << {
        profileId: @profile_id,
        profileName: @profile_name,
        baseMacAddress: @array_mac, # each section reversed of X206414028170
        baseIapMacAddress: @array_iap_mac,
        serialNumber: @array_serial,
        arrayModel: "XR620",
        aosVersion: "10.2.0-5138",
        licenseKey: "NOT_A_REAL_LICENSE",
        licensedAosVersion: "10.2",
        location: "SQA XMS",
        hostName: @array_serial,
        activationStatus: "NOT_ACTIVATED",
        onlineStatus: "DOWN",
        country: "US"
      }

      @create_fake_array_res = @ng.add_arrays(arrays_to_add)

      log("\n\n\n ADD ARRAYS:")
      log_body(@create_fake_array_res)
      expect(@create_fake_array_res.code).to eql(201)
      @fake_array = @create_fake_array_res.body[0]
    end

    @array_id = @fake_array['id']
    @fake_array['profileId'] = @profile_id
    @fake_array['profileName'] = @profile_name
    @fake_array['arrayId'] = @array_id
    @update_array_res = @ng.update_array(@fake_array)
    expect(@update_array_res.code).to eql(200)
    expect(@update_array_res.body).to include("Array updated")

    puts "UPDATE ARRAY RES:"
    puts @update_array_res.body
    # @update_profile_configuration_res = @ng.update_profile_configuration(@profile_id, @basic_profile_config)
    @basic_profile_config['profileId'] = @profile_id

    @update_profile_configuration_res = @ng.create_or_update_profile_configuration(@basic_profile_config)
    log("\n\n\n UPDATE PROFILE CONFIG: ")
    log_body(@update_profile_configuration_res)
    expect(@update_profile_configuration_res.code).to eql(200)

    # puts @update_profile_configuration_res.body

    @splash_url = XMS.gap_splash_page({ env: @env, uamip: @uamip, uamport: @uamport, apmac: @array_mac, mac: @device_mac, ssid_name: @ssid_name})
    puts "SPLASH URL: #{@splash_url}"
    log("\n\n\n SPLASH URL: #{@splash_url}")
    log("Profile #{profile_name} has SSID #{ssid_name} and associated with guestPortalId for GAP #{gap_name}")
    log("\n\n\n Profile has SSID...")
    res = @ng.profile_configuration(@profile_id)
    log_body(res)
    expect(res.body['ssids'][0]['ssidName']).to eql(@ssid_name)
    expect(res.body['ssids'][0]['guestPortalId']).to eql(@gap_id)
    log("\n\n\n END Profile has SSID...")

    # "GET GAP - has SSID from correct Profile" do
    res = @ng.gap_by_id(@gap_id)
    expect(res.code).to eql(200)
    log("\n\n\nGET GAP")
    log_body(res)
    gap_ssids = res.body['ssids']

    expected_ssid = gap_ssids.select{|ssid| (ssid['profileId'] == @profile_id && ssid['ssidName'] == @ssid_name )}.first
    expect(expected_ssid).to_not be_nil
    log("\n\n\nEND GET GAP")

    if args[:facebook] == true
      # "UPDATE GAP Config to use Facebook signup" do
      log("\n\n\n UPDATE GAP to use Facebook")
      get_gap_config_res = @ng.gap_configuration(@gap_id)
      log_body(get_gap_config_res)
      new_gap_config = get_gap_config_res.body
      new_gap_config['authTimeout'] = 3
      new_gap_config['facebook'] = true
      update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
      log_body(update_gap_config_res)
      expect(update_gap_config_res.body).to eql("\"Portal Configuration updated\"")

      new_gap_config_res = @ng.gap_configuration(@gap_id)
      log_body(new_gap_config_res)
      expect(new_gap_config_res.body['facebook']).to eql(true)

      log("\n\n\n END UPDATE GAP to use Facebook")
    end

    if args[:google] == true
      # "UPDATE GAP Config to use Google signup" do
      log("\n\n\n UPDATE GAP to use Google")
      get_gap_config_res = @ng.gap_configuration(@gap_id)
      log_body(get_gap_config_res)
      new_gap_config = get_gap_config_res.body
      new_gap_config['authTimeout'] = 3
      new_gap_config['google'] = true

      update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
      log_body(update_gap_config_res)
      expect(update_gap_config_res.body).to eql("\"Portal Configuration updated\"")

      new_gap_config_res = @ng.gap_configuration(@gap_id)
      log_body(new_gap_config_res)

      expect(new_gap_config_res.body['google']).to eql(true)
      log("\n\n\n END UPDATE GAP to use Google")
    end

    # NEW CODE for NEW added options
    # TODO refactore old code to work similar to the new one
    get_gap_config_res = @ng.gap_configuration(@gap_id)
    log_body(get_gap_config_res)

    unless args[:allowed_domains].empty? || args[:gap_type] == "AZURE_AD"
      new_gap_config = get_gap_config_res.body
      new_gap_config['locale'] = args[:locale]
      new_gap_config['allowedDomains'] = args[:allowed_domains]

      update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
      log_body(update_gap_config_res)
      expect(update_gap_config_res.body).to eql("\"Portal Configuration updated\"")

      new_gap_config_res = @ng.gap_configuration(@gap_id)
      log_body(new_gap_config_res)

      expect(new_gap_config_res.body['locale']).to eql(args[:locale])
    end
  end # before all
end # shared context gap splash setup

###############################
### MARKETING OPT-IN HELPER ###
###############################
shared_context "Marketing OPT-IN" do |opt, gap_name|

  context "GAP Verify Marketing OPT_IN on guest Login page" do
    before :all do
      if opt[:new_opt_in_text] || opt[:marketing_opt_in_disabled]
        opt[:default_opt_in_text] = opt[:new_opt_in_text]
        puts "Update Marketing OPT-IN Text"
        data = {lookAndFeel: {useOptIn: false}}
        data[:lookAndFeel] = {useOptIn: true, optInText: opt[:new_opt_in_text]} if opt[:new_opt_in_text]
        update_gap_option(data, gap_name)
        sleep 8
      end

      @_browser = XMS.new_chrome_incognito()
      @_browser.goto replace_splash_device_mac(XMS.update_mac_by_number(@device_mac))
      sleep 2

      if opt[:external_sign_in] == "facebook"
        @_browser.div(id: "login_facebook").click
        sleep 3
        @register_form = @_browser.form(id: "facebook_mobile_form")
      elsif opt[:external_sign_in] == "google"
        @_browser.div(id: "login_google").click
        sleep 3
        @register_form = @_browser.form(id: "google_mobile_form")
      else
        container = @_browser.div(id: "splash_login_single")
        container.wait_until_present
        container.button(class: "registerBtn").click
        @register_form = @_browser.form(id: "register_form")
      end

      @register_form.wait_until_present
      el = @register_form.div(class: "optin_check_field")

      if opt[:marketing_opt_in_disabled]
        expect(el.present?).not_to be true
      else
        if opt[:external_sign_in] == "facebook"
          @marketing_opt_in_check_box = el.checkbox(id: "optin_check_facebook")
        elsif opt[:external_sign_in] == "google"
          @marketing_opt_in_check_box = el.checkbox(id: "optin_check_google")
        else
          @marketing_opt_in_check_box = el.checkbox(id: "optin_check_register")
        end
        @marketing_opt_in_text = el.label(class: "opt_in_text_label").text
      end

    end

    after :all do
      @_browser.quit unless @_browser.nil?
    end

    unless opt[:marketing_opt_in_disabled] || opt[:do_login]
      it "Verify that displayed client login page will show the new option Marketing OPT-IN checkbox" do
        expect(@marketing_opt_in_check_box.present?).to be true
      end

      it "It should be checked by default" do
        expect(@marketing_opt_in_check_box.checked?).to be false
      end

      it "Verify Marketing OPT_IN default Text" do
        expect(@marketing_opt_in_text).to include(opt[:default_opt_in_text])
      end

      it "Verify that clients can select or deslect the box." do
        @marketing_opt_in_check_box.set(false)
        expect(@marketing_opt_in_check_box.checked?).to be false

        @marketing_opt_in_check_box.set(true)
        expect(@marketing_opt_in_check_box.checked?).to be true
      end
    end

    if opt[:do_login]
      it "Register a user" do

        @marketing_opt_in_check_box.set(opt[:enable_marketing_opt_in]) if opt[:enable_marketing_opt_in]

        if opt[:external_sign_in] == "facebook"
          @register_form.input(name: "facebook_submit").click
          sleep 4
          puts "Login to Facebook Using default Xirrus FB Account"
          facebook_login(@_browser, opt[:user][:email])
          sleep 3
        elsif opt[:external_sign_in] == "google"
          login_with_google(@_browser, opt[:user][:email])
        else
          @register_form.text_field(id: "guestname").set(opt[:user][:name])
          @register_form.text_field(id: "email").set(opt[:user][:email])

          @_browser.input(id: "registration_submit").click
          sleep 8

          el = @_browser.div(css: ".section.complete")
          el.wait_until_present
          expect(el.text).to include("Registration Successful")
          @_browser.a(id: "complete_link").click
        end

        sleep 12
        expect(@_browser.url).to include(GAP_REDIRECT_DOMAIN)
      end
    end

  end
end



shared_context "gap splash page, login and verify" do |opt, gap_name|
  context "GAP Verify login process on guest Login page" do

    before :all do
      if opt[:external_sign_in] == "facebook"
        @_browser.div(id: "login_facebook").click
        sleep 3
        @register_form = @_browser.form(id: "facebook_mobile_form")
      elsif opt[:external_sign_in] == "google"
        @_browser.div(id: "login_google").click
        sleep 3
        @register_form = @_browser.form(id: "google_mobile_form")
      elsif opt[:external_sign_in] == "one_click"
        @register_form = @_browser.form(id: "register_form")
      else
        container = @_browser.div(id: "splash_login_single")
        container.wait_until_present
        sleep 3
        container.button(text: "Register").click
        @register_form = @_browser.form(id: "register_form")
      end
    end

    it "login gap user" do

      if opt[:external_sign_in] == "facebook"
        @register_form.input(name: "facebook_submit").click
        sleep 4
        puts "Login to Facebook Using default Xirrus FB Account"
        facebook_login(@_browser, opt[:user][:email])
        sleep 3
      elsif opt[:external_sign_in] == "google"
        login_with_google(@_browser, opt[:user][:email])
      elsif opt[:external_sign_in] == "one_click"
        btn = @_browser.input(id: "connect_submit")
        btn.wait_until_present
        btn.click
        sleep 8
      else
        @register_form.text_field(id: "guestname").set(opt[:user][:name])
        @register_form.text_field(id: "email").set(opt[:user][:email])

        @_browser.input(id: "registration_submit").click
        sleep 8

        el = @_browser.div(css: ".section.complete")
        el.wait_until_present
        expect(el.text).to include("Registration Successful")
        @_browser.a(id: "complete_link").click
      end
    end

    it "verify redirect url" do
      sleep 12
      expect(@_browser.url).to include(GAP_REDIRECT_DOMAIN)
    end

    it "verify loged in user in xms" do
      if opt[:external_sign_in] == "self_reg"
        gap = @ng.get_gap_by_name(gap_name)
        gap_id = gap["id"] if gap.is_a?(Hash) && gap["id"]

        res = @ng.guests(gap_id)
        expect(res.code).to eql(200)
        guests = res.body["data"]
        guest = guests.first
        expect(guest).not_to be nil
        expect(guest["email"]).to eql(opt[:user][:email])

        puts "Delete loged in user"
        guest_ids = @ng.guests(gap_id).body["data"].map{|g| g['id']}
        puts "Delete guest"
        @ng.delete_guests(array_of_ids: guest_ids) if guest_ids.any?
      else
        # TODO add
      end
    end

    after :all do
      @_browser.quit unless @_browser.nil?
    end

  end
end



def login_with_google(browser, guest_email=nil, password=nil)

  if browser.div(id: 'login_google').present?
    if browser.input(name: "google_submit").present?
      browser.input(name: "google_submit").click
    else
      browser.div(id: 'login_google').click
      sleep 1
      browser.input(name: "google_submit").click
      sleep 1
    end
  else
    # quick and dirty way to output failure if Google submit not present
    expect("Login with Google option unavailable").to eql("Login with Google option available")
  end

  google_login(browser, guest_email, password)
  sleep 10

  # allow Cloud Guest app to for this user if not already done
  if ( !browser.url.include?(@array_ip) && browser.element(id: "submit_approve_access").present? )
    browser.element(id: "submit_approve_access").click
    sleep 3
  end
  #verify_guest_today(@gap_name,@social_guest)
end


shared_context "gap simple setup" do |args = {}|
  base_title = args[:base_title] || XMS.random_title
  profile_name = args[:profile_name] || "PRO-#{base_title}"
  ssid_name = args[:ssid_name] || "SSID-#{base_title}"
  gap_name = args[:gap_name] || "GAP-#{base_title}"
  gap_type = args[:gap_type] || "SELF"

  facebook = args[:facebook] || false
  google = args[:google] || false

   before :all do
    @base_title = base_title
    @gap_name = gap_name
    @profile_name = profile_name
    @ssid_name = ssid_name
    @ng = @ng || ngapi
    @gap_type = gap_type
    @create_gap_res = @ng.add_gap({name: @gap_name, type: @gap_type })
    expect(@create_gap_res.code).to eql(200)

    #puts @create_gap_res.body
    @gap_id = @create_gap_res.body['id']

    @create_profile_res = @ng.add_profile({name: @profile_name})
    expect(@create_profile_res.code).to eql(200)
    @profile_id = @create_profile_res.body['id']
    @basic_profile_config = JSON.parse(File.read("#{XMS.fixtures_root}/json/profiles/basic_profile_config.json"))
    @basic_profile_config['profileId'] = @profile_id.dup
    @basic_profile_config['ssids'][0]['ssidName'] = @ssid_name
    @basic_profile_config['ssids'][0]["guestPortalId"] = @gap_id
    @basic_profile_config['locale']['country'] = "US"
    @basic_profile_config['ssids'][0]['enabled'] = true
    @basic_profile_config['ssids'][0]['broadcast'] = true
    @update_profile_configuration_res = @ng.create_or_update_profile_configuration(@basic_profile_config)
    sleep 5
    res = @ng.profile_configuration(@profile_id)
    expect(res.body['ssids'][0]['ssidName']).to eql(@ssid_name)
    expect(res.body['ssids'][0]['guestPortalId']).to eql(@gap_id)
    res = @ng.gap_by_id(@gap_id)
    gap_ssids = res.body['ssids']
    expected_ssid = gap_ssids.select{|ssid| (ssid['profileId'] == @profile_id && ssid['ssidName'] == @ssid_name )}.first
    expect(expected_ssid).to_not be_nil
    get_gap_config_res = @ng.gap_configuration(@gap_id)
    new_gap_config = get_gap_config_res.body
    puts "New Gap Config: #{new_gap_config}"
    new_gap_config['authTimeout'] = args[:authTimeout] || "3"
    update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
    #log_body(update_gap_config_res)
    expect(update_gap_config_res.body).to include("Portal Configuration updated")
   if args[:facebook] == true
      get_gap_config_res = @ng.gap_configuration(@gap_id)

      new_gap_config = get_gap_config_res.body
      new_gap_config['authTimeout'] = "3"
      new_gap_config['facebook'] = true
      update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
      #log_body(update_gap_config_res)
      expect(update_gap_config_res.body).to include("onfiguration updated")
      new_gap_config_res = @ng.gap_configuration(@gap_id)
      #log_body(new_gap_config_res)
      expect(new_gap_config_res.body['facebook']).to eql(true)
   end

   if args[:google] == true
      get_gap_config_res = @ng.gap_configuration(@gap_id)
      log_body(get_gap_config_res)
      new_gap_config = get_gap_config_res.body
      new_gap_config['authTimeout'] = "3"
      new_gap_config['google'] = true
      update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
      expect(update_gap_config_res.body).to include("onfiguration updated")

      new_gap_config_res = @ng.gap_configuration(@gap_id)
      #log_body(new_gap_config_res)
      expect(new_gap_config_res.body['google']).to eql(true)
   end
 end # before :all
end # 'simple' splash - no array, no splash


shared_context "gap extend setup" do |args = {}|
  before :all do
   guest_hash = { name: args[:guest_name] , email: args[:guest_email] }

   @gap_config = @ng.gap_configuration(@gap_id).body
   @gap_exp = @gap_config['expiration']
   expect(@gap_exp).to eql("DAY_1")
   @gap_config['authTimeout'] = "3"
   @gap_config['expiration'] = args[:expiration]
   update_gap_res = @ng.update_gap_configuration(@gap_id, @gap_config)
   expect(update_gap_res.code).to eql(200)
   updated_config = @ng.gap_configuration(@gap_id).body
   expect(updated_config['expiration']).to eql(args[:expiration])
   add_guest_res = @ng.add_guest(@gap_id, [guest_hash])
   @original_guest = add_guest_res.body[0]
   @guest_id = add_guest_res.body[0]["id"]
   expect(add_guest_res.code).to eql(200)
   guests_ids_to_extend = []
   guests_ids_to_extend << @guest_id
   @ng.extend_guests(array_of_ids: guests_ids_to_extend)
   @updated_guest = @ng.get_guest(guestId: @guest_id).body
 end
end

shared_context "gap clean" do

  after :all do
    del_gap_res = @ng.delete_gap(@gap_id)

    del_pro_res = @ng.delete_profile(@profile_id)
    expect(del_gap_res.code).to eql(200)

    expect(del_pro_res.code).to eql(200)
  end

end

def get_wait_time(timeoutType, timeout)
  seconds_to_wait_for_timeout = 60
  case timeoutType
      when "MINUTES"
        seconds_to_wait_for_timeout = ( timeout.to_i * 60 )
      when "HOURS"
        seconds_to_wait_for_timeout = (timeout.to_i * 60 * 60 )
      when "DAYS"
        seconds_to_wait_for_timeout = (timeout.to_i * 60 * 60 * 24)
      else

      end
  seconds_to_wait_for_timeout
end



shared_context "gap guest tab setup" do |args = {}|

  include_context "gap simple setup", args

  include_context "gap clean"

  before :all do
    @ui.goto_portal(@gap_name)
    sleep 3

    goto_guests_tab
    expect_no_error

    @guest_name = %w[billybob maryjoe willybeaman].sample
    @guest_email = "#{@guest_name}@yopmail.com"

    add_guest_res = @ng.add_guest(@gap_id, [{name: @guest_name, email: @guest_email }] )
    expect(add_guest_res.code).to eql(200)
    @browser.refresh
    sleep 4
  end

  let(:gpv){@ui.gpv}
  let(:view){@ui.guest_portal_config_view}
  let(:grid){ @ui.guest_portal_config_view.guest_grid_view }
end

shared_context "gap setup" do |gapObj = {}|

  include_context "gap simple setup", gapObj

  include_context "gap clean"

  before :all do
    @ui.goto_portal(@gap_name)
    sleep 2
    @ui.guest_portal_config_view.tile("general").wait_until_present
    sleep 1
  end

end

shared_context "lookfeel setup" do |gapObj = {}|

  include_context "gap simple setup", gapObj

  include_context "gap clean"

  before :all do
    @ui.lookfeel(@gap_name)
    sleep 3
  end

end

shared_context "gap ssid setup" do |gapObj = {}|

  include_context "gap simple setup", gapObj

  include_context "gap clean"

  before :all do
    @ui.goto_portal(@gap_name)
    sleep 2
    @ui.guest_portal_config_view.tile("ssids").wait_until_present
    @ui.guest_portal_config_view.tile("ssids").click
    sleep 1
    @ui.css('#ssid_addnew_btn').wait_until_present
  end

end

def close_preview
  @browser.element(id: "guestportal_preview_close").click
end

def get_psk_csv(gap_name)
  filename = `cd #{ENV['HOME']}/Downloads; ls | grep PSK-#{gap_name[0..20]}`
  puts filename.strip
  download_csv_filename = "#{ENV['HOME']}/Downloads/#{filename.strip}"
  puts "file exist: #{File.exist?(download_csv_filename)}"
  downloaded_csv = CSV.parse(File.read(download_csv_filename), :headers => true)
  downloaded_csv
end


def get_voucher_csv(gap_name)
  voucher_filename = `cd #{ENV['HOME']}/Downloads; ls | grep Vouchers-#{gap_name[0..20]}`
  puts voucher_filename.strip
  voucher_download_csv_filename = "#{ENV['HOME']}/Downloads/#{voucher_filename.strip}"
  puts "voucher file exist: #{File.exist?(voucher_download_csv_filename)}"
  downloaded_csv = CSV.parse(File.read(voucher_download_csv_filename), :headers => true)
  downloaded_csv
end

def lookfeel_color_items
  @ui.ul(css: ".colors").lis(css: ".color")
end

##########################################
########## NEW HELPER METHODS ############
##########################################
def gap_splash_cleanup(profile_name = nil, gap_name = nil)
  if profile_name
    profile = @ng.get_profile_by_name(profile_name)
    profile_id = profile["id"] if profile.is_a?(Hash) && profile["id"]
  end
  if gap_name
    gap = @ng.get_gap_by_name(gap_name)
    gap_id = gap["id"] if gap.is_a?(Hash) && gap["id"]
  end

  @ng.delete_profile(profile_id) if profile_id

  if gap_id
    guests_to_delete = @ng.guests(gap_id).body['data'].map{|g| g['id']}
    @ng.delete_guests(array_of_ids: guests_to_delete) if guests_to_delete.any?
    @ng.delete_gap(gap_id)
  end
  # Close browsers
  @second_browser.quit if @second_browser
  # @browser.quit if @browser
end

def update_gap_option(options_to_update, gap_name = nil)
  new_gap_config = get_gap_option_by_name(gap_name)

  puts " - UPDATE GAP to use Provided Options"

  options_to_update.each do |key, value|
    puts "If both gap current option and the new 'value' are Hashes then do merge instead of override"
    if new_gap_config[key.to_s].is_a?(Hash) && value.is_a?(Hash)
      new_gap_config[key.to_s] = new_gap_config[key.to_s].merge(value)
    else
      new_gap_config[key.to_s] = value
    end

    update_gap_config_res = @ng.update_gap_configuration(@gap_id, new_gap_config)
    expect(update_gap_config_res.body).to eql("\"Portal Configuration updated\"")

    new_gap_config_res = @ng.gap_configuration(@gap_id)

    if new_gap_config[key.to_s].is_a?(Hash) && value.is_a?(Hash)
      expect( (value.collect{|k,v| [k.to_s, v]} - new_gap_config_res.body[key.to_s].to_a).empty? ).to be true
    else
      expect(new_gap_config_res.body[key.to_s]).to eql(value)
    end
  end
end

def get_gap_option_by_name(gap_name = nil)
  if !@gap_id && gap_name
    gap = @ng.get_gap_by_name(gap_name)
    raise "Gap : #{gap_name} should be defined" unless gap.is_a?(Hash) && gap["id"]
    @gap_id = gap["id"]
  end

  res = @ng.gap_configuration(@gap_id)
  expect(res.code).to eql(200)
  res.body
end

############################
##### GAP LOGIN HELPERS ####
############################
def gap_third_party_login(opt = {}, expected_redirect_url = GAP_REDIRECT_DOMAIN, max_attempts = 5)
  attempt = 0
  sleep 8

  case opt[:type]

    #####################
    #### CASE AZURE #####
    #####################
    when "AZURE_AD"
      while attempt < max_attempts
        el = @browser.text_field(name: "loginfmt")
        if el.present?
          el.set(opt[:email])
          @browser.send_keys :tab
          sleep 8
          attempt = max_attempts
          @browser.send_keys :enter
          sleep 8
        else
          puts "Trying to Login Via Azure Gap splash. On attempt: #{attempt}"
          @browser.refresh
          sleep 8
          attempt = attempt + 1
        end
      end

      attempt = 0

      if opt[:email].include?("alexxirrusoutlook.onmicrosoft.com")
        while attempt < max_attempts
          el = @browser.text_field(name: "passwd")
          if el.present?
            el.set(opt[:password])
            sleep 5
            @browser.button(text: "Sign in").click
            attempt = max_attempts
            sleep 6
            btn = @browser.input(value: "Yes")
            btn.wait_until_present
            btn.click
            sleep 6
          else
            puts "Trying to be redirected to specific Azure domain to set the password. On attempt: #{attempt}"
            @browser.refresh
            sleep 8
            attempt = attempt + 1
          end
        end
      end

    ######################
    #### CASE GOOGLE #####
    ######################
    when "GOOGLE_APPS"
      while attempt < max_attempts
        el = @browser.text_field(id: "identifierId")
        if el.present?
          el.set(opt[:email])
          @browser.span(text: "Next").click
          sleep 4
          attempt = max_attempts
          puts "Email for Google Login is set"
        else
          puts "Trying to Login Via Google Login Gap splash. On attempt: #{attempt}"
          @browser.refresh
          sleep 8
          attempt = attempt + 1
        end
      end

      attempt = 0

      while attempt < max_attempts
        el = @browser.div(id: "password")
        if el.present?
          el.input.send_keys(opt[:password])
          sleep 8
          @browser.span(text: "Next").click
          sleep 4
          attempt = max_attempts
        else
          puts "Trying to enter the password for Login Via Google Login Gap splash. On attempt: #{attempt}"
          @browser.refresh
          sleep 8
          attempt = attempt + 1
        end
      end

    ##################
    #### VOUCHER #####
    ##################
    when "VOUCHER"
      while attempt < max_attempts
        el = @browser.text_field(id: "loginpassword")
        if el.present?
          el.set(opt[:password])
          @browser.send_keys :tab
          sleep 1
          @browser.input(id: "login_submit").click
          sleep 4
          attempt = max_attempts
          puts "Password for Vouchers Login is set"
        else
          puts "Trying to Login via Vouchers Gap splash. On attempt: #{attempt}"
          @browser.refresh
          sleep 8
          attempt = attempt + 1
        end
      end


    #######################
    #### CASE UNKNOWN #####
    #######################
    else
      throw "Unknown Third party type: #{opt[:type]}"
  end

  if expected_redirect_url
    attempt = 0
    @redirect_url = nil
    while attempt < max_attempts
      @redirect_url = @browser.url
      if @redirect_url.include?(expected_redirect_url)
        attempt = max_attempts
      else
        puts "Wait #{expected_redirect_url} to Load. On attempt: #{attempt}"
        sleep 4
        attempt = attempt + 1
      end
    end

    trow "Expect redirect url not to be nil" if @redirect_url.nil?

    if URI.parse(@redirect_url).query
      @parsed_redirect_url = CGI.parse(URI.parse(@redirect_url).query)

      if self.respond_to("expect")
        expect(@redirect_url).to include(expected_redirect_url)

        puts "Expect 'mac' to exist in final redirect URL"
        expect(@parsed_redirect_url["mac"].first).to include(@device_mac)

        puts "Expect 'SSId' to exist in final redirect URL"
        expect(@parsed_redirect_url["ssid"].first).to include(@ssid_name)
      else
        trow "Expect redirect url to include #{expected_redirect_url}" unless url.include?(expected_redirect_url)
      end
    end
  end
end

def color_item_rgb(color_item, type="color")
  style = color_item.attribute_value('style')

  if type == "color"
    style.gsub!(/-color/, "")
    captures = style.match(/(color: rgb)\((\d+, \d+, \d+)\)/).captures
  elsif type == "background_color"
    captures = style.match(/(background-color: rgb)\((\d+, \d+, \d+)\)/).captures
  end
  captures[1]
end