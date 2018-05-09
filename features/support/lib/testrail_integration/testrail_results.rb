# frozen_string_literal: true

module Testrail
  class TestrailResults
    require_all 'features/support/lib/helpers'

    def initialize
      @results
    end

    def collect
      all_results = result_files.map do |result_file|
        JSON.parse(File.read(result_file))['results']
      end.flatten

      @results = JSON.parse(JSON.pretty_generate('results': all_results))
      delete_all_feature_result_files

      self
    end

    def push
      @run = TestrailRun.new(case_ids: test_case_ids)
      return self if no_results_to_push
      upload_all_results_to_new_run
      self
    end

    def run_id
      @run.id
    end

    private

    def test_case_ids
      @project = TestrailProject.new(project_id)
      @results['results'].map do |test_case|
        unless @project.has_test_case?(test_case)
          new_case = TestrailCase.new(test_case)
          @project.update_list_with(new_case)
        end
        test_case['case_id'] = id_of(test_case)
        id_of(test_case)
      end
    end

    def id_of(test_case)
      @project.cases_and_ids[test_case['title'].hash]
    end

    def result_files
      Dir["#{directory_for_results}/*.json"] - Dir["#{directory_for_results}/all_results.json"]
    end

    def directory_for_results
      "testrail_results/#{platform_and_browser_with_versions}"
    end

    def no_results_to_push
      @results['results'].empty?
    end

    def upload_all_results_to_new_run
      api_client.send_post(
        "add_results/#{@run.id}",
        results_updated_with_test_id
      )
    end

    def delete_all_feature_result_files
      result_files.each { |file| FileUtils.rm(file) }
    end

    def results_updated_with_test_id
      all_results = @results
      tests_in_run = all_tests_in_run

      all_results['results'].each do |result|
        result['test_id'] = tests_in_run.select do |r|
          r['case_id'] == result['case_id']
        end.first['id']
      end

      save_as_backup(all_results)

      all_results
    end

    def save_as_backup(results)
      File.open("results_backup_#{Time.now.strftime('%Y-%m-%d_%H%M%S')}.json", 'w+') do |f|
        f << JSON.pretty_generate(results)
      end
    end

    def all_tests_in_run
      api_client.send_get("get_tests/#{@run.id}")
    end
  end
end
