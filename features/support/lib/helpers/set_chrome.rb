# frozen_string_literal: true

def set_chrome
  Capybara.register_driver :chrome do |app|
    capybara_chrome_driver(app)
  end

  Capybara.javascript_driver = :chrome
  Capybara.default_driver = :chrome
  Capybara.default_max_wait_time = 1
end

def capybara_chrome_driver(app)
  Capybara::Selenium::Driver
    .new(
      app,
      browser: :chrome,
      options: Selenium::WebDriver::Chrome::Options.new(
        args: chrome_arguments
      )
    )
end

def chrome_arguments
  return %w[--disable-gpu --disable-popup-blocking --no-sandbox --window-size=3000,3000] unless running_headless
  %w[--disable-gpu --no-sandbox headless --disable-popup-blocking --window-size=3000,3000]
end

def running_headless
  translate_to_bool(ENV['HEADLESS'])
end

def translate_to_bool(env_var)
  {
    'true'  =>  true,
    true    =>  true,
    'false' =>  false,
    false   =>  false,
    nil     =>  true
  }[env_var]
end
