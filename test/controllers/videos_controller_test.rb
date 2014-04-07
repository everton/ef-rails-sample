require 'test_helper'

class VideosControllerTest < ActionController::TestCase
  test 'get index' do
    get :index

    assert_response :success

    assert_select '#videos_list > li', count: 2 # from fixtures
  end

  test 'get show' do
    video = videos(:one)

    grant_pre_processed_video_at_path! video

    get :show, id: video.id

    assert_response :success

    video_path = "/videos/test/#{video.id}"

    assert_select 'video' do
      assert_select 'source[type=?][src=?]',
        'video/mp4', "#{video_path}/#{video.id}.mp4"

      assert_select 'source[type=?][src=?]',
        'video/ogg', "#{video_path}/#{video.id}.ogg"
    end

    assert_select 'img[src=?]', "#{video_path}/thumbs/thumb-1.jpg"
  end

  test 'get new' do
    get :new

    assert_response :success

    assert_select 'form[action=?][method=post]', videos_path
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

    assert_select 'form[action=?][method=post]', videos_path
  end

  private
  def grant_pre_processed_video_at_path!(video)
    FileUtils.mkdir_p Rails.root.join('public/videos/test/')

    src  = Rails.root.join('test/fixtures/videos/small-processed')
    dest = Rails.root.join("public/videos/test/#{video.id}")

    FileUtils.cp_r src, dest

    FileUtils.mv dest.join('small.mp4'), dest.join("#{video.id}.mp4")
    FileUtils.mv dest.join('small.ogg'), dest.join("#{video.id}.ogg")
  end
end
