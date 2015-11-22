require 'rails_helper'

describe User, js: true do
  let!(:company) { create(:company_with_department_with_employees) }
  let!(:department) { create(:department_with_employees) }
  let!(:user) { create(:user, company: company) }
  let!(:survey) { create(:survey_with_schedule, company: company) }

  before do
    login('ex@mail.com', 'bigsecret')
    visit preview_surveys_email_survey_path(survey)
  end

  it 'see the number of employees in survey' do
    expect(page).to have_content "Send to (0)"
  end

  it 'update employees for survey' do
    select company.employees.first.name, from: 'employee_ids'
    select company.employees.second.name, from: 'employee_ids'
    click_on 'Update employees'
    expect(page).to have_content 'Send to (2)'
  end
end
