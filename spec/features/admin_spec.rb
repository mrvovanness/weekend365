require 'rails_helper'

describe User do
  let!(:company) { create(:company) }
  let!(:user) { create(:user, company: company) }
  let!(:other_company) { create(:company) }
  let!(:second_user) {create(:user, email: 'test@example.com', company: other_company)}

  before(:each) do
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
      click_link 'Add a New Employee'
      fill_in 'Name', with: 'Jack London'
      fill_in 'Email', with: 'jack.london@mail.com'
      click_button 'Create Employee'
      expect(page).to have_content('Jack London')
    end
  end
end