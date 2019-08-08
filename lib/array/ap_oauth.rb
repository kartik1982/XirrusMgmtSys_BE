require 'rest-client'
require 'json'
require 'open-uri'
require 'net/http'
require 'net/smtp'

ip = "10.100.59.122"
username = "admin"
password = "admin"
ap_token_request = RestClient.post("http://#{ip}/oauth/authorize",
   {
     grant_type: "password",
     client_id: username,
     username: username,
     password: password

	})

puts ap_token_request.to_s
