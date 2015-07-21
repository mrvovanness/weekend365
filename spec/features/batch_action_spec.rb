require 'rails_helper'

describe Company do
  let!(:company) { create(:company_with_employees) }

  before do
    login('ex@mail.com', 'bigsecret')
  end

  it 'Add multiply employees to surveys', js: true do
    visit root_path
    check("employee-#{company.employees.first.id}")
    check("employee-#{company.employees.last.id}")
    click_on 'Add Selected to Survey'
    expect(page).to have_content('Employees were successfully added to survey')
    expect(page).to have_content('Added')
  end
end
