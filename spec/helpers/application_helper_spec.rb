require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  describe '#full_title' do
    context 'when page title is empty' do
      it 'returns only base title' do
        title = helper.full_title('')
        expect(title).to eq(helper.base_title)
      end
    end

    context 'when page title is not empty' do
      it 'returns full title with page title and base title' do
        title = helper.full_title('Page Title')
        expect(title).to eq("Page Title | #{helper.base_title}")
      end
    end
  end
end
