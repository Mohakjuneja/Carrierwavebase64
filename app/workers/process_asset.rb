class ProcessAsset
  include Sidekiq::Worker

  def perform(content_id)
    content = Content.find(id: content_id)
    file = content.assets[0].asset
    if file.grim.count > 0
      content.pages = file.grim.count
      preview = file.create_preview
      content.assets[0].preview = File.open(preview)
      pages = []
      pages = file.convert_pdf_to_images
      store = content.assets[0].asset.store_dir
      # store = "uploads/asset/asset/#{content_id}"
      pages.each.with_index(1) do |tmp_file,index|
        file = FOG_STORAGE.files.create(
          :key    => "#{store}/page#{index}",
          :body   => File.open(tmp_file),
          :public => false
        )
        content.asset_images << file.key
      end
      content.available = true
      content.save!
    else
      raise 'PDF has no content'
    end
    # remember to clear cache
    # File.delete(preview)
    # pages.each do |page|
    #   File.delete(page)
    # end
  end

end