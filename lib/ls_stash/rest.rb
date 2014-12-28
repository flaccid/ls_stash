require 'net/http'
require 'net/https'
require 'uri'
require 'json'

def rest_request(endpoint, href, options)
  uri = URI.join(endpoint, href)
  puts "[GET] #{uri}" if options[:verbose]
  http = Net::HTTP.new(uri.host, uri.port)
  http.use_ssl = true
  request = Net::HTTP::Get.new(uri.request_uri)
  request.basic_auth(options[:user], options[:password])
  if options[:prettify]
    JSON.pretty_generate(JSON.parse(http.request(request).body))
  else
    JSON.parse(http.request(request).body)
  end
end
