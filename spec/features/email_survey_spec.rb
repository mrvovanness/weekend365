require 'rails_helper'

describe User, js: true do
  let!(:company) { create(:company_with_department_with_employees) }
  let!(:department) { create(:department_with_employees) }
  let!(:user) { create(:user, company: company) }
  let!(:offered_survey) { create(:offered_survey_with_offered_questions) }

  before do
    if User.with_role(:company_admin, user.company).empty?
      set_company_admin(user.company, user)
    end
    login('ex@mail.com', 'bigsecret')
    visit new_survey_path
    click_on offered_survey.title
  end

  it 'can see offered survey question' do
    expect(page).to have_content(offered_survey.offered_questions.first.title)
  end

  it 'validations failure on create' do
    page.execute_script("$('#survey_start_on').val('2015-10-10')")
    fill_in 'company_survey_message', with: 'Test message'
    click_on 'Save'
    expect(page).to have_content('Survey start date and time should be after current time')
  end

  context 'can create/update company survey' do
    before do
      fill_in 'company_survey_message', with: 'Test message'
      click_on 'Save'
    end

    after do
      Resque.remove_schedule("for_survey_#{company.company_surveys.first.id}")
    end

    it 'successful create' do
      expect(page).to have_content 'Company survey was successfully created'
      expect(company.company_surveys.count).to eq 1
      expect(company.company_surveys.first.offered_questions.count).to eq 1
    end

    it 'successful update' do
      visit edit_surveys_email_survey_path(company.company_surveys.first)
      select('weeks', from: 'company_survey_email_schedule_attributes_repeat_mode')
      click_on 'Change'
      expect(page).to have_content 'Company survey was successfully updated'
      expect(company.company_surveys.first.email_schedule.number_of_repeats).to eq 13
    end

    it 'validations failure on update' do
      visit edit_surveys_email_survey_path(company.company_surveys.first)
      page.execute_script("$('#survey_start_on').val('2015-10-10')")
      fill_in 'company_survey_message', with: 'Test message'
      click_on 'Change'
      expect(page).to have_content('Survey start date and time should be after current time')
    end

    context 'started survey' do
      before do
        company.company_surveys.first.increment!(:counter)
        visit edit_surveys_email_survey_path(company.company_surveys.first)
      end

      it 'can not update start_on of started survey' do
        company.company_surveys.first.increment!(:counter)
        visit edit_surveys_email_survey_path(company.company_surveys.first)
        expect(page).to have_content 'Already started'
      end

      it 'can update other attributes' do
        select('days', from: 'company_survey_email_schedule_attributes_repeat_mode')
        click_on 'Change'
        expect(page).to have_content 'Company survey was successfully updated'
      end

      it 'no validation of start_at on update' do
        visit edit_surveys_email_survey_path(company.company_surveys.first)
        page.execute_script("$('#survey_start_on').val('2015-10-10')")
        fill_in 'company_survey_message', with: 'Test message'
        click_on 'Change'
        expect(page).not_to have_content('Survey start date and time should be after current time')
      end
    end
  end

end
