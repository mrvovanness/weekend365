class Answer < ActiveRecord::Base
  belongs_to :offered_question
  validates :mark, presence: true
end
