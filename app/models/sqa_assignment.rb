class SqaAssignment < ActiveRecord::Base
  belongs_to :offered_survey
  belongs_to :offered_question
  belongs_to :offered_answer
end
