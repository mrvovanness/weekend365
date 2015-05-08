step 'I see active :link_name navigation link' do |link_name|
  within('.nav li.active') do
    expect(page).to have_link(link_name)
  end
end
