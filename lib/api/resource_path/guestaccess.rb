module API
  class ApiClient
    def gaps(args = {})
      get("/easypass.json",args)
    end

    def add_gap(args)
      post("/easypass.json", args)
    end

    def delete_gap(_id)
      delete("/easypass.json/#{_id}")
    end

    def delete_gap_by_name(gap_name)
      all_gaps = gaps(count: 1000).body['data']
      gap_to_delete = all_gaps.select{|gapObj| gapObj['name'] == gap_name}.first
      delete_gap(gap_to_delete['id']) if gap_to_delete
    end

    def get_gap_by_name(gap_name)
      gaps(count: 1000).body['data'].find{|gapObj| gapObj['name'] == gap_name}
    end

    def add_guest(gap_id, array_of_guest_hashes)
      post("/guestaccess.json/#{gap_id}/guest", array_of_guest_hashes)
    end

    def update_guest(guest_id, args = {})
      put("/guestaccess.json/#{guest_id}", args)
    end

    def guests(_gap_id,args={})
      get("/guestaccess.json/#{_gap_id}/guest", args)
    end

    def get_guest(args ={})
      get("/guestaccess.json/#{args[:guestId]}")
    end

    def gap_by_id(_gap_id)
      get("/easypass.json/#{_gap_id}")
    end

    def update_gap(_gap_id, gap_obj)
      put("/easypass.json/#{_gap_id}", gap_obj)
    end

    def gap_configuration(_gap_id)
      get("/easypass.json/#{_gap_id}/configuration")
    end

    def update_gap_configuration(_gap_id,_config)
      put("/easypass.json/#{_gap_id}/configuration", _config)
    end

    def extend_guests(args={})
      body_put("/guestaccess.json/extend",args[:array_of_ids])
    end

    def assign_ssids_to_portal(portal_id, args = [])
      args.each do |arg|
        arg[:profileId] = get_profile_by_name(arg[:profileName])["id"] unless arg[:profileId]
        arg[:ssidId] = get_ssid_by_name(arg[:ssidName])["id"] unless arg[:ssidId]
      end
      put("/easypass.json/#{portal_id}/ssids", args)
    end

    # Returns CSV.
    def list_all_guests_csv(args = {})
      get_csv("/guestaccess.json/all/csv", args)
    end

  end # APICLien
end