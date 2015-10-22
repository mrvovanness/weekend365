require 'rails_helper'

describe User do
  let!(:company) { create(:company) }
  let!(:user) { create(:user, company: company) }
  let!(:other_company) { create(:company) }
  let!(:second_user) { create(:user, email: 'test@example.com', company: other_company) }

  before(:each) do
    if User.with_role(:company_admin, company).empty?
      set_company_admin(company, user)
    end
    if User.with_role(:company_admin, other_company).empty?
      set_company_admin(other_company, second_user)
    end
    login('ex@mail.com', 'bigsecret')
  end

  context 'with admin role' do
    before(:each) do
      user.add_role :admin
      visit root_path
      click_link 'Admin'
    end

    it 'can visit company page' do
      find(:xpath, "//a[@href='/companies/#{other_company.id}'][1]").click
      expect(page).to have_content(other_company.name)
    end

    it 'can edit company' do
      find(:xpath, "//a[@href='/companies/#{other_company.id}/edit']").click
      click_button 'Save'
      expect(page).to have_content('Company was successfully updated.')
    end

    it 'can add an employee to company' do
      find(:xpath, "//a[@href='/companies/#{other_company.id}'][1]").click
      click_link 'New Employee(s)'
      fill_in 'Name', with: 'Jack London'
      fill_in 'Email', with: 'jack.london@mail.com'
      click_button 'Save'
      expect(page).to have_content('Jack London')
    end
  end

  context 'admin add survey' do
    before(:each) do
      user.company.employees << create(:employee)
      user.add_role :admin
      visit new_admin_offered_survey_path
      fill_in 'Title', with: 'Test'
      fill_in 'Description', with: 'Test description'
      click_on 'Create Offered survey'
    end

    it 'and see added survey on surveys choosing page' do
      visit new_survey_path
      expect(page).to have_link(OfferedSurvey.first.title)
      expect(page).to have_content(OfferedSurvey.first.description)
    end
  end
end
