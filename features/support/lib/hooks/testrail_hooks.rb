# frozen_string_literal: true

def testrail_hooks
  include Testrail

  puts invalid_project_id_text unless valid_testrail_project

  Before do |scenario, _feature|
    @scenario = scenario
    @scenario_start_time = Time.now
  end

  After do |scenario, _feature|
    @scenario = scenario
    testrail_after_hooks
  end
end

def testrail_after_hooks
  if screenshots_enabled
    @screenshot = Screenshot.new(
      capybara_session: page
    )

    @screenshot.upload
    @screenshot.delete
  end
  capture_browser_information unless browser_information_already_captured
  update_result_json_with_scenario_result
  Capybara.current_session.driver.quit
end
