
class User < ActiveRecord::Base
  order_collection_by :number

  has_many :posts
end

class Post < ActiveRecord::Base

  belongs_to :user

  order_collection_by :number, :asc, :parent => :user

end