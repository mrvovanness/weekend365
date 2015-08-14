class Answer < ActiveRecord::Base
  belongs_to :question
  validates :mark, presence: true
end
