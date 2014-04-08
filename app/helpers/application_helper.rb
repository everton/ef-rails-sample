module ApplicationHelper
  def action_title(title = nil, options = {}, &block)
    if title.nil? and block_given?
      title = capture(&block)
    end

    return '' unless title

    title = raw title
      .gsub(/[\n|\r|\t]+/, '')
      .gsub(/(\s)\1+/, '\1')
      .strip

    content_for :title, strip_tags(title).strip
    content_tag :h1, title, options
  end

  def main_thumb_of(video)
    asset_path "videos/#{Rails.env}/#{video.id}/thumbs/thumb-1.jpg"
  end

  def thumbs_of(video)
    thumbs_path = Rails.root
      .join "public/videos/#{Rails.env}/#{video.id}/thumbs/*.jpg"

    Dir[thumbs_path].each.map do |thumb|
      path = thumb.gsub Rails.root.join('public').to_s, ''

      asset_path(path)
    end
  end

  def video_path_of(video, format)
    id = video.id
    asset_path "videos/#{Rails.env}/#{id}/#{id}.#{format}"
  end
end
