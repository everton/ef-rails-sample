require 'fileutils'

class Mp4Processor
  @queue = :videos

  def self.perform(video_id, src_video_path)
    dest_video_folder = Rails.root.join "public/videos/#{Rails.env}/#{video_id}"
    dest_video_path   = File.join dest_video_folder,  "#{video_id}.mp4"

    FileUtils.mkdir_p dest_video_folder

    FileUtils.rm_rf   dest_video_path

    Resque.logger.info `avconv -i '#{src_video_path}' -strict experimental -c:v libx264 '#{dest_video_path}' 2>&1`
  end
end
