require 'fileutils'

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  test 'video creation' do
    video_file = fixture_file_upload 'videos/small.flv'

    assert_difference ->{ Video.count } do
      video = Video.create title: 'Lorem Ipsum', video: video_file

      videos_path = Rails.root.join "public/videos/test/#{video.id}"

      assert File.exist? videos_path.join "#{video.id}.mp4"
      assert File.exist? videos_path.join "#{video.id}.ogg"

      assert File.exist? videos_path.join "thumbs/thumb-1.jpg"
    end
  end

  test 'video files deleted when video destroyed' do
    video = videos(:one)

    grant_pre_processed_video_at_path! video

    assert_difference ->{ Video.count }, -1 do
      video.destroy

      video_folder = Rails.root.join("public/videos/test/#{video.id}")

      refute File.exist?(video_folder),
        'Video folder was not deleted after record deletion'
    end
  end
end
