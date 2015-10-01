require 'rails_helper'

describe Company do
  let!(:company) { create(:company) }
  let!(:user) { create(:user, company: company) }

  before do
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
