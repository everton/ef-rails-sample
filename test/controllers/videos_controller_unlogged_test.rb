require 'test_helper'

class VideosControllerUnloggedTest < ActionController::TestCase
  setup { @controller = VideosController.new }

  should_require_login_for :get, :new

  should_require_login_for :post, :create

  should_require_login_for :get, :edit, id: 'XXX'

  should_require_login_for :patch, :update, id: 'XXX'

  should_require_login_for :delete, :destroy, id: 'XXX'

  test 'get index' do
    get :index

    assert_response :success

    assert_action_title 'Videos'

    assert_select '#videos_list > li', count: 4 # from fixtures
  end

  test 'get show' do
    grant_pre_processed_video_at_path! @john_video

    get :show, id: @john_video.id

    assert_response :success

    assert_action_title "Video #{@john_video.title}"

    video_path = "/videos/test/#{@john_video.id}"

    assert_select 'video' do
      assert_select 'source[type=?][src=?]',
        'video/mp4', "#{video_path}/#{@john_video.id}.mp4"

      assert_select 'source[type=?][src=?]',
        'video/ogg', "#{video_path}/#{@john_video.id}.ogg"
    end

    assert_select 'img[src=?]', "#{video_path}/thumbs/thumb-1.jpg"
  end
end
