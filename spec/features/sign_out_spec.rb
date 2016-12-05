feature 'siging out' do
  scenario 'User clicks sign out button' do
      sign_up
      click_button("Sign out")
      expect(page).to have_content("Goodbye!")
      expect(page).not_to have_content("Hello Simon")
  end
end
