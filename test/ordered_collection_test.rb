require 'test_helper'


class OrderedCollectionTest < ActiveSupport::TestCase
  load_schema

  def users(name)
    User.find_by_name(name)
  end

  def test_structure
    assert_equal true,  User.new.reorder_collection
  end

  def test_update_number
    user = users(:user_1)
    assert user.update_attribute(:number, 3)
    assert_equal 2, users(:user_3).number
    assert_equal 1, users(:user_2).number
    assert_equal 3, users(:user_1).number
  end

  def test_create
    user = User.create('name' => 'user_4')
    assert_equal 1, user.number
    assert_equal 2, users('user_1').number
    assert_equal 4, users('user_3').number
  end
end
