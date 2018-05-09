# frozen_string_literal: true

module Testrail
  def update_result_json_with_scenario_result
    create_result_file_for_feature unless File.file?(result_file_for_the_feature)
    results = JSON.parse(File.read(result_file_for_the_feature))
    results['results'] << result_hash
    save_results_json_to_file(json: results)
  end

  def create_result_file_for_feature
    FileUtils.mkdir_p(directory_for_results) unless File.directory?(directory_for_results)

    File.open(result_file_for_the_feature, 'w+') do |f|
      f << '{"results": []}'
    end
  end

  def directory_for_results
    "testrail_results/#{platform_and_browser_with_versions}"
  end

  def result_file_for_the_feature
    "#{directory_for_results}/#{feature_name}_feature_results.json"
  end

  def feature_name
    @scenario.feature.name.gsub(/ |-|:|\//, '_').downcase
  end

  def result_hash
    {
      'title': @scenario.name,
      'section': @scenario.feature.name,
      'gherkin': scenario_gherkin,
      'status_id': status_id[@scenario.status],
      'elapsed': scenario_elapsed_time,
      'version': version,
      'custom_scenario_error_message': error_message,
      'custom_flaky': flaky_bool,
      'custom_screenshot': screenshot_message,
      'custom_scenario_line': scenario_line
    }
  end

  def scenario_line
    code_line = @scenario.source.select do |step|
      step.keyword.match? 'Scenario' if step.methods.include? :keyword
    end.first.file_colon_line
    "`#{code_line}`"
  end

  def scenario_elapsed_time
    @_scenario_elapsed_time ||= begin
      time = Time.at(Time.now - @scenario_start_time).strftime('%-Mm %-Ss')
      return '1s' if time.match? '0m 0s'
      time
    end
  end

  def flaky_bool
    return true if this_is_a_retry && this_scenario_passed
    $last_scenario = @scenario
    false
  end

  def this_is_a_retry
    $last_scenario == @scenario
  end

  def this_scenario_passed
    @scenario.passed?
  end

  def screenshot_message
    return "![Screenshot](#{@screenshot.url})" if @screenshot
    ''
  end

  def status_id
    {
      passed: 1,
      failed: 5,
      undefined: 6, # CUSTOM STATUS ID IN TESTRAIL
      pending: 7, # CUSTOM STATUS ID IN TESTRAIL
      skipped: 8 # CUSTOM STATUS ID IN TESTRAIL
    }
  end

  def save_results_json_to_file(json:)
    File.open(result_file_for_the_feature, 'w') do |f|
      f << JSON.pretty_generate(json)
    end
  end
end
