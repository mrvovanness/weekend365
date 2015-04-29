step 'it should display :content' do |content|
  expect(page).to have_content(content)
end
