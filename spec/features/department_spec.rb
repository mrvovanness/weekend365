require 'rails_helper'

describe Department do
  let!(:department) { create(:department) }
  let!(:company) { create(:company_with_departments) }
  let!(:user) { create(:user, company: company) }

  before do
    if User.with_role(:company_admin, user.company).empty?
      set_company_admin(user.company, user)
    end
    login('ex@mail.com', 'bigsecret')
    visit company_path(company)
  end

  it 'Edit success' do
    click_on department.name, match: :first
    fill_in 'Name', with: 'Operations'
    fill_in 'Code', with: 'OP'
    click_on 'Save Department'
    expect(page).to have_content('Department was successfully updated')
  end

  it 'Edit failure' do
    click_on department.name, match: :first
    fill_in 'Name', with: ''
    fill_in 'Code', with: ''
    click_on 'Save Department'
    expect(page).to have_content('Department could not be updated')
  end

  it 'Create success' do
    click_on 'New Department(s)'
    fill_in 'Name', with: 'Information Technology'
    fill_in 'Code', with: 'IT'
    click_on 'Save'
    expect(page).to have_content('Department was successfully created')
  end

  it 'Create failure' do
    click_on 'New Department(s)'
    fill_in 'department_name', with: ''
    fill_in 'department_code', with: ''
    click_on 'Save'
    expect(page).to have_content('Department could not be created')
  end

end
