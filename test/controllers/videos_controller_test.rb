require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  setup { login! @george }

  should_get_with_success :index, action_title: 'Videos' do
    # Logged users see Published and Unpublished videos from fixtures
    assert_select '#videos_list .video', count: 4
  end

  # Should get unpublished videos when logged
  should_get_with_success :show, id: -> { @john_unpublished_video.id }

  should_get_with_success :new, action_title: 'New Video' do
    assert_form videos_path
  end

  test 'post of valid params to create' do
    post :create, video: {
      title: 'New video', description: 'Lorem Ipsum', user_id: @john.id
    }

    new_video = assigns(:video)

    assert_equal @george, new_video.user # Use current user...

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

  should_get_with_success :edit, id: -> { @john_video.id } do
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
