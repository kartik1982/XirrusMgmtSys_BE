require_relative "../context.rb"
require_relative "./local_lib/array_lib.rb"
require_relative "../TS_BE_Profiles/local_lib/profiles_lib.rb"
require_relative "../TS_BE_Mynetwork/local_lib/mynetwork_lib.rb"
################################################################################################################
##############TEST CASE: Array Details Slideout - Basic MultiEdit Radios#############################################
################################################################################################################

describe "*******************TEST CASE: Array Details Slideout - Basic MultiEdit Radios***************" do

  before :all do
    goto_mynetwork_arrays_tab
    sleep 2
    @so = @ui.network_slideout(@array.hostname)
    sleep 1
    @rc = @so.goto_radio_content
    sleep 3
    @rc.show_advanced
    sleep 3
    @rc.select_all
    @rc.edit_multiple_btn.wait_until_present
    @rc.edit_multiple_btn.scroll.to
    @rc.edit_multiple_btn.click
    @rc.multi_edit_item.wait_until_present
  end

  let(:me){@so.radios_content.multi_edit_item}

  it "tells you are editing X radios" do
     me.you_are.wait_until_present
     expect(me.you_are.text).to include("You are editing the following")
  end

  it "has a tag for each radio selected" do
    expect(me.tags.length).to eql(2)
  end

  it "MultiEdit Enabled Ddl" do
     dd = me.open_drop("enable")
     mapped = @ui.li_text_array(dd)
     expect(mapped.length).to eql(2)
     dd.lis[0].click
  end

  it "bulk disable radios" do
     me.set_drop("enable","Disabled")
  end

  it "has Apply button" do
    me.edit_mode
    me.multi_apply.wait_until_present
  end

  it "has Cancel button" do
    me.multi_cancel.wait_until_present
    #me.multi_cancel.click
  end

  it "click Apply button and save" do
    me.multi_apply.scroll.to
    me.multi_apply.click
    @so.save_btn.scroll.to
    @so.save_btn.click
    sleep 3
  end

  include_examples "activate"

  it "api check iaps are disabled" do
    @api_client = @api_client || @array.api_client
    res = @api_client.settings_iap("1")
    expect(res["enabled"]).to eql(false)
    res2 = @api_client.settings_iap("2")
    expect(res2["enabled"]).to eql(false)
  end


  it "re-enable radios set iaps back to defaults" do
    @so.radios_content.select_all
    @so.radios_content.edit_multiple_btn.wait_until_present
    @so.radios_content.edit_multiple_btn.click
    @so.radios_content.multi_edit_item.wait_until_present
    multi = @so.radios_content.multi_edit_item
    multi.edit_mode
    multi.multi_apply.wait_until_present
    multi.set_drop("enable", "Enabled")
    multi.multi_apply.click

    r1 = @so.radios_content.radio_item("Radio 1")
    r2 = @so.radios_content.radio_item("Radio 2")

    r2.edit_mode
    r2.band5ghz.click

    r1.edit_mode
    # We need to call the edit mode twice in case we have already have another cell in edit mode.
    r1.edit_mode

    r1.band24ghz.click

    r2.edit_mode
    r2.set_drop("channel","149")
    r2.set_drop("cellSize", "Auto")
    r2.set_drop("wifi", "AN")

    r1.edit_mode
    # We need to call the edit mode twice in case we have already have another cell in edit mode.
    r1.edit_mode
    r1.set_drop("channel","1")
    r1.set_drop("cellSize","Small")
    r1.set_drop("wifi","BGN")
    @so.save_btn.scroll.to
    @so.save_btn.click
    sleep 3
  end

  include_examples "activate"

  it "iap 1 has correct settings - enabled, 2.4GHz, channel 1" do
    @api_client = @api_client || @array.api_client
    res = @api_client.settings_iap("1")
    expect(res["enabled"]).to eql(true)
    expect(res["channelPrimary"]).to eql(1)
    expect(res["band"]).to eql("2.4GHz")
  #  expect(res["cellSize"]).to eql("small")
  end

  it "iap 2 has correct settings - enabled, 5GHz, channel 149" do
    @api_client = @api_client || @array.api_client
    res = @api_client.settings_iap("2")
    expect(res["enabled"]).to eql(true)
    expect(res["channelPrimary"]).to eql(149)
    expect(res["band"]).to eql("5GHz")
    expect(res["cellSize"]).to eql("auto")
  end

  it "Disable IAP 1 and 2 via XMS Cloud API - PUT /radios.json/array_id" do
    @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
    @ng = API::ApiClient.new(token: @token)
    array_res = @ng.array_by_serial(@array.serial)
    array_id = array_res.body['id']
    two_disabled_radios = JSON.parse(File.read("#{EXECUTOR.fixtures_root}/json/arrays/two_disabled_radios.json"))
    set_radios = @ng.put_radios(array_id, two_disabled_radios)
  end

  include_examples "activate"

end # describe MultiEdit