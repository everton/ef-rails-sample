class Video < ActiveRecord::Base
  include VideoProcessing

  validates :title, presence: true, uniqueness: true
end
