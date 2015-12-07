require 'rails_helper'

describe Company do
  let!(:company) { create(:company_with_department_with_employees) }
  let!(:department) { create(:department_with_employees) }
  let!(:user) { create(:user, company: company) }

  before do
    if User.with_role(:company_admin, company).empty?
      set_company_admin(company, user)
    end
    login('ex@mail.com', 'bigsecret')
    visit company_department_path(company, company.departments.first)
  end

  # it 'search in departments' do
  #   select(company.employees.first.department.name, from: 'q_department_eq')
  #   click_on 'combine-search-submit'
  #   expect(page).to have_content(company.employees.first.name)
  # end

  it 'search in positions' do
    select(company.employees.first.position, from: 'q_position_eq')
    click_on 'combine-search-submit'
    expect(page).to have_content(company.employees.first.name)
  end

  it 'combine search' do
    #select(company.employees.first.department.name, from: 'q_department_eq')
    select(company.employees.first.position, from: 'q_position_eq')
    click_on 'combine-search-submit'
    expect(page).to have_content(company.employees.first.name)
  end

  it 'full search' do
    fill_in 'q_first_name_or_last_name_or_department_or_position_cont',
      with: company.employees.first.first_name.slice(0..4)
    click_on 'full-search-submit'
    sleep 10
    expect(page).to have_content(company.employees.first.first_name)
  end
end
