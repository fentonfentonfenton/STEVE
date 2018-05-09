# frozen_string_literal: true

def screenshots_enabled
  {
    'true' => true,
    'false' => false,
    nil => false
  }[ENV['SCREENSHOTS']] ||= false
end
