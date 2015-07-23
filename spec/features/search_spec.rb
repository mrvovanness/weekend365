require 'rails_helper'

describe Company do
  let!(:company) { create(:company_with_employees) }

  before do
    login('ex@mail.com', 'bigsecret')
    visit root_path
  end

  it 'search in departments' do
    select(company.employees.first.department, from: 'q_department_eq')
    click_on 'combine-search-submit'
    expect(page).to have_content(company.employees.first.name)
  end

  it 'search in positions' do
    select(company.employees.first.position, from: 'q_position_eq')
    click_on 'combine-search-submit'
    expect(page).to have_content(company.employees.first.name)
  end

  it 'combine search' do
    select(company.employees.first.department, from: 'q_department_eq')
    select(company.employees.first.position, from: 'q_position_eq')
    click_on 'combine-search-submit'
    expect(page).to have_content(company.employees.first.name)
  end

  it 'full search' do
    fill_in 'q_name_or_department_or_position_cont',
      with: company.employees.first.name.slice(0..4)
    click_on 'full-search-submit'
    expect(page).to have_content(company.employees.first.name)
  end
end
