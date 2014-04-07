require 'fileutils'

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  setup do
    @inline  = Resque.inline
    Resque.inline = true
  end

  teardown do
    Resque.inline = @inline
    FileUtils.rm_rf Rails.root.join 'public/videos/test/'
  end

  test 'video creation' do
    video_file =
      fixture_file_upload 'videos/2001-a-space-odyssey-teaser.mp4'

    assert_difference ->{ Video.count } do
      video = Video.create title: 'Lorem Ipsum', video: video_file

      videos_path = Rails.root.join "public/videos/test/#{video.id}"

      assert File.exist? videos_path.join "#{video.id}.mp4"
      assert File.exist? videos_path.join "#{video.id}.ogg"

      assert File.exist? videos_path.join "thumbs/thumb-1.jpg"
    end
  end
end
