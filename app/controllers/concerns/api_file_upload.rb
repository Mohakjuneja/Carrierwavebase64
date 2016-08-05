module ApiFileUpload
	
	def parse_image_data(base64_asset)
	  filename = "content-asset"
	  in_content_type, encoding, string = base64_asset.split(/[:;,]/)[1..3]

	  @tempfile = Tempfile.new(filename)
      @tempfile.binmode
      @tempfile.write Base64.decode64(string)
      @tempfile.rewind
	  
	  # for security we want the actual content type, not just what was passed in
	  content_type = `file --mime -b #{@tempfile.path}`.split(";")[0]

	  # we will also add the extension ourselves based on the above
	  # if it's not pdf/jpg/jpeg/png, it will fail the validation in the upload model
	  extension = content_type.match(/jpg|jpeg|png|pdf/).to_s    
	  filename += ".#{extension}" if extension

	  ActionDispatch::Http::UploadedFile.new({
	    tempfile: @tempfile,
	    type: content_type,
	    filename: filename
	  })
	end

	def clean_tempfile
	  if @tempfile
	    @tempfile.close
	    @tempfile.unlink
	  end
	end

end