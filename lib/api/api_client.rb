require 'httparty'
require 'pp'

$:.unshift File.dirname(__FILE__)
require 'resource_path//arrays'
require 'resource_path/arrays-b'
require 'resource_path/profiles'
require 'resource_path/profiles-b'
require 'resource_path/users'
require 'resource_path/users-b'
require 'resource_path/guestaccess'
# require 'api/resource_path/guestaccess-b'
require 'resource_path/tenants'
# require 'api/resource_path/reports'
require 'resource_path/aosversions'
require 'resource_path/tenantcircles'
# require 'api/resource_path/airwatch'
# require 'api/resource_path/clients'
# require 'api/resource_path/commands'
# require 'api/resource_path/commands-aliases'
# require 'api/resource_path/maintenance'
# require 'api/resource_path/appcon'
require 'resource_path/ssodomain'
require 'resource_path/system_message'
# require 'api/resource_path/global-settings'
module API
  def self.api(args={})
    API::ApiClient.new(args)
  end

  # def self.version
    # File.read("#{XMS.nfixtures_root}/version.txt").strip
  # end
# 
  # def self.latest_api_fixtures
    # "#{XMS.nfixtures_root}/api-docs/#{XMS::NG.version}"
  # end

    def self.get_backoffice_token(args ={})
      username = args[:username]
      password = args[:password]
      env = args[:env] || "test03"
      if args[:host]
        #host = "https://login-test03.cloud.xirrus.com"
        host = args[:host]
      else
        #host = "https://login-test03.cloud.xirrus.com"
        host = "https://login-#{env}.cloud.xirrus.com"
      end
      puts username
      puts password
      puts host
      puts "requesting backoffice token..."
      token_request = RestClient.post("#{host}/oauth/token" ,
          {

            grant_type: 'password',
            client_id: 'xmsmobileclient',
            client_secret: 'Xirrus!23',
            username: username,
            password: password

          }
      )

      token = token_request[/[a-z0-9]{8}(-[a-z0-9]{4}){3}-[a-z0-9]{12}/] #token_request.split(',')[0].split(':')[1].gsub(/"/,'')
      puts "TOKEN: #{token}"
      token

    end
  class ApiClient    
     include HTTParty
     attr_reader :token, :history
     attr_accessor :env, :xms_url, :username, :password, :host
     def initialize(args = {})
       @history = []
         if args[:host]
          #puts "INIT API CLIENT WITH HOST : #{args[:host]}"
          @xms_url = args[:host]
         else
           @env = args[:env] || $the_environment_used
           @xms_url = "https://login-#{@env}.cloud.xirrus.com"
         end

        puts "@ENV: #{@env}"
        puts "@XMS_URL: #{@xms_url}"

        @username = args[:username] || DEFAULT_USER
        @password =  args[:password] || DEFAULT_PASSWORD

        if args[:token]
          @token = args[:token]
        else
          @token = API.get_backoffice_token({username: @username, password: @password, host: @xms_url})
          puts @token
          puts ""
        end

      end


      def api_path
       "#{@xms_url}/api/v2"
      end

      # Takes a hash of params and builds a query string for api calls
    # == Parameters:
    # params::
    # hash of params - { tenant_id: "Gallena", path: "/athletics" }
    # if a value is an Array, multiple query params will be added under that name
    # { feed: ["/rss/news.xml","/rss/events.xml"]} => feed=/rss/news.xml&feed=/rss/events.xml
    def build_query(params = {})
      res = ""
      params.each { |key,val|
        if val.kind_of?(Array)
          val.each {|v|
            res << "#{key}=#{v}&"
          }
        else
          res << "#{key}=#{val}&"
        end
      }
      res
    end

    def query_string_to_hash(q_string)
      Hash[CGI.parse(q_string).map {|key,values| [key.to_sym, values[0]||true]}]
    end



    def token
      @token
    end

    class Response
      attr_reader :fields, :body, :header, :code,:message,:response_name,:errors,:warnings,:name, :response, :cookie,:path

      #response is JSON string returned by api, name is name of method 'create_folder' or api path '/folders/new'
      def initialize(response, path, options = {})

          # puts "Init NG:Response , original response : #{response}"
          # headers
          # @fields = response.get_fields
          # @header = response.to_hash
          @response = response
          puts @response
          puts ""

          #status
          @code = response.code
          puts @code
          puts ""
         # @message = response.message
          @response_name = response.class.name

         # @cookie = response.get_fields('set-cookie')

          #body
         if( response.body[0] != '{' && response.body[0] != '[')
          #puts "no wrapper"
          @body = response.body

         else
         # puts "wrapper : #{response.body[0]}"
          @body = JSON.parse(response.body)
         end

         @path = path
      end



      def body
        @body
      end

      def data
        @body["data"]
      end

      def new_object_name
        @new_object_name
      end

      def new_object_value
        @new_object_value
      end

      def report
        puts @name
        puts @code
      end


      def pretty_json
        JSON.pretty_generate(@body)
      end


    end #




    # Generic api call method,
    #
    # == Parameters:
    # method::
    #   A symbol declaring the http method to use
    #   can be `:get` or `:post`
    # == returns
    # An XMS::NG::ApiClient::Response object
    #
    def call(_method, _path, params = {})
      puts "Aici?"
      begin
        #path = "https://login-test03.cloud.xirrus.com/api/v2#{_path}"

      path = "#{@xms_url}/api/v2#{_path}"
      puts "PATH = #{path}"
     if (_method == :get || _method == :get_string || _method == :get_csv || _method == :get_csv_all_radios || _method == :put_with_query_params || _method == :post_with_query_params)
       query = build_query(params)
       path += "?#{query}"
       # Escape if anu spaces in url
       path = URI.escape(path)
     end
      success = false
      case _method

        when :get
          puts "#{token}"
          response_json_string = RestClient.get( path, :authorization => "Bearer #{token}",

                                                       :format => :json,

                                                       :content_type => :json,

                                                       :accept => :json
                                ) # RestClient get

        when :post

          response_json_string = RestClient.post( path , params.to_json , :authorization => "Bearer #{token}",

                                                                          :format => :json,

                                                                          :content_type => :json,

                                                                          :accept => :json
                                               ) # RestClient Post
        when :post_file

            response_json_string = RestClient.post( path , params , :authorization => "Bearer #{token}",

                                                                          :format => :json,

                                                                          :content_type => :text,

                                                                          :accept => :json
                                               ) # RestClient Post file



        when :put
          puts params.to_json
          response_json_string = RestClient.put( path , params.to_json , :authorization => "Bearer #{token}",

                                                                          :format => :json,

                                                                          :content_type => :json,

                                                                          :accept => :json
                                               ) # RestClient Post

        when :delete
          response_json_string = RestClient.delete( path , :authorization => "Bearer #{token}",

                                                                          :format => :json,

                                                                          :content_type => :json,

                                                                          :accept => :json
                                               ) # RestClient Post
         when :delete_with_args
          response_json_string = RestClient.delete( path ,params, :authorization => "Bearer #{token}",

                                                                          :format => :json,

                                                                          :content_type => :json,

                                                                          :accept => :json
                                               ) # RestClient Post
        else nil

      end

        puts " ---------- "
        pp response_json_string
        puts " ---------- "
        response = API::ApiClient::Response.new(response_json_string, path)
        # update_history(response)
        if response.cookie
          @all_cookies = response.cookie
          puts "new cookie..."
        end
        @history << [path,response.body]

        response

      rescue => e
        puts " ---------- "
        puts e.message
        puts " ---------- "
        #puts "rescuing ng api client call - #{e.message}"

        #puts "NG::ApiClient.call rescued - path: #{_path}"
        #puts "e.message: #{e.message}"
        #response = XMS::NG::ApiClient::Response.new(e.message, path)
        e.message
      end

    end

    def get(path, params ={})
      call(:get, path, params)
    end

    def post(path, params={})
      puts "salut"
      call(:post, path, params)
    end

    def post_file(path, encoded_file_object)
      call(:post_file, path, encoded_file_object)
    end

    def put(path, params={})
       call(:put, path,params)
    end

    def delete(path, params={})
       call(:delete, path,params)
    end

    def body_param_call(method, path, body_param_array)
      body_string = array_to_body_string(body_param_array)
      HTTParty.send(method, path, { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }})
    end

    def body_param_call2(method, path, body_string)
      HTTParty.send(method, path, { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }})
    end

    def body_put2(path, body_param_array)
      body_param_call(:put, "#{api_path}#{path}", body_param_array)
    end

    def body_put(path, body_param_array)
      body_param_call(:put, "#{api_path}#{path}", body_param_array)
    end

    def body_delete(path, body_param_array)
      body_param_call(:delete,"#{api_path}#{path}", body_param_array)
    end

    def sfdc_sync
      get("/sfdc.json/customerData")
    end

    def shards
      get("/shards.json")
    end

    def get_shards
      shards
    end

    def array_to_body_string(ids_array)
      body_string = "["
      if ids_array.respond_to?("each")
        ids_array.each_with_index{|id,index|
         unless index == 0
          body_string += " ,"
         end
         body_string += "\"#{id}\""
        }
        body_string += "]"
      else
        body_string = nil
      end
      body_string
    end


    def delete_buildings(ids_array)
      if ids_array.respond_to?("each")
      body_string = "["
      ids_array.each_with_index{|id,index|
       unless index == 0
        body_string += " ,"
       end
       body_string += "\"#{id}\""
      }
      body_string += "]"

      response_json_string = HTTParty.delete("#{api_path}/floorplans.json/building", { :body => body_string, :headers => {"Authorization" => "Bearer #{token}",'Content-Type' => 'application/json', 'Accept' => 'application/json' }}) # RestClient Post
     else
      nil
     end
    end # delete_buildings
    
  end
end