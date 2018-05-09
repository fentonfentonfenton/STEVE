# frozen_string_literal: true

def use_hooks_for(test_environment)
  return all_saucelabs_hooks if test_environment == 'saucelabs'
  default_hooks
end

def default_hooks
  set_chrome
  return testrail_hooks if testrail_enabled
  after_hook
end

def after_hook
  After do
    if screenshots_enabled
      screenshot = Screenshot.new(
        capybara_session: page
      )

      screenshot.upload
      screenshot.delete
    end
    Capybara.current_session.driver.quit
  end
end
