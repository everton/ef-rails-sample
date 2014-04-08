class AddAllowedToPostVideoToVideos < ActiveRecord::Migration
  def change
    add_column :users, :allowed_to_post, :boolean, default: false
  end
end
