# frozen_string_literal: true

require_relative 'testrail_api_binding'
require 'digest'

module Testrail
  def valid_testrail_project
    return true if all_projects.detect do |project|
      project['id'].to_s == project_id
    end
    false
  end

  def all_projects
    api_client.send_get('get_projects')
  end

  def project_id
    ENV['TESTRAIL_PROJECT_ID']
  end

  def version
    ENV['VERSION'] ||= 'VERSION123'
  end

  def environment
    ENV['ENVIRONMENT'] ||= 'TEST_ENVIRONMENT'
  end

  def project_name
    project = api_client.send_get("get_project/#{project_id}")
    project['name']
  end
end
