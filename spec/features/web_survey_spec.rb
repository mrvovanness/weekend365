require 'rails_helper'

describe User do
  let!(:company) { create(:company_with_employees) }
  let!(:user) { create(:user, company: company) }
  let!(:offered_survey) { create(:offered_survey_with_offered_questions) }

  before do
    if User.with_role(:company_admin, user.company).empty?
      set_company_admin(user.company, user)
    end
    login('ex@mail.com', 'bigsecret')
    visit new_survey_path
  end

  after do
  end

  it 'can add new survey' do
    click_on offered_survey.title
    expect(page).to have_content('create new survey')
  end
end
