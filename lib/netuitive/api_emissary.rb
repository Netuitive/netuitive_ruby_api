require 'net/http'
require 'rubygems'
require 'json'
require 'yaml'
require 'netuitive/ruby_config_manager'
class APIEmissary
	
	def initialize(apiId, baseAddr, port)
		@apiId=apiId
		@baseAddr=baseAddr
		@port=port
		@configManager=ConfigManager.new
	end 

	def sendElements(elements)
		if @configManager.isDebug?
			puts elements.to_json
		end

		uri = URI("#{@baseAddr}/ingest/#{@apiId}")
		req = Net::HTTP::Post.new(uri.path, initheader = {'Content-Type' =>'application/json'})
        req.body = elements.to_json
        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) do |http|
  			http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  			http.ssl_version = :SSLv3
  			http.request req
		end
		if (response.code != "202" and @configManager.isError?) or (@configManager.isInfo?)
			puts "Response from submitting netuitive metrics to api
			code: #{response.code}
			message: #{response.message}
			body: #{response.body}"
		end
	end
end
