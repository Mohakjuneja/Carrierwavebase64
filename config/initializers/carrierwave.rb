CarrierWave.configure do |config|
  config.fog_credentials = {
    :provider               => 'AWS',
    :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
    :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"],
    :region                 => ENV["S3_REGION"]
  }
  
  config.fog_directory = ENV["BUCKET_NAME"]
  config.fog_public = true
  config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}

  if Rails.env.production?
    config.cache_dir = "#{Rails.root}/tmp/uploads"
  end
end

FOG_STORAGE ||= Fog::Storage.new({
  :provider               => 'AWS',
  :aws_access_key_id      => ENV["AWS_ACCESS_KEY_ID"],
  :aws_secret_access_key  => ENV["AWS_SECRET_ACCESS_KEY"],
  :region                 => ENV["S3_REGION"]
}).directories.get(ENV["BUCKET_NAME"])

