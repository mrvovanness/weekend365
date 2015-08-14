class Question < ActiveRecord::Base
  validates :title, :type, presence: true
  belongs_to :survey
  has_many :answers
end
