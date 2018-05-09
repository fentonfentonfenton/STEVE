# frozen_string_literal: true

def testrail_credentials_invalid
  require 'net/http'
  require 'openssl'

  @request = Net::HTTP::Get.new(testrail_test_uri)
  @request.basic_auth(ENV['TESTRAIL_USERNAME'], ENV['TESTRAIL_PASSWORD'])
  @request.content_type = 'application/json'

  run_network_call

  return true unless @response.code == '200'
  false
end

def run_network_call
  Net::HTTP
    .start(
      testrail_test_uri.host,
      testrail_test_uri.port,
      use_ssl: testrail_test_uri.scheme == 'https',
      verify_mode: OpenSSL::SSL::VERIFY_NONE
    ) do |https|
      @response = https.request @request
      @response.code
    end
end

def testrail_test_uri
  URI("#{ENV['TESTRAIL_URL']}/index.php?/api/v2/get_users")
end
