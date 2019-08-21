shared_examples "update profile optimize settings" do |profile_name|
  describe "Update profile optimize settings" do
    before :all do
      # make sure it goes to the profile
      @ui.goto_profile profile_name
      sleep 1
      adv = @ui.id('profile_config_advanced')
      adv.wait_until_present
      if(adv.text == 'Show Advanced')
        @ui.click('#profile_config_advanced')
      end
      @ui.click('#profile_config_tab_optimization')
    end

    it "Turn off fast roam and save" do
        c = @ui.css('#optimize_client .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        @ui.click('#optimization_fastroam_switch .switch_label')

        @ui.save_profile
        sleep 1

        expect(@ui.get(:checkbox, {id: "optimization_fastroam_switch_switch"}).set?).to eq(false)
    end

    it "Turn on fast roam and save" do
        c = @ui.css('#optimize_client .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        @ui.click('#optimization_fastroam_switch .switch_label')

        @ui.save_profile
        sleep 1

        expect(@ui.get(:checkbox, {id: "optimization_fastroam_switch_switch"}).set?).to eq(true)
    end

    it "Turn off acXpress and save" do
        c = @ui.css('#optimize_client .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        @ui.click('#optimization_loadbalancing_bond_switch .switch_label')

        @ui.save_profile
        sleep 1

        expect(@ui.get(:checkbox, {id: "optimization_loadbalancing_bond_switch_switch"}).set?).to eq(false)
    end

    it "Turn on acXpress and save" do
        c = @ui.css('#optimize_client .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        @ui.click('#optimization_loadbalancing_bond_switch .switch_label')

        @ui.save_profile
        sleep 1

        expect(@ui.get(:checkbox, {id: "optimization_loadbalancing_bond_switch_switch"}).set?).to eq(true)
    end

    it "Do not optimize multicast traffic and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        c = @ui.css('#optimize_traffic .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        sleep 2
        @ui.click('#profile_config_optimization_multicast_none + .mac_radio_label')

        @ui.save_profile
        sleep 1

        expect(@ui.get(:radio, { id: 'profile_config_optimization_multicast_none' }).set?).to eq(true)
        @browser.execute_script('$("#suggestion_box").show()')
    end

    it "Set multicast traffic to light and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        c = @ui.css('#optimize_traffic .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        sleep 1
        @ui.click('#profile_config_optimization_multicast_light + .mac_radio_label')

        @ui.save_profile
        sleep 1

        expect(@ui.get(:radio, { id: 'profile_config_optimization_multicast_light' }).set?).to eq(true)
        @browser.execute_script('$("#suggestion_box").show()')
    end

    it "Set multicast traffic to moderate and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        c = @ui.css('#optimize_traffic .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        sleep 1
        @ui.click('#profile_config_optimization_multicast_mode + .mac_radio_label')

        @ui.save_profile
        sleep 1

        expect(@ui.get(:radio, { id: 'profile_config_optimization_multicast_mode' }).set?).to eq(true)
        @browser.execute_script('$("#suggestion_box").show()')
    end

    it "Set multicast traffic to aggresive and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        c = @ui.css('#optimize_traffic .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        sleep 1
        @ui.click('#profile_config_optimization_multicast_high + .mac_radio_label')

        @ui.save_profile
        sleep 1

        expect(@ui.get(:radio, { id: 'profile_config_optimization_multicast_high' }).set?).to eq(true)
        @browser.execute_script('$("#suggestion_box").show()')
    end

    it "Add multicast exclude and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        c = @ui.css('#optimize_traffic .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        sleep 1
        @ui.click('#profile_config_optimization_multicast_toggle_showexclude')

        @ui.set_input_val('#profile_config_optimization_multicast_exclude_id','239.2.3.44')
        @ui.set_input_val('#profile_config_optimization_multicast_exclude_desc','test')
        @ui.click('#profile_config_optimization_multicast_exclude_add')

        @ui.save_profile
        sleep 1

        item = @ui.css('.multicast_exclude_list .select_list li:nth-child(2)')
        expect(item.text).to include('239.2.3.44')
        expect(item.text).to include('(test)')
        @browser.execute_script('$("#suggestion_box").show()')
    end

    it "Remove multicast exclude and save" do
        @browser.execute_script('$("#suggestion_box").hide()')
        c = @ui.css('#optimize_traffic .opt_header a')
        c.wait_until_present
        if(c.attribute_value("class")=="expand_collapse")
            c.click
        end
        sleep 1

        item = @ui.css('.multicast_exclude_list .select_list li:nth-child(2)')
        item.wait_until_present
        item.hover

        del = item.a(:class => 'deleteIcon')
        del.wait_until_present
        del.click
        sleep 1

        @ui.confirm_dialog
        sleep 1

        @ui.save_profile
        sleep 1

        list = @ui.css('.multicast_exclude_list .select_list')
        list.wait_until_present
        expect(list.lis.length).to eq(1)
        @browser.execute_script('$("#suggestion_box").show()')
    end

  end
end