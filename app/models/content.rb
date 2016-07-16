class Content

  include Mongoid::Document
  include Mongoid::Timestamps

  mount_base64_uploader :image, AvatarUploader

  field :title, type: String
  field :description, type: String
  field :image, type: String

end