require 'rails_helper'

describe Company do
  let!(:company) { create(:company_with_employees) }

  before do
    login('ex@mail.com', 'bigsecret')
    visit root_path
  end

  it 'search in departments' do
    select(company.employees.first.department, from: 'department_select')
    first('input[type="submit"]').click
    expect(page).to have_content(company.employees.first.name)
  end

  it 'search in positions', driver: :selenium do
    select(company.employees.first.position, from: 'position_select')
    click_on 'submit-position'
    expect(page).to have_content(company.employees.first.name)
  end
end
