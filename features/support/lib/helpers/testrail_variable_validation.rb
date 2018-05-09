# frozen_string_literal: true

def test_environment
  ENV['TEST_ENV'] ||= 'chrome'
end

def missing_testrail_environment_variables
  testrail_env_variables.any?(&:nil?)
end

def testrail_env_variables
  [
    ENV['TESTRAIL_URL'],
    ENV['TESTRAIL_USERNAME'],
    ENV['TESTRAIL_PASSWORD'],
    ENV['TESTRAIL_PROJECT_ID']
  ]
end

def missing_test_case_id
  test_case_id.nil? && valid_testrail_project
end

def missing_test_case_in_project
  valid_testrail_project && !test_case_id.nil? &&
    !test_case_included_in_project(test_case_id)
end

def testrail_enabled
  {
    'true' => true,
    'false' => false,
    nil => false
  }[ENV['TESTRAIL']] ||= false
end

def invalid_project_id_text
  "Testrail Project #{ENV['TESTRAIL_PROJECT_ID']} is "\
  'not a valid Testrail Project ID.'
end

def scenario_missing_test_case_id_text
  'Scenario not tagged with Test Case ID (eg: @TCID=1234). '\
  'Need this to get it working with testrail'
end

def test_case_not_in_project_text
  "Test Case #{test_case_id} is not a available in Testrail Project "\
  "#{ENV['TESTRAIL_PROJECT_ID']}"
end
