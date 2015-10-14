require 'rails_helper'

describe OfferedQuestion do
  let!(:question) { create(:question_with_answers) }

  it 'assign answers' do
    expect(SqaAssignment.count).to eq 10
  end

  it 'remove assingments when delete question' do
    question.destroy
    expect(SqaAssignment.count).to eq 0
  end 
end
