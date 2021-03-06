# -*- coding: utf-8 -*-

module VideoProcessing
  extend ActiveSupport::Concern

  included do
    attr_accessor :video

    after_save :process_video
    after_destroy :delete_videos_folder
  end

  private
  def process_video
    return unless video

    Resque.enqueue(ThumbsProcessor, self.id, video.path)
    Resque.enqueue(   Mp4Processor, self.id, video.path)
    Resque.enqueue(   OggProcessor, self.id, video.path)
  end

  def delete_videos_folder
    FileUtils.rm_rf Rails.root.join("public/videos/test/#{id}")
  end
end
