class VideosController < ApplicationController
  def index
    @videos = Video.all
  end

  def show
    @video = Video.find params[:id]
  end

  def new
    @video = Video.new
  end

  def create
    @video = Video.new(video_params)

    respond_to do |format|
      if @video.save
        format.html do
          redirect_to @video,
            notice: 'Video was successfully created.'
        end
      else
        format.html { render action: 'new' }
      end
    end
  end

  private
  def video_params
    params.require(:video).permit(:title, :description, :video)
  end
end
