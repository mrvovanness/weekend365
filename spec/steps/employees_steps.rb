step 'I am on the employees page' do
  visit '/employees'
end

step 'I see the employees page' do
  expect(page).to have_title('Employees')
end
