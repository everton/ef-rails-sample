require 'fileutils'

class OggProcessor
  @queue = :videos

  def self.perform(video_id, src_video_path)
    dest_video_folder = Rails.root.join "public/videos/#{Rails.env}/#{video_id}"
    dest_video_path   = File.join dest_video_folder, "#{video_id}.ogg"

    FileUtils.mkdir_p dest_video_folder

    FileUtils.rm_rf   dest_video_path

    Resque.logger.info `avconv -i '#{src_video_path}' -strict experimental -c:v libtheora #{dest_video_path}  2>&1`
  end
end
