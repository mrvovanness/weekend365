require 'rails_helper'

describe CompanySurvey do
  let!(:survey) { build(:company_survey) }
  after(:each) do
    Resque.remove_schedule("send_emails_for_survey_#{survey.id}")
  end

  it '- do not have schedule before save' do
    expect(Resque.schedule_persisted?("send_emails_for_survey_#{survey.id}")).to be false
  end

  it '- create schedule on #save' do
    survey.save
    expect(Resque.schedule_persisted?("send_emails_for_survey_#{survey.id}")).to be true
  end

  it '- create schedule on #update' do
    survey.update!(title: 'New title')
    expect(Resque.schedule_persisted?("send_emails_for_survey_#{survey.id}")).to be true
  end

  it '- destroy schedule on #destroy' do
    survey.save
    survey.destroy
    expect(Resque.schedule_persisted?("send_emails_for_survey_#{survey.id}")).to be false
  end
end
