step 'it should display :content' do |content|
  expect(page).to have_content(content)
end

step 'it displays :text link' do |text|
  expect(page).to have_link(text)
end

step 'I click :text link' do |text|
  click_link text
end
