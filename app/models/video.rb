class Video < ActiveRecord::Base
  attr_accessor :video

  after_save :process_video

  validates :title, presence: true, uniqueness: true

  private
  def process_video
    return unless video

    Resque.enqueue(ThumbsProcessor, self.id, video.path)
    Resque.enqueue(   Mp4Processor, self.id, video.path)
    Resque.enqueue(   OggProcessor, self.id, video.path)
  end
end
