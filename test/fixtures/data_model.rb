
class User < ActiveRecord::Base
  order_collection_by :number

  has_many :posts
  has_many :interviews
end

class Post < ActiveRecord::Base

  belongs_to :user

  order_collection_by :number, :asc, :parent => :user

end

class Interview < ActiveRecord::Base

  belongs_to :user

  order_collection_by :number, :asc, :parent => :user, :new_instance => :end

end