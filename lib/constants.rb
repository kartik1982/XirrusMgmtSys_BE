DEFAULT_ACTIVATION_URL = "https://activate-cloud.xirrus.com/"
ACTIVATION_URL = "https://activate-env.cloud.xirrus.com"

JENKINS_OPTIONS = [ "browserstack", "browserstack_user", "browserstack_key", "username", "password", "spec", "env", "build_id","ui","telnet","serial","headless","display","browser_name", "browser_version","array_ips","rspec_out","ip","job","host", "skip_api"]
# Get your Account Sid and Auth Token from twilio.com/user/account
TWILIO_ACCOUNT_SID = "AC541f8b306f98d623423a1b921dccff10"
TWILIO_AUTH_TOKEN = '92b1fea151f9281e3841da36325b1df0'
TWILIO_NYMBER = "+14243756077" # "+18125452597"
XIRRUS_MAC_PREFIX = "50:60:28"
NETMASK = "255.255.255.0"
XTO_ROBIN_PUBLIC_IP = "69.75.119.226"
SSID_LIMIT = 8
PROFILE_VLAN_MAX = 32
DEFAULT_GATEWAY = "10.100.183.1"

# Base Email Address to expect main emails
#BASE_NOREPLAY_EMAIL_ADDRESS = "noreplyriverbed@cloud.xirrus.com"
# AF - updated below address 4/23/18
BASE_NOREPLAY_EMAIL_ADDRESS = "noreply@riverbed.com"

#######################
#### GAP CONSTANTS ####
#######################
GAP_WHITELIST_LIMIT = 64
GAP_REDIRECT_DOMAIN = "www.facebook.com"
#GAP_REDIRECT_IP = "31.13.76.68" 157.240.11.35
GAP_REDIRECT_IP = "157.240.11.35"

DEFAULT_SERVICE_PROVIDERS_COUNT = 239
DEFAULT_ARRAY_PASSWORD = "admin"
DEFAULT_ARRAY_USERNAME = "admin"
DEFAULT_SHARD_ID = "XMS_ROOT"
AP_TAB_NAME = "Access Points" # 8.7 and earlier "Arrays"
# ui css selector uses integers 0(Sun)..6(Sat)
# UI text is ui: for corresponding int
# AP CLI values are 'ap' prop
DAYS_OF_WEEK = [{ ui: "Su", ap: "Sun"},{ui: "M", ap: "Mon"},{ui: "Tu",ap: "Tue"},{ui: "W", ap: "Wed"},{ui: "Th",ap: "Thu"},{ui: "F",ap: "Fri"},{ui: "Sa",ap: "Sat"}]
APS_WITH_GIG2 = ["XR620", "XR630"]
SORT_OPTIONS = ['asc','desc']
SYSLOG_LEVELS = ["Emergency", "Alert", "Critical", "Error", "Warning", "Notice", "Info", "Debug"]
AP_SORT_FIELDS = ["globalSerialNumber","globalMacAddress","globalActivationStatus","globalArrayId","globalLicenseKey", "penaltyType"]
AP_SORT_OPTIONS = ['asc','desc']
COMMANDS_SORT_FIELDS = ["serialNumber","submittedTime","finishedTime"]
# data-field: UI Text,
AP_GRID_DATA_FIELDS = {
    hostName: "Access Point Hostname (required)*",
    serialNumber: "Serial Number",
    onlineStatus: "Online",
    actualIpAddress: "IP Address",
    profileName: "Profile",
    location: "Location",
    activationStatus: "Status",
    baseMacAddress: "Gig1 MAC",
    baseIapMacAddress: "IAP MAC",
    actualNetmask: "Netmask",
    actualGateway: "Gateway",
    arrayModel: "Model",
    recentActivation: "Last Configured Time",
    clients: "Associated Clients"
}
# data-field: "UI Text, "
CLIENT_GRID_DATA_FIELDS = {
    clientHostName: "Client Hostname",
    userName: "User Name",
    ipAddress: "Client IP Address",
    deviceClass: "Device Class",
    txBytes: "Usage (Download)",
    onlineStatus: "Online",
    status: "Status",
    lastSeen: "Last Connected",
    guestMobile: "Guest Phone",
    gapName: "Guest Portal",
    guestName: "Guest Name",
    guestEmail: "Guest Email",
    clientMacAddress: "Client MAC",
    capability: "Capability",
    deviceType: "Device Type",
    activeHostIp: "Array IP Address",
    lastArrayHostName: "Array Hostname",
    location: "Array Location",
    sessionLength: "Connected Time",
    rssi: "RSSI",
    txConnectRate: "Connect Rate (Download)",
    rxConnectRate: "Connect Rate (Upload)",
    band: "Band",
    channel: "Channel",
    iap: "Radio",
    txthroughput: "Throughput (Download)",
    rxthroughput: "Throughput (Upload)",
    throughput: "Throughput (Total)",
    txTotalRetries: "Retries (Download)",
    txTotalErrors: "Errors (Download)",
    txPackets: "Packets(Download)",
    rxBytes: "Usage (Upload)",
    rxTotalRetries: "Retries (Upload)",
    rxTotalErrors: "Errors (Upload)",
    rxPackets: "Packets (Upload)",
    retryPct: "Packet Retry Rate",
    errorPct: "Packet Error Rate",
    keyMgmt: "key Management",
    encType: "Encryption Type",
    cipher: "Cipher",
    ssid: "SSID",
    vlan: "VLAN",
    profileName: "Profile"
}
SINGLE_AP_REGRESSION_GLOBAL_CONFIGURATIONS = nil
CELL_SIZE_PAIRINGS = [
    {size: "Small", tx: 5, rx: -82},
    {size: "Medium", tx: 12, rx: -86},
    {size: "Large", tx: 19, rx: -89},
    {size: "Max", tx: 20, rx: -90}
  ]

AOS_LIGHT_MODELS = ["XR320", "X2120", "WAP9112", "X2-120"]
