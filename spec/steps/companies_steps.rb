step 'I am on the list of companies page' do
  visit '/companies'
end

step 'I see :count record of companies' do |count|
  expect(page).to have_xpath('//table/tbody/tr', count: count)
end

step 'I see the company create page' do
  expect(page).to have_title('New company')
end
