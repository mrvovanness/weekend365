step 'I am on the dashboard page' do
  visit '/'
end

step 'I see the dashboard page' do
  expect(page).to have_title('Dashboard')
end
