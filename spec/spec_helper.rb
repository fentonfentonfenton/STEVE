# frozen_string_literal: true

require 'webmock/rspec'
WebMock.disable_net_connect!(allow_localhost: true)

RSpec.configure do |config|
  config.before(:each) do
    stub_request(:get, 'https://invalid_credentials.testrail.net'\
      '/index.php?/api/v2/get_users').with(
        headers: {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 401, body: '', headers: {})

    stub_request(:get, 'https://invalid_url.testrail.net'\
      '/index.php?/api/v2/get_users').with(
        headers: {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 401, body: '', headers: {})

    stub_request(:get, 'https://valid_url.testrail.net'\
      '/index.php?/api/v2/get_users').with(
        headers: {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 200, body: '', headers: {})

    stub_request(:get, 'https://invalid_project_id.testrail.net'\
      '/index.php?/api/v2/get_projects').with(
        headers: {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 200, body: [
        {
          'id' => 1,
          'name' => 'TEST PROJECT 1',
          'suite_mode' => 1,
          'url' => 'https://example.testrail.net/index.php?/projects/overview/1'
        }
      ].to_json, headers: {})

    stub_request(:get, 'https://valid_project_id.testrail.net'\
     '/index.php?/api/v2/get_projects').with(
       headers: {
         'Content-Type' => 'application/json'
       }
     ).to_return(status: 200, body: [
       {
         'id' => 1,
         'name' => 'TEST PROJECT 1',
         'suite_mode' => 1,
         'url' => 'https://example.testrail.net/index.php?/projects/overview/1'
       }
     ].to_json, headers: {})

    stub_request(:get, 'https://scenario-not-in-project.testrail.net'\
      '/index.php?/api/v2/get_cases/1').with(
        headers: {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 200, body: [
        {
          'id': 1234,
          'title': 'Case 1'
        },
        {
          'id': 1235,
          'title': 'Case 2'
        }
      ].to_json, headers: {})

    stub_request(:get, 'https://scenario-already-in-project.testrail.net'\
      '/index.php?/api/v2/get_cases/1').with(
        headers: {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 200, body: [
        {
          'id': 1236,
          'title': 'this is a test Scenario'
        }
      ].to_json, headers: {})

    stub_request(:get, 'https://valid_project_id.testrail.net'\
      '/index.php?/api/v2/get_milestones/1').with(
        headers: {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 200, body: [
        {
          'id': 1,
          'name': 'AlreadyThere1',
          'url': 'https://valid_project_id.testrail.net'\
          '/index.php?/milestones/view/1'
        }
      ].to_json, headers: {})

    stub_request(:post, 'https://valid_project_id.testrail.net'\
      '/index.php?/api/v2/add_milestone/1').with(
        body: %Q({\"name\":\"NotThere1\"}),
        headers:
        {
          'Content-Type' => 'application/json'
        }
      ).to_return(status: 200, body:
        {
          'id': 1,
          'name': 'AlreadyThere1',
          'url': 'https://valid_project_id.testrail.net'\
          '/index.php?/milestones/view/1'
        }.to_json, headers: {})
  end

  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
