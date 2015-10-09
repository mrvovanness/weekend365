require 'rails_helper'

describe User do
  let!(:token) { create(:token) }
  before(:all) do
    load "#{Rails.root}/db/seeds/articles.rb"
  end

  context 'adding comment' do
    before do
      visit results_path(
        employee_id: 1,
        offered_question_id: 1,
        company_survey_id: 1,
        token: token.name
      )
    end
    it 'can see thanks message' do
      expect(page).to have_content(I18n.t('results.add_result.thanks'))
    end

    it 'can enter comment' do
      fill_in 'answer_comment', with: 'Test'
      click_on I18n.t('helpers.submit.answer.update')
      expect(page).to have_content(I18n.t('flash.opinion_thanks'))
      expect(Answer.first.comment).to eq('Test')
    end
  end

  it 'can see flash error if token expired' do
    token.update(expired: true)
    visit results_path(
      employee_id: 1,
      offered_question_id: 1,
      company_survey_id: 1,
      token: token.name
    )
    expect(page).to have_content(I18n.t('flash.token_expired'))
  end
end
