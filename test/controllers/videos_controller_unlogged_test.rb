require 'test_helper'

class VideosControllerUnloggedTest < ActionController::TestCase
  setup { @controller = VideosController.new }

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

  test 'get new requires logged user' do
    get :new
    assert_redirected_to login_path
  end

  test 'post to create requires logged user' do
    post :create, video: { title: 'New video' }
    assert_redirected_to login_path
  end

  test 'get edit requires logged user' do
    get :edit, id: @john_video.id
    assert_redirected_to login_path
  end

  test 'patch to update requires logged user' do
    patch :update, id: @john_video.id, video: {
      title: 'Updated title'
    }

    assert_redirected_to login_path
  end

  test 'delete to destroy requires logged user' do
    delete :destroy, id: @john_video.id
    assert_redirected_to login_path
  end
end
