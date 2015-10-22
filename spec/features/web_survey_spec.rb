require 'rails_helper'

describe User, js: true do
  let!(:company) { create(:company_with_employees) }
  let!(:user) { create(:user, company: company) }
  let!(:offered_survey) { create(:offered_survey_with_offered_questions) }

  before do
    login('ex@mail.com', 'bigsecret')
    visit new_surveys_company_survey_path(offered_survey_id: offered_survey.id)
  end

  it 'can create web survey' do
    click_on 'SAVE'
    expect(page).to have_content('Company survey was successfully created')
    expect(company.company_surveys.count).to eq 1
    expect(company.company_surveys.first.offered_questions.count).to eq 10
  end

  it 'save the offered_survey_id' do
    click_on 'SAVE'
    expect(company.company_surveys.first.offered_survey).to eq offered_survey
  end

  it 'can hide some questions' do
    first('.btn-toggle-topic').click
    click_on 'SAVE'
    expect(page).to have_content('Company survey was successfully created')
    expect(company.company_surveys.count).to eq 1
    expect(company.company_surveys.first.offered_questions.count).to eq 0
  end

  it 'can attach some questions again' do
    2.times { first('.btn-toggle-topic').click }
    click_on 'SAVE'
    expect(page).to have_content('Company survey was successfully created')
    expect(company.company_surveys.count).to eq 1
    expect(company.company_surveys.first.offered_questions.count).to eq 10
  end
end
