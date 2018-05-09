# frozen_string_literal: true

def run_information
  if browser_information_already_captured
    OpenStruct.new(
      platform: ENV['PLATFORM_NAME'],
      platform_version: ENV['PLATFORM_VERSION'],
      browser: ENV['BROWSER_NAME'],
      browser_version: ENV['BROWSER_VERSION']
    )
  else
    OpenStruct.new(
      data = JSON.parse(File.read('test_run_metadata.json'))
    )
  end
end

def platform_and_browser_with_versions
  "#{platform_and_version}_#{browser_and_version}"
end

def browser_and_version
  "#{run_information.browser}"\
  "_#{run_information.browser_version}"
end

def platform_and_version
  return sauce_job.os if sauce_run?
  "#{run_information.platform}#{run_information.platform_version}"
end

def sauce_run?
  $session_id
end

def sauce_job
  SauceWhisk::Jobs.fetch $session_id
end

def scenarios_executed
  $last_scenario
end
