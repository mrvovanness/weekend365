require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  describe 'GET #new' do
    it 'assigns @company with new company object' do
      new_company = Company.new
      allow(Company).to receive(:new).and_return(new_company)

      get :new
      expect(assigns(:company)).to eq(new_company)
    end
  end

  describe 'POST #create' do
    subject { post :create }

    it 'redirects to the companies index' do
      expect(subject).to redirect_to(companies_url)
    end
  end
end
