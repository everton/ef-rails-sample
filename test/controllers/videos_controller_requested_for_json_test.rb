require 'test_helper'

class VideosControllerRequestedForJsonTest < ActionController::TestCase
  setup do
    @controller = VideosController.new

    request.env['HTTP_ACCEPT'] = 'application/json'

    http_login! @george.email, '123'
  end

  should_get_with_success :index

  should_get_with_success :show, id: -> { @john_unpublished_video.id }

  test 'post of valid params to create' do
    post :create, video: {
      title: 'New video', description: 'Lorem Ipsum', user_id: @john.id
    }

    assert_response :success
  end

  test 'post of invalid params to create' do
    post :create, video: { title: '   ' }
    assert_response :unprocessable_entity
  end

  test 'patch valid params to update' do
    patch :update, id: @john_video.id, video: {
      title: 'Updated title'
    }

    assert_response :success
  end

  test 'patch invalid params to update' do
    patch :update, id: @john_video.id, video: {
      title: '   '
    }

    assert_response :unprocessable_entity
  end

  test 'delete to destroy' do
    assert_difference -> { Video.count }, -1 do
      delete :destroy, id: @john_video.id
    end

    assert_response :success
  end
end
