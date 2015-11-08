require 'rails_helper'

describe User, js: true do
  let(:survey) { create(:survey_with_linkert_questions) }
  let(:token) { create(:token) }
  let(:employee_id) { 1 }

  before do
    visit new_result_path(survey.id, token.name, employee_id)
  end

  it 'can see page' do
    expect(page).to have_content(survey.offered_questions.first.topic)
  end

  it 'can not submit survey untill answers the questions' do
    expect(page).not_to have_button('Submit survey')
  end

  it 'redirect to home page with bad token' do
    token.expired = true
    token.save
    visit new_result_path(survey.id, token.name, employee_id)
    expect(page).to have_content I18n.t('flash.token_expired')
  end

  it 'redirect to home page with no token' do
    token.destroy
    visit new_result_path(survey.id, token.name, employee_id)
    expect(page).to have_content I18n.t('flash.token_expired')
  end

  it 'can submit survey after answering the questions' do
    first('.level').click
    expect(page).to have_button('Submit survey')
  end

  it 'can select answer and see number of unanswered questions' do
    first('.level').click
    expect(page).to have_content('0 unanswered questions')
  end

  it 'can submit survey' do
    first('.level').click
    click_on 'Submit survey'
    expect(page).to have_content('Thank you for your opinion')
  end

  it 'save results in database' do
    first('.level').click
    first('.btn-comments').click
    find('.comment-input').set('Test')
    click_on 'Submit survey'
    expect(survey.results.count).to eq 1
    expect(survey.results.first.company_survey).to eq survey
    expect(survey.results.first.employee_id).to eq 1
    expect(survey.results.first.offered_question).to eq survey.offered_questions.first
    expect(survey.results.first.answers.first.offered_answer)
      .to eq survey.offered_questions.first.offered_answers.first
    expect(survey.results.first.answers.first.comment).to eq 'Test'
  end

  it 'save user answer in database' do
    survey.offered_questions.first.update!(form_of_answers: 'open')
    visit new_result_path(survey.id, token.name, employee_id)
    find('.user-answer').set('Test user answer')
    click_on 'Submit survey'
    expect(survey.results.first.answers.first.user_answer).to eq 'Test user answer'
  end

  it 'remove token after submiting survey' do
    first('.level').click
    click_on 'Submit survey'
    expect(token.reload.expired).to be true
  end

end
