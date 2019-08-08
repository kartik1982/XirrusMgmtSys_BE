require 'rspec'
require 'watir'
require 'json'
require 'optparse'
require 'pathname'
require 'headless'
require 'rest-client'
require 'net/ssh'
require 'net/scp'
require 'time_diff'

require_relative 'executor/spec_runner.rb'
require_relative 'executor/spec_helper.rb'
require_relative 'executor/array.rb'
require_relative 'gui/ui.rb'
require_relative 'util/util.rb'
require_relative 'api/api_client.rb'

$:.unshift File.dirname(__FILE__)
require 'constants'

pn = Pathname.new("xirrus-auto")
if pn.exist?
  load "#{pn}"
else
  puts "please save your default config settings at #{ENV['HOME']}/.xirrus-auto \n"
  puts "copy the dot_xirrus-auto_example file to ~/.xirrus-auto and modify for your settings\n"
end
