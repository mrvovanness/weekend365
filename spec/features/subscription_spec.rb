require 'rails_helper'

describe '' do
  let!(:company) { create(:company) }
  let!(:user) { create(:user, company: company) }
  let!(:secondary_user) { create(:user, email: 'test@mail.com', name: 'John Connor', company: company) }

  before(:each) do
    if User.with_role(:company_admin, company).empty?
      set_company_admin(company, user)
    end
    user.add_role :admin
    subscribe(user.email)
    login('ex@mail.com', 'bigsecret')
  end

  after(:all) do
    ['ex@mail.com', 'test@mail.com', 'pushkin@mail.com'].each do |email|
      unsubscribe(email)
    end
  end

  context 'New user' do
    it 'has subscribed to mailing list' do
      visit companies_path
      click_link 'New Company'
      fill_in 'Email', with: 'pushkin@mail.com'
      fill_in 'signup_name', with: 'Alex Pushkin'
      fill_in 'signup_company_name', with: 'Pushkin Corp.'
      select 'Albania', from: 'signup_country'
      click_on 'Sign me up'

     expect(check_status('pushkin@mail.com')).to eq 'subscribed'
    end

    it 'has not subscribed if he is not company admin' do
      visit users_path
      click_link 'Add new Admin'
      fill_in 'Name', with: 'Michael Lermontov'
      fill_in 'Email', with: 'lermontov@mail.com'
      click_on 'Save'

      expect(check_status('lermontov@mail.com')).to eq 'none'
    end
  end

  context 'When company admin has changed' do
    before(:each) do
      click_on 'Edit company'
      find(:select, 'admin').first(:option, secondary_user.name).select_option
      check 'company_subscribed'
      click_on 'Save'
    end

    it 'new admin is subscribed' do
      expect(check_status(secondary_user.email)).to eq 'subscribed'
    end
      
    it 'old admin is unsubscribed' do
      expect(check_status(user.email)).to eq 'unsubscribed'
    end
  end

  context "When 'subscribed' has unchecked" do
    before(:each) do
      click_on 'Edit company'
      uncheck 'company_subscribed'
      click_on 'Save'
    end
    it 'company admin has unsubscribed' do
      expect(check_status(user.email)).to eq 'unsubscribed'
    end

    it 'change of company admin does not change the subscribers list' do
      click_on 'Edit company'
      find(:select, 'admin').first(:option, secondary_user.name).select_option
      click_on 'Save'

      expect(check_status(secondary_user.email)).to eq('unsubscribed').or eq('none')
    end
  end
end
