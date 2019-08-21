module UTIL
  attr_accessor :log_file
  def log(text)
    if log_file && text
      File.open(log_file,'a'){|f|
        f.puts(text)
      }
    else
      puts "log file or text nil log(text) - XMS Utilities"
    end
  end
  def self.ngem_root
     File.expand_path File.dirname(__FILE__).gsub("/lib/util","")
   end

   def self.nspec_root
     "#{self.ngem_root}/spec"
   end

   def self.nfixtures_root
     "#{self.ngem_root}/fixtures"
   end
  def self.load_json(json_file_path)
    JSON.parse(File.read(json_file_path))
  end
  def get(watir_browser_method, args = {})
    @browser.send(watir_browser_method.to_sym, args)
  end
  def self.random_ip_address
    (1..255).to_a.shuffle[0,1].join
  end
  def self.random_serial
    serial_digits = []
    10.times do
      serial_digits << rand(9)
    end
    "#{serial_digits.join('')}AJ"
  end
  def self.random_building_title
    "#{departments.sample}_#{buildings.sample}_#{ickey_shuffle(5)}" #incresed to 5, 3 was not random enough
  end

  def self.random_email
    "#{random_fullname.downcase.gsub(' ','-')}@sqa-#{buildings.sample}-xirrus.com"
  end
    # '7:30 am' -> 7:30, '3:30 pm' -> 15:30
  def self.to_24hour(time_string)
    DateTime.parse(time_string.gsub(' ','')).strftime("%H:%M")
  end
  
  def self.random_mac
    (1..6).map{"%0.2X"%rand(256)}.join(":").downcase
  end
  def self.firewall_protocols
    ["ANY", "ANY-IP", "ICMP", "IGMP", "SRP", "TCP", "UDP"]
  end

  def self.random_firewall_protocol
    "#{firewall_protocols.sample}"
  end

  def self.firewall_ports
    ["ANY", "Numeric", "BGP", "biff", "BOOTPC", "BOOTPS", "CHARGEN", "Daytime","DHCP","Discard","DNS","DNSIX","echo","Finger","FTP","Gopher","Hostname","HTTP","HTTPS","IPX","IRC","klogin","kshell","LDAP","LPD","nameserver","NetBIOS","NetWare-IP","NNTP","NTP","POP2","POP3","RIP","RSVD","SMTP","SNMP","SSH","SunRPC","syslog","TACACS","TACACS-DS","talk","Telnet","TFTP","UUCP","who","Whois","WWW","XDMCP","XRP"]
  end

  def self.random_firewall_port
    "#{firewall_ports.sample}"
  end

  def self.firewall_sources
    ["Any", "GIG", "IAP", "IP Address"]
  end

  def self.random_firewall_source
    "#{firewall_sources.sample}"
  end

  def self.firewall_destinations
    ["Any", "GIG", "IAP", "IP Address"]
  end

  def self.random_firewall_destination
    "#{firewall_destinations.sample}"
  end
  def self.special_characters
    ['~', '`', '!', '@','\#', '$', '%','^','&','*','(',')','-','_','+','=','{','[','}',']','|','\\',':',';','"',"'",'<',',','>','.','?','/']
  end
  def self.array_models
    %w[XR-320 XR-520 XR-620 XR-630]
  end

  def self.buildings
    %W[100 101 102 202 203 222 304 333 400 444 405 505 506 507 555 707 708 777 808 888 809 900 909 990 999]
  end
  def self.chars_256
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis,."
  end

  def self.chars_255
    "Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis."
  end

  def self.url_longer_than_256
    "#{random_title.gsub(' ','-')}#{chars_256.gsub(' ','-').gsub('.','-').gsub('_','-').gsub(',','')}.com"
  end
  def self.departments
    %w[Athletics Admissions Faculty Library Biology Chemistry Science Art TheatreArts Stadium Quad ParkingLot PressBooth Employee Executive Billing AccountsProduction Testing Management HumanResources Payroll]
  end

  def self.subsections
    %w[000 001 007 888 555 444 777 010 101 202 303 404 505 1010 2222 8888 8080 3000 4567 9999]
  end

  def self.first_names
    ["Billy Bob", "Mike", "Eric", "James", "Tony", "Henry", "Jimmy", "Pauly", "Sam", "Gary", "Tommy", "Frankie", "Billy", "Janice", "Karen"]
  end

  def self.last_names
    %w[Conway Hill Thorton DeVito Cicero Carbone Batts Rossi]
  end
  def self.random_lastname
    "#{last_names.sample}-#{ickey_shuffle(5)}"
  end

  def self.random_firstname
    "#{first_names.sample}-#{ickey_shuffle(4)}"
  end

  def self.random_fullname
    "#{first_names.sample}-#{last_names.sample}-#{ickey_shuffle(5)}"
  end

  def self.random_profile_name
    "PROFILE - #{departments.sample} - Responsible: #{last_names.sample} #{first_names.sample} - #{ickey_shuffle(9)}"
  end
  def self.ickey_shuffle(x)#some of you are too young to remember Ickey Woods and the Ickey Shuffle - http://www.youtube.com/watch?v=a9oVth5rJbg
    (0..9).to_a.shuffle[0,x].join
  end

  def self.random_title(x=50)
    "#{departments.sample}_#{subsections.sample}_#{ickey_shuffle(5)}"[0..x] #incresed to 5, 3 was not random enough
  end
  def el
     @el
  end
  ################################
  ###### NEW HELPER METHODS ######
  ################################
  def self.wait_helper(wait_time=0, message1="do something", message2="doing something", inc=10)
    i = inc
    max_sleep_time = wait_time
    puts " - Wait #{max_sleep_time} seconds to #{message1}"
     while i < max_sleep_time
      puts "#{i} seconds..."
      sleep inc
      i += inc
    end
    puts message2
  end
def self.gap_splash_page(args = {})
  "https://guest-#{args[:env]}.cloud.xirrus.com/?challenge=1&uamip=#{args[:uamip]}&uamport=#{args[:uamport]}&apmac=#{args[:apmac]}&mac=#{args[:mac]}&userurl=http://www.google.com&ssid=#{args[:ssid_name]}"
end
  def self.update_mac_by_number(mac, number = 1)
    index = 16
    n = number.to_s

    while n.length > 0
      d = n.split(//).last(2).join
      mac[index-1..index] = d.to_i > 9 ? d :  mac[index-1].concat(d)

      n = n[0..-3]
      index = index - 3
    end

    mac
  end
  ##################################
  ####### NEW General methods ######
  ##################################
  # TODO Move to generic place
  def self.new_chrome_incognito()
    Watir::Browser.new :chrome, switches: ['--incognito']
  end
  def wait_until_present
      if el.present? != true
        @position = el.wd.location
        browser.execute_script("body.scrollTop=#{@position[1]}")
      end
      el.wait_until(&:present?)
    end

    def visible?
      el.visible?
    end

    def present?
      el.present?
    end

    def hover
      if el.visible? != true
        @position = el.wd.location
        browser.execute_script("body.scrollTop=#{@position[1]}")
      end
       el.hover
    end

    def focus
      if el.visible? != true
        @position = el.wd.location
        browser.execute_script("body.scrollTop=#{@position[1]}")
      end
      el.focus
    end

    def click
      if el.visible? != true
        @position = el.wd.location
        browser.execute_script("body.scrollTop=#{@position[1]}")
      end
      el.click
    end
end #unitl

