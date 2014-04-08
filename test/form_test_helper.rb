module FormTestHelper
  def assert_form(action, options = {}, &block)
    method = options[:method] || :post

    if method == :put || method == :patch || method == :delete
      _method, method = method, :post
      test_body = Proc.new do |*args|
        assert_select "input[type='hidden'][name='_method']",
          value: _method

        block.call(*args) if block
      end
    else
      test_body = block
    end

    assert_select 'form[action=?][method=?]', action, method, &test_body
  end
end
