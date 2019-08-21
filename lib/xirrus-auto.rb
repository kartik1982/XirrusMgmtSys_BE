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
require "watir-scroll"

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

SHARD_ID = DEFAULT_SHARD_ID
###  TODO refactor this
# Monkey Patch Ruby Array class 
# get array item that starts with certain text
# used for verifying XirrusArray settings in CLI responses
 class Array
    def get_line(start_text)
      start_text.class == Regexp ? self.select { |line| line =~ start_text }.first : self.select{|line| line.strip.start_with?(start_text)}.first
    end

    def get_lines(start_text)
      start_text.class == Regexp ? self.select { |line| line =~ start_text } : self.select{|line| line.strip.start_with?(start_text)}
    end
  end

 def set_text_field_by_id(_id, value)
  tf = get(:text_field,{id: _id})
  sleep 5
  tf.wait_until_present
  tf.clear
  tf.value = value.strip
  sleep 1
  tf.fire_event("onblur")
  @browser.send_keys :tab
  sleep 1
end
def dd_active
    @browser.div(css: ".ko_dropdownlist_list.active")
end

def api
  API.api({username: @username, password: @password, host: @login_url})
end