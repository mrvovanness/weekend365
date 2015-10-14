require 'rails_helper'

describe Company do
  let!(:company) { create(:company) }
  let!(:first_user) { create(:user, company: company) }
  let!(:second_user) { create(:user, company: company, email: 'example@test.com') }

  context 'change_admin' do
    before(:each) do
      first_user.add_role :company_admin, company
    end

    it 'removes company_admin role from old admin' do
      company.change_admin(second_user.id)
      expect(first_user.has_role?(:company_admin, company)).to eq false
    end

    it 'adds company_admin role to new admin' do
      company.change_admin(second_user.id)
      expect(second_user.has_role?(:company_admin, company)).to eq true
    end
  end
end
