require 'rails_helper'

RSpec.describe CompaniesController, type: :controller do
  let(:company) { mock_model(Company) }
  let(:companies) { [company] }

  describe 'GET #index' do
    it 'assigns @companies with all company objects' do
      allow(Company).to receive(:all).and_return(companies)

      get :index
      expect(assigns(:companies)).to eq(companies)
    end
  end

  describe 'GET #new' do
    it 'assigns @company with new company object' do
      allow(Company).to receive(:new).and_return(company)

      get :new
      expect(assigns(:company)).to eq(company)
    end
  end

  describe 'POST #create' do
    before { allow(Company).to receive(:new).and_return(company) }

    subject { post :create, company: { name: 'Foo' } }

    context 'when the company saves successfully' do
      before { allow(company).to receive(:save).and_return(true) }

      it 'sets a flash[:info] message' do
        subject
        expect(flash[:info]).to eq('Company was successfully created.')
      end

      it 'redirects to the companies index' do
        expect(subject).to redirect_to(companies_url)
      end
    end

    context 'when the company fails to save' do
      before { allow(company).to receive(:save).and_return(false) }

      it 'assigns @company' do
        subject
        expect(assigns(:company)).to eq(company)
      end

      it 're-renders the "new" template' do
        expect(subject).to render_template(:new)
      end
    end
  end
end
