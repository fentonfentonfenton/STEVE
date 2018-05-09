# frozen_string_literal: true

module Testrail
  class TestrailRun

    def initialize(case_ids:)
      @test_case_ids = case_ids
      @new_run = create_new_run
    end

    def id
      @new_run['id']
    end

    private

    def create_new_run
      milestone = milestone_with_version || add_milestone
      @new_run = api_client.send_post(
        "add_run/#{project_id}",
        'name': run_name,
        'milestone_id': milestone['id'],
        'include_all': false,
        'case_ids': @test_case_ids
      )
    end

    def add_milestone
      api_client.send_post(
        "add_milestone/#{project_id}",
        'name': version
      )
    end

    def milestone_with_version
      all_milestones.detect { |milestone| milestone['name'] == version }
    end

    def all_milestones
      api_client.send_get(
        "get_milestones/#{project_id}"
      )
    end

    def run_name
      "#{platform_and_version} - "\
      "#{run_information.browser}_#{run_information.browser} - "\
      "#{Time.now.strftime('%Y-%m-%d %H:%M:%S')}"
    end
  end
end
