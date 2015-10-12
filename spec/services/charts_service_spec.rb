require 'rails_helper'

describe ChartsService do
  let!(:survey) { create(:survey_with_results) }

  after(:each) do
    Resque.remove_schedule("send_emails_for_survey_#{survey.id}")
  end

  it '#number of responses' do
    expect(ChartsService.new(survey).number_of_responses.values[0]).to eq 5
  end

  it '#average by company' do
    expect(ChartsService.new(survey).average_by_company.values[0]).to eq 10
  end

  it '#average by country' do
    expect(ChartsService.new(survey).average_by_country.values[0]).to eq 10
  end

  it '#average by industry' do
    expect(ChartsService.new(survey).average_by_industry.values[0]).to eq 10
  end

  it '#distribution' do
    expect(ChartsService.new(survey).distribution).to eq 10=>5
  end
end
