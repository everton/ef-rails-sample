require 'test_helper'

class VideosControllerTest < ActionController::TestCase
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

  test 'get new' do
    get :new

    assert_response :success

    assert_action_title 'New Video'

    assert_form videos_path
  end

  test 'post of valid params to create' do
    assert_difference -> { Video.count } do
      post :create, video: { title: 'New video', description: 'Lorem Ipsum' }
    end

    new_video = assigns(:video)

    assert_redirected_to video_path(new_video)
  end

  test 'post of invalid params to create' do
    assert_no_difference -> { Video.count } do
      post :create, video: { title: '   ', description: 'Lorem Ipsum' }
    end

    assert_response :success
    assert_template :new

    assert_select '#error_explanation .error', count: 1

    assert_form videos_path
  end

  test 'get edit' do
    get :edit, id: @john_video.id

    assert_response :success

    assert_action_title "Edit video #{@john_video.title}"

    assert_form video_path(@john_video), method: :patch
  end


  test 'patch valid params to update' do
    patch :update, id: @john_video.id, video: {
      title: 'Updated title'
    }

    assert_redirected_to video_path(@john_video)

    assert_equal 'Updated title', @john_video.reload.title
  end

  test 'patch invalid params to update' do
    original_title = @john_video.title

    patch :update, id: @john_video.id, video: {
      title: '   '
    }

    assert_response :success
    assert_template :edit

    assert_action_title "Edit video #{original_title}"

    assert_select '#error_explanation .error', count: 1

    assert_form video_path(@john_video), method: :patch
  end

  test 'delete to destroy' do
    assert_difference -> { Video.count }, -1 do
      delete :destroy, id: @john_video.id
    end

    assert_redirected_to videos_path
  end
end
