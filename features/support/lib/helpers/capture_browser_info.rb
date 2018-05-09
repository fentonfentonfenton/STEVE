# frozen_string_literal: true

def browser_information_already_captured
  ENV['BROWSER_NAME']
end

def capture_browser_information
  info = page.driver.browser.capabilities

  ENV['BROWSER_NAME'] = info[:browser_name]
  ENV['BROWSER_VERSION'] = (info['browserVersion'] ||= info.version)
  ENV['PLATFORM_NAME'] = (info['platformName'] ||= info.platform.to_s)
  ENV['PLATFORM_VERSION'] = (info['platformVersion'] ||= '')

  save_to_run_metadata_to_file if running_in_parallel
end

def running_in_parallel
  {
    'true' => true,
    'false' => false,
    nil => false
  }[ENV['PARALLEL_TESTING']]
end

def save_to_run_metadata_to_file
  File.open('test_run_metadata.json', 'w+') do |f|
    f << JSON.pretty_generate(metadata_hash)
  end
end

def metadata_hash
  {
    platform: ENV['PLATFORM_NAME'],
    platform_version: ENV['PLATFORM_VERSION'],
    browser: ENV['BROWSER_NAME'],
    browser_version: ENV['BROWSER_VERSION']
  }
end
