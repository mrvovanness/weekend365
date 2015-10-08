class Answer < ActiveRecord::Base
  belongs_to :result
  belongs_to :offered_answer

  scope :filter_by_employees, -> (employees_selected, survey) {
    where(result: Result.where(employee: employees_selected, 
                               company_survey: survey)) }
end
