step 'the following companies exist:' do |table|
  table.hashes.each do |hash|
    FactoryGirl.create(:company, name: hash['Name'])
  end
end

step 'I see :content' do |content|
  expect(page).to have_content(content)
end

step 'I see :text link' do |text|
  expect(page).to have_link(text)
end

step 'I click :text link' do |text|
  click_link text
end

step 'I click :button_name button' do |button_name|
  click_button button_name
end

step 'I fill in :input_name with :value' do |input_name, value|
  fill_in input_name, with: value
end
