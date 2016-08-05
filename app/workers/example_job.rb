class ExampleJob < ActiveJob::Base
  
  include ::CarrierWave::Workers::StoreAssetMixin
  # Set the Queue as Default
  queue_as :default

  after_perform do
    content = Content.where('assets._id' => BSON::ObjectId(id)).first
    tmp = content.assets.map{|x| x[:asset_tmp]}
    if !tmp.any? && content.asset_type != 'pdf'
      content.set(available: true)      
    end
  end

  # def when_not_ready
  #   retry_job
  # end

end