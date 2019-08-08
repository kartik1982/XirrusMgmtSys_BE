def log(text)
  if File.exists?(@log_file)

    File.open(@log_file,'a'){|f| f.puts(text) }
  end
end

def test_profile_setup(test_profile = {},profile_config_json_file = "#{UTIL.nfixtures_root}/json/profiles/basic_profile_config.json")
   @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
   @ng = API::ApiClient.new(token: @token)
   @profile = test_profile[:name] || "Pro-#{UTIL.random_title}"

   @create_profile_res = @ng.add_profile({name: @profile})
   expect(@create_profile_res.code).to eql(200)
   @profile_id = @create_profile_res.body['id']
   @profileId = @profile_id
   puts "Profile Created: #{@profile}, #{@profile_id} - wait 5 before getting config"
   sleep 5
   puts "done waiting..."
   first_config = @ng.get_profile_configuration(profileId: @profile_id)
  

   @profile_config = UTIL.load_json(profile_config_json_file)


   
  if test_profile[:ssids]
    puts "SSIDS... in test_profile_setup"
    @ssid_starter = UTIL.load_json("#{XMS.nfixtures_root}/json/profiles/ssid_starter.json")
    @ssids = test_profile[:ssids].split(',')

    ssids_to_add_to_config = []

    if test_profile[:ssid_bands]
      @ssid_bands = test_profile[:ssid_bands]
    end

    # ssid_status: "{'tag1'=>'Yes','tag2'=>'Yes'}",
    if test_profile[:ssid_status]
      @ssid_status_obj = eval(test_profile[:ssid_status])
    end
    # broadcast_status: "{'tag1'=>'Yes','tag2'=>'No'}"
    if test_profile[:broadcast_status]
      @broadcast_status_obj = eval(test_profile[:broadcast_status])
    end
    
    #puts "ssids each setup"
    @ssids.each {|ssid|
      this_ssid_cloud_object = @ssid_starter.clone
      this_ssid_cloud_object['ssidName'] = ssid 

      if (@ssid_bands.respond_to?("each"))
      this_ssid_bands = @ssid_bands.select{|key, value| key == ssid}.first
       if this_ssid_bands
        this_ssid_band = this_ssid_bands[1]
       end
      if this_ssid_band
        band_to_set = "BOTH"
        if this_ssid_band == "2.4GHz"
          band_to_set = "DOT11BG"
        elsif this_ssid_band == "5GHz"
          band_to_set = "DOT11A"
        elsif (this_ssid_band == "DOT11A" || this_ssid_band == "DOT11BG")
          band_to_set = this_ssid_band
        else
          band_to_set = "BOTH"
        end
        this_ssid_cloud_object['band'] = band_to_set
      end
      end

      if ( @ssid_status_obj.respond_to?("each"))
      this_ssid_status = @ssid_status_obj.select{|key,value| key == ssid}.first 
      if this_ssid_status
        status = (this_ssid_status[1].downcase == "yes") ? true  : false
        this_ssid_cloud_object['enabled'] = status 
      end
      end

      if (@broadcast_status_obj.respond_to?("each"))
      this_ssid_broadcast = @broadcast_status_obj.select{|key,value| key == ssid}.first 
      if this_ssid_broadcast
        broadcast = (this_ssid_broadcast[1].downcase == "yes") ? true  : false
        this_ssid_cloud_object['broadcast'] = broadcast
      end
      end

      ssids_to_add_to_config << this_ssid_cloud_object
      
    } # @ssids each

    @profile_config['ssids'] = ssids_to_add_to_config
   else
    # no ssids
    @profile_config['ssids'] = nil
   end # if test_profile[:ssids]
   #puts "after each ssids setup"
   # vlan_status: "enable"
   if test_profile[:vlan_status]
     @vlan_status = test_profile[:vlan_status]
     if (@vlan_status == "enable" || @vlan_status == true || @vlan_status.downcase == "yes")
       @profile_config['networking']['useVlan'] = true
     end
   end

   #puts @profile_config.to_json
   @update_config = @ng.update_profile_configuration(@profile_id, @profile_config)
   expect(@update_config.code).to eql(200)
   sleep 2
   if @browser
     @browser.refresh 
     sleep 4
   end
   @update_config
end

