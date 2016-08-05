# encoding: utf-8
require 'carrierwave/processing/mime_types'

class Uploader < CarrierWave::Uploader::Base

  include CarrierWave::MimeTypes
  process :set_content_type

  include CarrierWave::MiniMagick

  # offloading storage/processing to a background task  
  include ::CarrierWave::Backgrounder::Delay

  # storage :fog
  storage :file  
  # storage Rails.env == "production" ? :fog : :file

  def cache_dir
    "#{Rails.root}/tmp/cache/#{model.id}"
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # ActionController::Base.helpers.asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # def default_url
  #   "/assets/images/shared/missing_image.png"
  # end

  
  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  # version :thumb do
  #   process :resize_to_fit => [50, 50]
  # end


  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  def filename
    "#{secure_token}.#{file.extension}" if original_filename.present?
  end

  private

    def secure_token
      var = :"@#{mounted_as}_secure_token"
      model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.uuid)
    end

end