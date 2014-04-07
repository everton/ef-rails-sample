require 'fileutils'

class ThumbsProcessor
  @queue = :videos

  def self.perform(video_id, src_video_path)
    thumbs_folder = Rails.root.join "public/videos/#{Rails.env}/#{video_id}/thumbs"

    FileUtils.mkdir_p thumbs_folder

    Resque.logger.info `avconv -i '#{src_video_path}' -bt 20M -r 1/60 -f image2 '#{thumbs_folder}/thumb-%00d.jpg' 2>&1`
  end
end
