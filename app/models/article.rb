class Article < ActiveRecord::Base
  validates :title, :body, presence: true
  translates :body
end
