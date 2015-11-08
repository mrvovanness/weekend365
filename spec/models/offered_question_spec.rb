require 'rails_helper'

describe OfferedQuestion do
  let(:question) { create(:question_with_answers) }

  it 'assign answers' do
    expect(question.offered_answers.count).to eq 10
  end

  it 'remove assingments when delete question' do
    question.destroy
    expect(SqaAssignment.count).to eq 0
  end 

  context "assign answers depending on 'form of answers' attribute" do
    let!(:offered_answer) { create_list(:offered_answer, 10) }
    let(:linkert_question) { build(:offered_question) }

    it 'has 5 linkert scale answers' do
      linkert_question.form_of_answers = '1-5 scale'
      linkert_question.save
      expect(linkert_question.offered_answers.count).to eq 5
    end

    it 'has 10 scale answers' do
      linkert_question.form_of_answers = '1-10 scale'
      linkert_question.save
      expect(linkert_question.offered_answers.count).to eq 10
    end

    it 'has no scale answers when open question' do
      linkert_question.form_of_answers = 'open'
      linkert_question.save
      expect(linkert_question.offered_answers.count).to eq 0
    end
  end

end
