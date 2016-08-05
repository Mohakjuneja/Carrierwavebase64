class Content

  include Mongoid::Document
  include Mongoid::Timestamps
  
  embeds_many :assets, cascade_callbacks: true
  accepts_nested_attributes_for :assets, :autosave => true#, limit: 2
  
  field :title, type: String
  field :description, type: String
  field :pages, type: Integer, default: 1

  field :available, type: Boolean, default: false
  
  field :asset_type, type: String
  field :asset_images, type: Array , :default => []
   
  #  ================
  #  = associations =
  #  ================

  validates_presence_of :title, :description

end