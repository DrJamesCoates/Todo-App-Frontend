require 'vcr'
require 'webmock/rspec'


# hook into lib - HTTParty
VCR.configure do |config|
  config.allow_http_connections_when_no_cassette = false
  config.cassette_library_dir = "./spec/cassettes"
  config.hook_into :webmock
  config.ignore_localhost = false
  config.configure_rspec_metadata!
end


WebMock.disable_net_connect!(allow: [
  'http://127.0.0.1:3000',
])