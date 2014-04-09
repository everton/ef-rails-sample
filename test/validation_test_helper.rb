module ValidationTestHelper
  # Usage:
  #   assert_bad_value(described, :foo, 'bar', 'Bar not valid for foo')
  #   assert_bad_value(described, :foo, 'bar', :invalid, 'Are not validating')
  #   assert_bad_value(SomeClass, :foo, 'bar', :invalid, 'Are not validating')
  def assert_bad_value(described, attr, value, validation_msg, fail_msg = nil)
    described = described.new if described.is_a? Class

    validation_msg = error_message_for(validation_msg) if
      validation_msg.is_a? Symbol

    fail_msg ||= "#{described.class.name} with #{attr} '#{value}'" +
      " expected to be invalid"

    described.send("#{attr}=", value)

    refute described.valid?, fail_msg

    assert_includes described.errors[attr], validation_msg
  end

  # Usage:
  #   assert_good_value(described, :foo, 'bar')
  #   assert_good_value(SomeClass, :foo, 'bar')
  #   assert_good_value(described, :foo, 'bar', 'Bar not valid on foo')
  def assert_good_value(described, attr, value, fail_msg = nil)
    described = described.new if described.is_a? Class

    described.send("#{attr}=", value)

    described.valid? # just validates it, don't assert about this,
    # another attributes can be invalid and we are not testing them now

    fail_msg ||= "Expected #{attr} '#{value}'" +
      " to be valid on #{described.class.name}.\n" +
      "Errors on #{attr}: <#{described.errors.inspect}>"

    assert_empty described.errors[attr], fail_msg
  end

  def error_message_for(kind, options = {})
    kind = kind.to_sym
    if I18n.t('activerecord.errors.messages').has_key? kind
      I18n.t("activerecord.errors.messages.#{kind}", options)
    else
      I18n.t("errors.messages.#{kind}", options)
    end
  end
end
