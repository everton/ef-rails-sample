require 'test_helper'

class VideosControllerUnloggedTest < ActionController::TestCase
  setup { @controller = VideosController.new }

  should_require_login_for :get, :new

  should_require_login_for :post, :create

  should_require_login_for :get, :edit, id: 'XXX'

  should_require_login_for :patch, :update, id: 'XXX'

  should_require_login_for :delete, :destroy, id: 'XXX'

  should_get_with_success :index, action_title: 'Videos' do
    # Published videos from fixtures
    assert_select '#videos_list .video', count: 3
  end

  test 'get show for published video' do
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

  test 'get show for unpublished video' do
    get :show, id: @john_unpublished_video.id

    assert_redirected_to login_path,
      'Unpiblished video presented for unlogged user'
  end
end
