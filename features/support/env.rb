# frozen_string_literal: true

Bundler.require
require 'capybara/cucumber'
require_all 'features/support/lib'
require 'site_prism'
Dotenv.load

if testrail_enabled && missing_testrail_environment_variables
  abort 'Missing environment variables for testrail'
end

if missing_s3_environment_variables
  abort 'Missing environment variables for the s3 bucket'
end

use_hooks_for(test_environment)

at_exit do
  if testrail_enabled && valid_testrail_project && !running_in_parallel && scenarios_executed
    testrail_results = TestrailResults.new.collect.push
    Webhook.new(run_id: testrail_results.run_id).post
  end
end
