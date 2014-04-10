require 'validators/allowed_to_post_validator'

class Video < ActiveRecord::Base
  include VideoProcessing

  validates :title, presence: true, uniqueness: true
  validates :user,  presence: true, allowed_to_post: true

  belongs_to :user

  scope :publisheds, -> { where(published: true) }
end
