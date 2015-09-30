require 'rails_helper'

describe User do
  # FactoryGirl creates user through company
  let!(:company) { create(:company) }

  context 'Access to admin panel' do
    before(:each) do
      login('ex@mail.com', 'bigsecret')
    end

    it 'No admin link' do
      expect(page).not_to have_link('Admin')
    end

    it 'No access to admin panel' do
      visit companies_path
      expect(page).not_to have_content('Companies')
    end

    it 'Link for admin' do
      company.user.add_role :admin
      visit root_path
      expect(page).to have_link('Admin')
    end

    it 'Access for admin' do
      company.user.add_role :admin
      visit root_path
      click_link 'Admin'
      expect(page).to have_content('Companies')
    end
  end

  context 'After sign in' do
    it 'redirects to edit company page in first time' do
      company.user.confirmed_at = DateTime.current
      company.user.save
      login('ex@mail.com', 'bigsecret')
      expect(page).to have_content('company details')
    end

    it 'redirects to dashboard in other case' do
      company.user.touch :updated_at
      login('ex@mail.com', 'bigsecret')
      expect(page).to have_content('Dashboard')
    end
  end
end
