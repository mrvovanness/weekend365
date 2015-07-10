require 'rails_helper'

describe User do
  let!(:user) {create(:user)} 
 
  before(:each) do
    login('ex@mail.com', 'bigsecret')
  end

  it "User don't see admin link" do
    expect(page).not_to have_link('ADMIN')
  end

  it "User don't access admin panel" do
    visit admin_root_path
    expect(page).not_to have_content('Dashboard')
  end

  it "Admin see admin link" do
    user.add_role :admin
    visit root_path
    expect(page).to have_link('ADMIN')
  end

  it "Admin user has access to admin panel" do
    user.add_role :admin
    visit root_path
    click_link 'ADMIN'
    expect(page).to have_content('Companies')
  end

end
