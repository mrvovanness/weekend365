require 'rails_helper'

describe User do
  let!(:company) { create(:company) }
  let!(:user) { create(:user, company: company) }

  context 'Access to admin panel' do
    before(:each) do
      if User.with_role(:company_admin, company).empty?
        set_company_admin(company, user)
      end
      user.updated_at = user.confirmed_at + 2
      user.save
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
      user.add_role :admin
      visit root_path
      expect(page).to have_content('Admin')
    end

    it 'Access for admin' do
      user.add_role :admin
      visit root_path
      click_link 'Admin'
      expect(page).to have_content('Companies')
    end
  end

  context 'After sign in' do
    it 'redirects to edit company page in first time' do
      if User.with_role(:company_admin, company).empty?
        set_company_admin(company, user)
      end
      user.confirmed_at = DateTime.current
      user.save
      login('ex@mail.com', 'bigsecret')
      expect(page).to have_content('Company Details')
    end

    it 'redirects to surveys in other case' do
      user.touch :updated_at
      login('ex@mail.com', 'bigsecret')
      expect(page).to have_content('survey selection')
    end
  end
end
