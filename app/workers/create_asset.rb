class CreateAsset
  include Sidekiq::Worker

  include ApiFileUpload

  def perform(content_id,assets)
    content = Content.find(content_id)  
    if assets && assets.is_a?(Array)
      assets.each do |k|
        k["asset"] = parse_image_data(k["asset"])
        content.assets.create(:asset => k["asset"])
      end
      content.set(asset_type: content.assets.first.asset.file.extension)
    end
    ProcessAsset.perform_async(content_id) unless content.asset_type != 'pdf'
    ensure
      clean_tempfile
  end

end