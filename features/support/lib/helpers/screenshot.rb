# frozen_string_literal: true

require 'aws-sdk'
require 'digest'

class Screenshot

  def initialize(capybara_session:)
    @page = capybara_session
    @file = screenshot_now
  end

  def upload
    s3_object.upload_file(@file, acl: 'public-read')
  end

  def url
    "#{ENV['S3_BUCKET_URL']}/#{sha256_of_file}"
  end

  def delete
    FileUtils.rm(@file)
  end

  private

  def s3_object
    s3_resource.bucket(ENV['S3_BUCKET_NAME']).object(sha256_of_file)
  end

  def s3_resource
    Aws::S3::Resource.new(
      region: ENV['S3_REGION'],
      endpoint: ENV['S3_ENDPOINT'],
      credentials: Aws::Credentials.new(
        ENV['S3_BUCKET_KEY'],
        ENV['S3_BUCKET_SECRET']
      )
    )
  end

  def sha256_of_file
    Digest::SHA256.hexdigest @file
  end

  def screenshot_now
    file = "#{SecureRandom.hex}.png"
    @page.save_screenshot(file)
    file
  end
end
