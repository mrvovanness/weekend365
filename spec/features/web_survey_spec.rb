require 'rails_helper'

describe User, js: true do
  let!(:company) { create(:company_with_employees) }
  let!(:user) { create(:user, company: company) }
  let!(:offered_survey) { create(:offered_survey_with_offered_questions) }

  before do
    login('ex@mail.com', 'bigsecret')
    visit new_surveys_web_survey_path(offered_survey_id: offered_survey.id)
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

  context 'Email schedule' do
    it 'save the email_schedule with default attributes' do
      click_on 'SAVE'
      email_schedule = company.company_surveys.first.email_schedule
      expect(email_schedule.start_at.nil?).to be false
      expect(email_schedule.finish_on.nil?).to be true
    end

    it 'save the email_schedule with repeat attributes' do
      choose 'company_survey_repeat_true'
      click_on 'SAVE'
      email_schedule = company.company_surveys.first.email_schedule
      expect(email_schedule.start_at.nil?).to be false
      expect(email_schedule.repeat_every.nil?).to be false
      expect(email_schedule.repeat_mode.nil?).to be false
      expect(email_schedule.finish_on.nil?).to be false
      expect(email_schedule.number_of_repeats.nil?).to be false
    end
  end

  context 'Hiding questions', :excluded do
    before do
      first('.btn-toggle-topic').click
      click_on 'SAVE'
    end

    it 'can hide comment' do
      expect(page).to have_content('Company survey was successfully created')
      expect(company.company_surveys.count).to eq 1
      expect(company.company_surveys.first.offered_questions.count).to eq 0
    end

    it 'add question later' do
      visit edit_surveys_web_survey_path(
        company.company_surveys.first,
        offered_survey_id: offered_survey.id
      )
      first('.btn-toggle-topic').click
      click_on 'SAVE'
      expect(page).to have_content('Company survey was successfully updated')
      expect(company.company_surveys.first.offered_questions.count).to eq 10
    end

    it 'cad delete question' do
      visit edit_surveys_web_survey_path(
        company.company_surveys.first,
        offered_survey_id: offered_survey.id
      )
      click_on 'Delete'
      page.execute_script('window.confirm = function() { return true; }')
      expect(page).to have_content('Company survey was successfully destroyed')
      expect(company.company_surveys.count).to eq 0
    end

    context 'Validations failure' do
      before do
        visit edit_surveys_web_survey_path(
          company.company_surveys.first,
          offered_survey_id: offered_survey.id
        )
        fill_in 'company_survey_title', with: ''
      end

      it 'topic bar is marked as deleted' do
        expect(page).to have_css('a.opener.deleted')
      end

      it 'change css on hide/show click' do
        first('.btn-toggle-topic').click
        expect(page).not_to have_css('a.opener.deleted')
      end

      it 'keep hide/show choice on validations failure' do
        first('.btn-toggle-topic').click
        click_on 'SAVE'
        expect(page).not_to have_css('a.opener.deleted')
      end
    end
  end

  it 'can attach some questions again', :excluded do
    2.times { first('.btn-toggle-topic').click }
    click_on 'SAVE'
    expect(page).to have_content('Company survey was successfully created')
    expect(company.company_surveys.count).to eq 1
    expect(company.company_surveys.first.offered_questions.count).to eq 10
  end
end
