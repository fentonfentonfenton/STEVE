# frozen_string_literal: true

def missing_s3_environment_variables
  screenshots_enabled && s3_env_variables.any?(&:nil?)
end

def s3_env_variables
  [
    ENV['S3_ENDPOINT'],
    ENV['S3_BUCKET_SECRET'],
    ENV['S3_REGION'],
    ENV['S3_BUCKET_KEY'],
    ENV['S3_BUCKET_URL'],
    ENV['S3_BUCKET_NAME']
  ]
end
