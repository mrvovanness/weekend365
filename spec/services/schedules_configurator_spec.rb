require 'rails_helper'

describe SchedulesConfigurator do
  let!(:email_schedule) { create(:email_schedule) }
  let!(:survey_id) { email_schedule.company_survey.id }
  after(:each) do
    Resque.remove_schedule("for_survey_#{survey_id}")
  end

  it "add new schedule with correct every expression" do
    SchedulesConfigurator.new(email_schedule).add_to_scheduler
    expect(get_redis_data(survey_id)['every'][0]).to eq('3d')
  end

  it "add new schedule with correct 'first_at' expression" do
    SchedulesConfigurator.new(email_schedule).add_to_scheduler
    expect(get_redis_data(survey_id)['every'][1]['first_at'].to_time)
      .to be_within(1.second).of(email_schedule.start_at)
    end

  context 'updating schedule within job' do
    before do
      email_schedule.company_survey.counter = 1
      email_schedule.time = nil
      SchedulesConfigurator.new(email_schedule).add_to_scheduler
    end

    it "calculate new delivery date if counter not equal zero" do
      expect(get_redis_data(survey_id)['every'][1]['first_at'].to_time)
        .to be_within(1.second).of(email_schedule.start_at + 3.days)
    end

    it "calculate new every" do
      expect(get_redis_data(survey_id)['every'][0]).to eq('3d')
    end

    it "save new delivery date in database" do
      expect(email_schedule.next_delivery_at)
        .to be_within(1.second).of(email_schedule.start_at + 3.days)
    end

    it 'update schedule second time' do
      SchedulesConfigurator.new(email_schedule).add_to_scheduler
      expect(get_redis_data(survey_id)['every'][1]['first_at'].to_time)
        .to be_within(1.second).of(email_schedule.start_at + 6.days)
    end
  end
end
