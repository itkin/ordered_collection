require 'test_helper'


class OrderedCollectionTest < ActiveSupport::TestCase
  load_schema

  def users(name)
    User.find_by_name(name)
  end

  def posts(title)
    Post.find_by_title(title)
  end

  def interviews(title)
    Interview.find_by_title(title)
  end


  def test_structure
    assert_equal true,  User.new.reorder_collection
  end

  def test_update_number
    user = users(:user_1)
    assert user.update_attribute(:number, 3)
    assert_equal 2, users(:user_3).number, "fails because test_create is runned before"
    assert_equal 1, users(:user_2).number
    assert_equal 3, users(:user_1).number
  end

  def test_create
    user = User.create('name' => 'user_4')
    assert_equal 1, user.number
    assert_equal 2, users('user_1').number
    assert_equal 4, users('user_3').number
  end

  def test_order_collection_with_parent
    assert post =  users('user_1').posts.create(:title => 'post_5')
    assert_equal 1, post.number
    assert_equal 2, posts(:post_1).number
    assert_equal 3, posts(:post_2).number
    assert_equal 4, posts(:post_3).number
    assert_equal 1, posts(:post_4).number
  end

  def test_place_new_to_end_of_collection
    assert interview =  users('user_1').interviews.create(:title => 'interview_5')
    assert_equal 4, interview.number
    assert_equal 1, interviews(:interview_1).number
    assert_equal 2, interviews(:interview_2).number
    assert_equal 3, interviews(:interview_3).number
    assert_equal 1, interviews(:interview_4).number
  end

  def test_place_new_to_the_middle_of_collection
    assert interview =  users('user_1').interviews.create(:title => 'interview_6', :number => 2)
    assert_equal 2, interview.number
    assert_equal 1, interviews(:interview_1).number
    assert_equal 3, interviews(:interview_2).number
    assert_equal 4, interviews(:interview_3).number
    assert_equal 1, interviews(:interview_4).number
  end

end
