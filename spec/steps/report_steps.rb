step 'I am on the report page' do
  visit '/'
end

step 'I see the report page' do
  expect(page).to have_title('Report')
end
