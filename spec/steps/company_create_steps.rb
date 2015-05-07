step 'I am on the company create page' do
  visit '/companies/new'
end

step 'I see the company name entry form' do
  expect(page).to have_xpath('//input[@name="company[name]"]')
end

step 'I see the list of companies page' do
  expect(page).to have_title('Companies')
end
