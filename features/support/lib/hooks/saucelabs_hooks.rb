# frozen_string_literal: true

def all_saucelabs_hooks
  set_saucelabs
  saucelabs_hooks
end

def set_saucelabs
  Capybara.default_max_wait_time = 20
  Capybara.default_driver = :selenium

  if testrail_enabled
    include Testrail
    puts invalid_project_id_text unless valid_testrail_project
  end
end

def saucelabs_hooks
  Before do |scenario|
    @scenario = scenario
    new_saucelabs_session
    @scenario_start_time = Time.now
  end

  After do |scenario|
    @scenario = scenario
    testrail_after_hooks if testrail_enabled
    sauce_after_hook
  end
end

def new_saucelabs_session
  @jobname = "#{@scenario.feature.name} - #{@scenario.name}"
  Capybara.register_driver :selenium do |app|
    capybara_sauce_driver(app)
  end

  Capybara.session_name = capybara_session_name

  @driver = Capybara.current_session.driver
  $session_id = @driver.browser.session_id
end

def capybara_sauce_driver(app)
  Capybara::Selenium::Driver
    .new(
      app,
      browser: :remote,
      url: saucelabs_url,
      desired_capabilities: saucelabs_desired_capabilities
    )
end

def saucelabs_url
  "https://#{ENV['SAUCE_USERNAME']}:"\
  "#{ENV['SAUCE_ACCESS_KEY']}@ondemand"\
  '.saucelabs.com:443/wd/hub'.strip
end

def saucelabs_desired_capabilities
  {
    version: ENV['version'],
    browserName: ENV['browserName'],
    platform: ENV['platform'],
    acceptSslCerts: true,
    name: @jobname
  }
end

def capybara_session_name
  "#{@jobname} - #{ENV['platform']} - "\
  "#{ENV['browserName']} - #{ENV['version']}"
end

def sauce_after_hook
  @driver.quit
  Capybara.use_default_driver

  if @scenario.exception
    SauceWhisk::Jobs.fail_job $session_id
  else
    SauceWhisk::Jobs.pass_job $session_id
  end
end
