# frozen_string_literal: true

require 'net/http'
require 'curb'
require 'json'

# WILL CHANGE TO URL TO STEVE BOT
# WILL INCLUDE run_id

class Webhook

  def initialize(run_id:)
    @run_id = run_id
  end

  def post
    post_outgoing_webhook
  end

  private

  def post_outgoing_webhook
    Curl.post(ENV['SLACK_WEBHOOK_URL'], webhook_body)
  end

  def webhook_body
    {
      channel: ENV['SLACK_FEEDBACK_CHANNEL'], username: 'Automation.Feedback',
      text: message_text,
      icon_emoji: ':robot_face:', attachments: attachment
    }.to_json
  end

  def attachment
    [
      {
        title: 'TEST REPORT',
        title_link: "#{ENV['TESTRAIL_URL']}/index.php?/runs/"\
        "view/#{@run_id}&group_by=cases:section_id&group_order=asc"
      }
    ]
  end

  def message_text
    return default_message_text unless brittle_tests

    "#{default_message_text}\n\n"\
    ':mag_right: *Flakiness detected, '\
    'please investigate* :mag:'
  end

  def default_message_text
    results = collect_run_result_for(run_id: @run_id)

    "Project: #{project_name}\n"\
    "Platform: #{platform_and_browser_with_versions}\n"\
    "Passed: #{results[:passed]}\n"\
    "Failed: #{results[:failed]}\n"\
    "Pending: #{results[:pending]}\n"\
    "Skipped: #{results[:skipped]}\n"\
    "Undefined: #{results[:undefined]}"
  end
end
