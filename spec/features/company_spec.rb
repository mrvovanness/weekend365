require 'rails_helper'

describe Company do
  let!(:company) { create(:company) }
  let!(:user) { create(:user, company: company) }
  let!(:secondary_user) { create(:user, email: 'test@example.com', company: company) }

  before(:each) do
    if User.with_role(:company_admin, company).empty?
      set_company_admin(company, user)
    end
  end

  it 'has a link to edit the company' do
    login('ex@mail.com', 'bigsecret')
    expect(page).to have_content('Edit company')
  end

  context 'Edit the company' do
    before(:each) do
      login('ex@mail.com', 'bigsecret')
      click_on 'Edit company'
    end

    it 'Edit success' do
      select company.company_field.name, from: 'company_company_field_id'
      click_on 'Save'
      expect(page).to have_content('Company was successfully updated')
    end

    it 'Edit failure' do
      fill_in 'Company Name', with: ''
      click_on 'Save'
      expect(page).to have_content('Company could not be updated')
    end

    it 'can edit time zone' do
      select '(GMT+01:00) Berlin', from: 'company_timezone'
      click_on 'Save'
      company.reload
      expect(company.timezone).to eq 'Berlin'
    end
    it 'shows admin list link' do
      expect(page).to have_link('Admin list')
    end
  end

  context 'Company admin' do
    context 'if user is admin' do
      before(:each) do
        login('ex@mail.com', 'bigsecret')
        click_on 'COMPANY'
      end

      it 'shows admin name at company page' do
        expect(page).to have_content(user.name)
      end

      it 'shows admin email at company page' do
        expect(page).to have_content(user.email)
      end

      it 'shows change admin link' do
        expect(page).to have_content('change')
      end

      it 'can edit the company admin' do
        click_on 'Edit company'
        find(:select, 'admin').first(:option, secondary_user.name).select_option
        click_on 'Save'
        company.reload
        expect(company.admin).to eq secondary_user
      end

      it 'can delete other company user', js: true do
        visit users_path
        check 'select_all'
        click_on 'Delete selected'
        page.execute_script('window.confirm = function() { return true; }')
        expect(company.users.count).to eq 1
      end

      it 'can not delete himself' do
        visit users_path
        expect(page).to_not have_css("#user-#{user.id}")
      end
    end

    context 'if user is not admin' do
      before(:each) do
        login('test@example.com', 'bigsecret')
        click_on 'COMPANY'
      end

      it 'shows admin name at company page' do
        expect(page).to have_content(user.name)
      end

      it 'does not show change admin link' do
        expect(page).to_not have_content('change')
      end

      it 'can not edit the company admin' do
        click_on 'Edit company'
        expect(page).to have_select('admin', disabled: true)
      end

      it 'can not delete the company admin' do
        visit users_path
        expect(page).to_not have_css("#user-#{user.id}")
      end
    end
  end
end
