class Asset

  include Mongoid::Document
  
  embedded_in :content

  mount_uploader :asset, Uploader

  store_in_background :asset, ExampleJob

  field :asset_tmp, type: String

  #override the embedded models find method
  def self.find(id)
    root = Content.where('assets._id' => BSON::ObjectId(id)).first
    root.assets.find(id)
  end
  
end