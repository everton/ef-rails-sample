class VideosController < ApplicationController
  respond_to :html, :json

  require_login except: [:show, :index]

  before_action :set_video, only: [:show, :edit, :update, :destroy]

  def index
    @videos = Video.all
    @videos = @videos.publisheds unless logged_in?

    respond_with @videos
  end

  def show
    if @video.published?
      respond_with @video
    else
      if request.format.html?
        if logged_in?
          respond_with @video
        else
          require_login!
        end
      else
        require_http_login!
        respond_with @video
      end
    end
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params.merge user: current_user )
    respond_with @video, notice: 'Video was successfully created.'
  end

  def edit
  end

  def update
    @video.update_attributes video_params

    respond_with @video, notice: 'Video was successfully updated.'
  end

  def destroy
    @video.destroy
    respond_with @video
  end

  private
  def video_params
    params.require(:video).permit(:title, :description, :video, :published)
  end

  def set_video
    @video = Video.find params[:id]
  end
end
