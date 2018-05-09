# frozen_string_literal: true

module Testrail
  def error_message
    unless no_error_message?
      return truncated_error_message if @scenario.exception.message.length > 250
      @scenario.exception.message
    end
  end

  def truncated_error_message
    "#{@scenario.exception.message[0..100]}... "\
    'Message too long, truncating....Full message in '\
    "Jenkins..#{@scenario.exception.message.split(//).last(60).join}"
  end

  def no_error_message?
    @scenario.exception.nil?
  end
end
