class Answer < ActiveRecord::Base
  belongs_to :result
  belongs_to :offered_answer
end
