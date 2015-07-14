require 'rails_helper'

describe User do
  # FactoryGirl creates user through company
  let!(:company) { create(:company) } 
 
  before(:each) do
    login('ex@mail.com', 'bigsecret')
  end

  it 'No admin link' do
    expect(page).not_to have_link('ADMIN')
  end

  it 'No access to admin panel' do
    visit admin_root_path
    expect(page).not_to have_content('Dashboard')
  end

  it 'Link for admin' do
    company.user.add_role :admin
    visit root_path
    expect(page).to have_content('ADMIN')
  end

  it 'Access for admin' do
    company.user.add_role :admin
    visit root_path
    click_link 'ADMIN'
    expect(page).to have_content('Companies')
  end

end