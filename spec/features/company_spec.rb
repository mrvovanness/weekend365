require 'rails_helper'

describe Company do
  # FactoryGirl creates user through company
  let!(:company) { create(:company) }

  before do
    login('ex@mail.com', 'bigsecret')
  end

  it 'Edit success' do
    click_on 'Edit company profile'
    select company.company_field.name, from: 'company_company_field_id'
    first(:button, 'Update Company').click
    expect(page).to have_content('Company was successfully updated')
  end

  it 'Edit failure' do
    click_on 'Edit company profile'
    fill_in 'Company Name', with: ''
    first(:button, 'Update Company').click
    expect(page).to have_content('Company could not be updated')
  end

end
