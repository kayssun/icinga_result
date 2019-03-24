require 'yaml'
require 'net/http'
require 'uri'
require 'json'
require 'icinga_result/host'
require 'icinga_result/service'
require 'icinga_result/check_result'

module IcingaResult
  # The Icinga2 API client
  class Client
    CONFIG_FILE = "#{ENV['HOME']}/.icinga_result.config.yml".freeze

    attr_reader :username, :password, :host, :port

    def initialize
      load_config
    end

    def load_config
      File.open(CONFIG_FILE, 'r') do |file|
        data = YAML.safe_load(file.read)
        @username = data['username']
        @password = data['password']
        @host = data['host']
        @port = data['port']
        @always_send = data['always_send_host_alive']
      end
    end

    def send(service, check_result)
      host = Host.new
      send_result(host, service, check_result)
    end

    def send_result(host, service, check_result)
      response = api_post("/actions/process-check-result?service=#{host.name}!#{service.name}", check_result.data)
      register_service(host, service) if response.code.to_i == 404
      send_host_alive(host)

      handle_errors(response)
    end

    def send_host_alive(host = Host.new)
      path = "/actions/process-check-result?host=#{host.name}"
      data = { 'exit_status' => 0, 'plugin_output' => 'Host alive' }
      response = api_post(path, data)
      register_host(host) if response.code.to_i == 404
      handle_errors(response)
      response
    end

    def register_host(host)
      response = api_put("/objects/hosts/#{host.name}", host.data)
      handle_errors(response)
      response
    end

    def register_service(host, service)
      response = api_put("/objects/services/#{host.name}!#{service.name}", service.data)
      register_host(host) if response.code.to_i == 404
      handle_errors(response)
      response
    end

    def handle_errors(response)
      if response.code.to_i < 200 || response.code.to_i > 299
        raise "Cannot send results to Icinga server: #{response.code} - #{response.message}: #{response.body}"
      end
    end

    def header
      {
        'Content-Type': 'application/json',
        'Accept': 'application/json'
      }
    end

    def api_post(path, data)
      http = Net::HTTP.new(@host, @port)
      http.use_ssl = true
      request = Net::HTTP::Post.new("/v1#{path}", header)
      request.basic_auth @username, @password
      request.body = data.to_json
      puts "Sending POST '#{request.body}' to /v1#{path}"
      http.request(request)
    end

    def api_put(path, data)
      http = Net::HTTP.new(@host, @port)
      http.use_ssl = true
      request = Net::HTTP::Put.new("/v1#{path}", header)
      request.basic_auth @username, @password
      request.body = data.to_json
      puts "Sending PUT '#{request.body}' to /v1#{path}"
      http.request(request)
    end
  end
end
