# frozen_string_literal: true

module Testrail
  class TestrailCase

    def initialize(testcase)
      @testcase = testcase
      @created_testcase = create_test_case
      self
    end

    def id
      @created_testcase['id']
    end

    def title
      @created_testcase['title']
    end

    private

    def create_test_case
      new_test_case = api_client.send_post(
        "add_case/#{feature_section_id}",
        'title': @testcase['title'],
        'custom_gherkin': @testcase['gherkin']
      )
      new_test_case
    end

    def feature_section_id
      create_feature_section unless project_has_feature_section

      all_sections = api_client.send_get(
        "get_sections/#{project_id}"
      )

      feature_section = all_sections.detect do |section|
        section['name'] == @testcase['section']
      end
      feature_section['id']
    end

    def project_has_feature_section
      all_sections.any? { |section| section['name'] == @testcase['section'] }
    end

    def all_sections
      @_all_sections ||= begin
        api_client.send_get(
          "get_sections/#{project_id}"
        )
      end
    end

    def create_feature_section
      api_client.send_post(
        "add_section/#{project_id}",
        'name': @testcase['section']
      )
    end
  end
end
