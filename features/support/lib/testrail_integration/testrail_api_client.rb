# frozen_string_literal: true

module Testrail
  def api_client
    client             =   TestRail::APIClient.new(ENV['TESTRAIL_URL'])
    client.user        =   ENV['TESTRAIL_USERNAME']
    client.password    =   ENV['TESTRAIL_PASSWORD']
    client
  end
end
