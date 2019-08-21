require_relative "../context.rb"
require_relative "local_lib/mynetwork_lib.rb"
################################################################################################################
##############TEST CASE: Reboot Access Point from My Network#############################################
################################################################################################################

describe "***********TEST CASE: Reboot Access Point from My Network****************" do

    before :all do 
      goto_mynetwork_arrays_tab
      sleep 2              
    end

    it "UI - Reboot AP" do 
      @so = @ui.network_slideout(@array.hostname)
      sleep 3  
      @ui.css(".array_details #arrays_more_btn").click
      sleep 2
      @ui.css('.drop_menu_nav.active div a:nth-child(1)').click
      sleep 1
      @ui.confirm_dialog
      sleep 2
      @browser.refresh 
      sleep 8
      row = @ui.array_grid.row(@array.serial)      
    end
end