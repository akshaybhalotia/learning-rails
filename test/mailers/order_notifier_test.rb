require 'test_helper'

class OrderNotifierTest < ActionMailer::TestCase
  test "received" do
    mail = OrderNotifier.received(orders(:one))
    assert_equal "Pragmatic Store Order Confirmation", mail.subject
    assert_equal ['akshay.b@multunus.com'], mail.to
    assert_equal 'Rails Learner <akshay.b@multunus.com>', mail[:from].value
    assert_match /Ruby/, mail.body.encoded
  end

  test "shipped" do
    mail = OrderNotifier.shipped(orders(:one))
    assert_equal "Pragmatic Store Order Shipped", mail.subject
    assert_equal ['akshay.b@multunus.com'], mail.to
    assert_equal 'Rails Learner <akshay.b@multunus.com>', mail[:from].value
    assert_match /Ruby/, mail.body.encoded
  end

end
