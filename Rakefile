# frozen_string_literal: true

Rake.add_rakelib 'lib/tasks'
require 'cucumber'
require 'cucumber/rake/task'

Cucumber::Rake::Task.new(:features) do |t|
  t.cucumber_opts = 'features --format pretty'
end

task default: [:features]

def run_tests(platform, browser, version, driver)
  system("platform=\'#{platform}\' browserName=\'#{browser}\' "\
    "version=\'#{version}\' TEST_ENV=\'#{driver}\' "\
    "bundle exec cucumber --format pretty -c --tags @saucelabs")
end

task :windows_10_chrome_64 do
  run_tests('Windows 10', 'Chrome', '64.0', 'saucelabs')
end

task :windows_10_firefox_58 do
  run_tests('Windows 10', 'Firefox', '58.0', 'saucelabs')
end

task :windows_7_ie_11 do
  run_tests('Windows 7', 'Internet Explorer', '11.0', 'saucelabs')
end

task :mac_os_10_13_safari_11 do
  run_tests('macOS 10.13', 'Safari', '11.0', 'saucelabs')
end

multitask saucelabs_tests: %i[
  windows_10_chrome_64
  windows_10_firefox_58
  windows_7_ie_11
  mac_os_10_13_safari_11
]
