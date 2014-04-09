class AllowedToPostValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank? || value.allowed_to_post?

    record.errors[attribute] << 'User not allowed to post video'
  end
end
