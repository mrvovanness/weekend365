require 'rails_helper'

describe OfferedSurvey do
  let!(:survey) { create(:offered_survey_with_offered_questions) }

  it 'assign questions' do
    expect(SqaAssignment.count).to eq 10
  end

  it 'remove assingments when delete survey' do
    survey.destroy
    expect(SqaAssignment.count).to eq 0
  end 
end
