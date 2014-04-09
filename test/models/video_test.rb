require 'fileutils'

require 'test_helper'

class VideoTest < ActiveSupport::TestCase
  include ActionDispatch::TestProcess

  test 'video creation' do
    video_file = fixture_file_upload 'videos/small.flv'

    assert_difference ->{ Video.count } do
      video = Video.create title: 'Lorem Ipsum',
        user: @john, video: video_file

      videos_path = Rails.root.join "public/videos/test/#{video.id}"

      assert File.exist? videos_path.join "#{video.id}.mp4"
      assert File.exist? videos_path.join "#{video.id}.ogg"

      assert File.exist? videos_path.join "thumbs/thumb-1.jpg"
    end
  end

  test 'video files deleted when video destroyed' do
    grant_pre_processed_video_at_path! @john_video

    assert_difference ->{ Video.count }, -1 do
      @john_video.destroy

      video_folder = Rails.root.join("public/videos/test/#{@john_video.id}")

      refute File.exist?(video_folder),
        'Video folder was not deleted after record deletion'
    end
  end

  test 'video creation only by allowed users' do
    allowed, not_allowed = @john, @ringo

    assert_good_value Video, :user, allowed

    assert_bad_value Video, :user, not_allowed,
      'User not allowed to post video'
  end
end
