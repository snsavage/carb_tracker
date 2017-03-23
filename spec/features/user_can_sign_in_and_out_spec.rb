require 'rails_helper'

RSpec.feature 'UserCanSignInAndOut', type: :feature do
  feature 'user can sign up' do
    scenario 'with valid credentials' do
      user = build(:user)

      visit new_user_registration_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      fill_in 'Password confirmation', with: user.password
      click_button 'Sign up'

      new_user = User.last
      expect(page).to have_current_path(user_logs_path(new_user))
    end

    scenario 'with invalid credentials' do
      visit new_user_registration_path
      fill_in 'Email', with: ''
      fill_in 'Password', with: ''
      fill_in 'Password confirmation', with: ''
      click_button 'Sign up'

      expect(page).to have_content('Email can\'t be blank')
      expect(page).to have_content('Password can\'t be blank')
    end
  end

  feature 'user can sign in' do
    scenario 'with valid credentials' do
      user = create(:user)

      visit new_user_session_path
      fill_in 'Email', with: user.email
      fill_in 'Password', with: user.password
      click_button 'Log in'

      expect(page).to have_current_path(user_logs_path(user))
      expect(page).to have_content(t('devise.sessions.signed_in'))
    end

    scenario 'with invalid credentials' do
      visit new_user_session_path
      fill_in 'Email', with: 'random@example.com'
      fill_in 'Password', with: 'password'
      click_button 'Log in'

      expect(page).to have_current_path(new_user_session_path)
      expect(page).to have_content('Invalid Email or password.')
    end
  end

  feature 'user can sign out' do
    scenario 'when signed in' do
      user = create(:user)
      login_as(user, scope: :user)

      visit user_logs_path(user)
      expect(page).to have_current_path(user_logs_path(user))

      click_link 'Sign Out'
      expect(page).to have_current_path(root_path)
      expect(page).to have_content(t('nav.users.signin'))
      expect(page).to have_content(t('nav.users.signup'))
    end
  end
end
