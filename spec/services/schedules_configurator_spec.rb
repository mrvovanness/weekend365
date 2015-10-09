require 'rails_helper'

describe SchedulesConfigurator do
  let!(:survey) { create(:survey_with_id) }
  after(:each) do
    Resque.remove_schedule("send_emails_for_survey_#{survey.id}")
  end

    it "add new schedule with correct every expression" do
      SchedulesConfigurator.new(survey).add_to_scheduler
      expect(Resque.reload_schedule!['send_emails_for_survey_1']['every'][0]).to eq('3d')
    end

    it "add new schedule with correct 'first_at' expression" do
      SchedulesConfigurator.new(survey).add_to_scheduler
      expect(Resque.reload_schedule!['send_emails_for_survey_1']['every'][1]['first_at'].to_time)
        .to be_within(1.second).of(survey.start_at)
    end

  context 'updating schedule within job' do
    before do
      survey.counter = 1
      survey.time = nil
      SchedulesConfigurator.new(survey).add_to_scheduler
    end
    it "calculate new delivery date if counter not equal zero" do
      expect(Resque.reload_schedule!['send_emails_for_survey_1']['every'][1]['first_at'].to_time)
        .to be_within(1.second).of(survey.start_at + 3.days)
    end

    it "calculate new every" do
      expect(Resque.reload_schedule!['send_emails_for_survey_1']['every'][0]).to eq('3d')
    end

    it "save new delivery date in database" do
      expect(survey.next_delivery_at).to be_within(1.second).of(survey.start_at + 3.days)
    end

    it 'update schedule second time' do
      SchedulesConfigurator.new(survey).add_to_scheduler
      expect(Resque.reload_schedule!['send_emails_for_survey_1']['every'][1]['first_at'].to_time)
        .to be_within(1.second).of(survey.start_at + 6.days)
    end
  end
end