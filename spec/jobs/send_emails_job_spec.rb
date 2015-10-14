require 'rails_helper'

describe SendEmailsJob do
  let!(:survey) { create(:survey_with_tokens) }

  before do
    SendEmailsJob.perform(survey.id)
  end

  after do
    Resque.remove_schedule("send_emails_for_survey_#{survey.id}")
  end

  it 'increment counter' do
    expect(survey.reload.counter).to eq 1
  end

  it 'shift delivery date in database' do
    old_delivery_date = survey.next_delivery_at
    expect(survey.reload.next_delivery_at)
      .to eq(old_delivery_date + survey.repeat_every.days)
  end

  it 'shift next delivery date in Redis' do
    resque_hash = get_redis_data(survey.id)
    expect(resque_hash['every'][1]['first_at'].to_time)
      .to eq(survey.reload.next_delivery_at)
  end

  it 'mark all existing tokens as expired' do
    expect(survey.tokens.valid.count).to eq 0
  end

  it 'reset number_of_responses' do
    expect(survey.reload.number_of_responses).to eq 0
  end

  it 'reset email_counter' do
    expect(survey.reload.number_of_responses).to eq 0
  end

  it 'skip validation of start_at' do
    survey.update_column(:start_at, DateTime.current - 1.day)
    survey.reload
    SendEmailsJob.perform(survey.id)
    expect(survey.reload.counter).to eq 2
  end
end
