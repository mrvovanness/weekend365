require 'rails_helper'

describe Employee do
  let!(:employee) { create(:employee) }
  let!(:user) { create(:user, company: employee.company) }
  let!(:member) { create(:second_employee, position: 'Team member', department: 'Finance', company: employee.company) }
  let!(:manager) { create(:third_employee, position: 'Manager', department: 'IT', company: employee.company) }
  let!(:survey) { create(:survey_with_schedule, company: employee.company) }

  before do
    if User.with_role(:company_admin, user.company).empty?
      set_company_admin(user.company, user)
    end
    login('ex@mail.com', 'bigsecret')
    visit company_path(employee.company)
  end

  it 'Edit success' do
    click_on employee.name
    fill_in 'Name', with: 'Boris'
    fill_in 'Email', with: 'exe@mail.com'
    click_on 'Update Employee'
    expect(page).to have_content('Employee was successfully updated')
  end

  it 'Edit failure' do
    click_on employee.name
    fill_in 'Name', with: ''
    fill_in 'Email', with: ''
    click_on 'Update Employee'
    expect(page).to have_content('Employee could not be updated')
  end

  it 'Create success' do
    click_on 'New Employee(s)'
    fill_in 'Name', with: 'Boris'
    fill_in 'Email', with: 'ex@mail.com'
    click_on 'Save'
    expect(page).to have_content('Employee was successfully created')
  end

  it 'Create failure' do
    click_on 'New Employee(s)'
    fill_in 'Name', with: ''
    fill_in 'Email', with: ''
    click_on 'Save'
    expect(page).to have_content('Employee could not be created')
  end

  it 'Delete selected', js: true do
    check 'select_all'
    click_on 'Delete selected'
    page.evaluate_script('window.confirm = function() { return true; }')
    expect(page).to have_content I18n.t('flash.employees.destroy_selected.notice')
    expect(Employee.count).to eq 0
  end

  context 'Filters', js: true do
    it 'by position' do
      select 'Manager', from: 'q_position_eq'
      expect(page).to_not have_content member.name
    end

    it 'by department' do
      select 'Finance', from: 'q_department_eq'
      expect(page).to_not have_content manager.name
    end
  end

  context 'Add selected to survey', js: true do
    before(:each) do
      survey.employee_ids = [employee.id]
      survey.save!
      visit company_path(employee.company)
    end

    it 'can add selected employee to the survey' do
      check 'select_all'
      click_link 'add-selected-to-survey'
      click_link 'form-submit'
      expect(page).to have_content('Employees were successfully added to survey')
    end

    it 'removes duplicated employees in survey employees list' do
      check 'select_all'
      click_link 'add-selected-to-survey'
      click_link 'form-submit'
      survey.reload
      expect(survey.employee_ids.count).to eq 3
    end
  end
end
