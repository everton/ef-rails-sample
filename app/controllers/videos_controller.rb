class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update]

  def index
    @videos = Video.all
  end

  def show
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html do
          redirect_to @video, notice: 'Video was successfully created.'
        end
      else
        format.html { render action: 'new' }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @video.update_attributes video_params
        format.html do
          redirect_to @video, notice: 'Video was successfully updated.'
        end
      else
        format.html { render action: 'edit' }
      end
    end
  end

  private
  def video_params
    params.require(:video).permit(:title, :description, :video)
  end

  def set_video
    @video = Video.find params[:id]
  end
end
