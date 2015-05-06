step 'I am on the list of companies page' do
  visit '/companies'
end

step 'I see the new company page' do
  expect(page).to have_title('New company | SSS')
end
