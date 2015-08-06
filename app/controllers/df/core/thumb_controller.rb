require_dependency 'application_controller'
module ::Df::Core
	class ThumbController < ::ApplicationController
		layout false
		skip_before_filter :preload_json, :check_xhr
		def index
			original = params[:original]
			upload = Upload.find_by(sha1: original) || Upload.find_by(url: original)
			if !upload
				render nothing: true, status: 404
			else
				originalPath = Discourse.store.path_for(upload)
				w = params[:width].to_i
				h = params[:height].to_i
				thumbnail = upload.thumbnail(w, h)
				if not thumbnail.present?
					createThumbnailsOriginalValue = SiteSetting.create_thumbnails?
					SiteSetting.create_thumbnails = true
					upload.create_thumbnail!(w, h)
					thumbnail = upload.thumbnail(w, h)
					SiteSetting.create_thumbnails = createThumbnailsOriginalValue
				end
				contentType = thumbnail.extension
				# Remove leading dot
				# http://stackoverflow.com/a/3614592
				contentType[0] = ''
				if 'jpg' == contentType
					contentType = 'jpeg'
				end
				send_file "#{Rails.root}/public#{thumbnail.url}",
					:disposition => 'inline',
					:type => "image/#{contentType}",
					:x_sendfile => true
			end
		end
	end
end

