require 'rails_helper'

describe Employee do
  let!(:employee) { create(:employee) }

  before do
    login('ex@mail.com', 'bigsecret')
  end

  it 'Edit success' do
    click_on employee.name
    fill_in 'Name', with: 'Boris'
    fill_in 'Email', with: 'exe@mail.com'
    first(:button, 'Update Employee').click
    expect(page).to have_content('Employee was successfully updated')
  end

  it 'Edit failure' do
    click_on employee.name
    fill_in 'Name', with: ''
    fill_in 'Email', with: ''
    first(:button, 'Update Employee').click
    expect(page).to have_content('Employee could not be updated')
  end

  it 'Create success' do
    click_on 'Add a New Employee'
    fill_in 'Name', with: 'Boris'
    fill_in 'Email', with: 'ex@mail.com'
    first(:button, 'Create Employee').click
    expect(page).to have_content('Employee was successfully created')
  end

  it 'Create success' do
    click_on 'Add a New Employee'
    fill_in 'Name', with: ''
    fill_in 'Email', with: ''
    first(:button, 'Create Employee').click
    expect(page).to have_content('Employee could not be created')
  end
end
