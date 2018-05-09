# frozen_string_literal: true

module Testrail
  class TestrailProject

    def initialize(id)
      @id = id
    end

    def cases_and_ids
      hashed_case_name_and_ids
    end

    def update_list_with(test_case)
      hashed_case_name_and_ids[test_case.title.hash] = test_case.id
    end

    def has_test_case?(test_case)
      hashed_case_name_and_ids[test_case['title'].hash]
    end

    private

    def hashed_case_name_and_ids
      @_hashed_case_name_and_ids ||= begin
        hashed_case_name_and_ids = {}
        all_test_cases_in_project.each do |test_case|
          hashed_case_name_and_ids[test_case['title'].hash] = test_case['id']
        end
        hashed_case_name_and_ids
      end
    end

    def all_test_cases_in_project
      @_all_test_cases_in_project ||= begin
        api_client.send_get(
          "get_cases/#{@id}"
        )
      end
    end
  end
end
