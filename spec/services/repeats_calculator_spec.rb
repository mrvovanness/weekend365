require 'rails_helper'

describe RepeatsCalculator do
  let!(:survey) { build(:survey_with_finish_on) }

  it 'calculate one time per 2 weeks' do
    survey.repeat_mode = 'w'
    survey.repeat_every = 2
    survey.start_at = DateTime.now
    expect(RepeatsCalculator.new(survey).result).to eq(26)
  end

  it 'calculate one time per 2 days' do
    survey.repeat_mode = 'd'
    survey.repeat_every = 2
    survey.start_at = DateTime.now
    expect(RepeatsCalculator.new(survey).result).to eq(183)
  end
end
