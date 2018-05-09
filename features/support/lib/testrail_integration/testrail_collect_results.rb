# frozen_string_literal: true

module Testrail
  def collect_run_result_for(run_id:)
    @run_id = run_id
    puts 'There are retries in this run' if retried_test_cases.any?

    array_of_status_ids.inject Hash.new(0) do |hash, status|
      hash[translate_result[status]] += 1
      hash
    end
  end

  def all_results
    @_all_results ||= begin
      (0..(all_tests_in_run.count / 250) + 1).map do |page|
        api_client.send_get(
          "get_results_for_run/#{@run_id}&limit=250&offset=#{250 * page}"
        )
      end.flatten
    end
  end

  def all_tests_in_run
    api_client.send_get("get_tests/#{@run_id}")
  end

  def array_of_status_ids
    results_with_one_of_each_scenario.map do |result|
      result['status_id']
    end
  end

  def results_with_one_of_each_scenario
    (all_results.reject do |result|
      retried_test_cases.include? result['test_id']
    end + latest_of_retried).compact
  end

  def retried_test_cases
    @_retried_test_cases ||= begin
      count_of_test_ids = Hash.new(0)

      all_results.each do |result|
        count_of_test_ids[result['test_id']] += 1
      end

      count_of_test_ids.map do |test_id, count|
        test_id if count > 1
      end.compact
    end
  end

  def latest_of_retried
    retried_results = retried_test_cases.map do |retried_test_id|
      all_results.map do |result|
        result if result['test_id'] == retried_test_id
      end.compact
    end

    retried_results.map do |results|
      results.max_by { |result| result['created_on'] }
    end
  end

  def id_included_in_(result)
    retried_test_cases.include? result['test_id']
  end

  def translate_result
    {
      1 => :passed,
      5 => :failed,
      6 => :undefined,
      7 => :pending,
      8 => :skipped
    }
  end

  def brittle_tests
    return false unless retried_test_cases.any?
    brittle = latest_of_retried.map do |result|
      result['id'] if result['status_id'] == 1
    end.compact

    brittle.any?
  end
end
