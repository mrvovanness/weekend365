class Answer < ActiveRecord::Base
  belongs_to :result
  belongs_to :offered_answer

  scope :filter_by_employees, -> (employees_selected, survey) {
    where(result: Result.where(employee: employees_selected, 
                               company_survey: survey)) }

  def self.to_csv
    attributes = %w(date value comment)
    survey = all.first.result.company_survey
    survey_title, survey_message = survey.title, survey.message
    CSV.generate do |csv|
      csv << [survey_title]
      csv << []
      csv << [survey_message]
      csv << []
      csv << attributes
      all.order(:created_at).each do |answer|
        csv << [answer.created_at.strftime('%m-%d-%Y'), answer.offered_answer.value, answer.comment]
      end
    end
  end
end
