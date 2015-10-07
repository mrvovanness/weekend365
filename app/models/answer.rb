class Answer < ActiveRecord::Base
  belongs_to :result
  belongs_to :offered_answer

  scope :filter_by_employees, -> (employees_selected) {
    where(result: Result.where(employee: employees_selected))    
  }
end
