require 'rails_helper'

describe Company do
  let!(:company) { create(:company) }
  let!(:user) { create(:user, company: company) }
  let!(:second_user) { create(:user, email: 'test@example.com', company: company) }

  before(:each) do
    if User.with_role(:company_admin, company).empty?
      set_company_admin(company, user)
    end
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
    end
  end
end
