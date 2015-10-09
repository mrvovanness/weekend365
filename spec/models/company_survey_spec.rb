require 'rails_helper'

describe CompanySurvey do
  let!(:survey) { build(:company_survey) }

  after(:each) do
    Resque.remove_schedule("send_emails_for_survey_#{survey.id}")
  end

  context 'Resque scheduler' do
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

  context 'before save callbacks' do
    it '- saves local time' do
      survey.save
      survey.update!(start_on: '2015-01-19', time: '13:00')
      expect(survey.start_at).to eq(Time.zone.parse('Mon, 19 Jan 2015 13:00:00 JST +09:00'))
    end
  end
end
