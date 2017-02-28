require 'rails_helper'

RSpec.feature "UsersCanManageLogFoods", type: :feature do
  feature "user can add an entry to a log" do
    scenario "when signed in", js: true do
      user = create(:user)
      recipe = build(:recipe)
      food = create(:food)
      recipe.foods << food
      recipe.save

      login_as(user, :scope => :user)

      visit new_log_path

      expect(page).to have_current_path(new_log_path)

      click_button "Add Entry"

      select "Apple", from: "Recipe"
      fill_in "Quantity", with: "1"
      select "Snack", from: "Category"

      click_button "Create Log"

      expect(page).to have_current_path(logs_path)
      expect(page).to have_content("Apple")
      expect(page).to have_content("Snack")
      # expect(page).to have_content(Date.now)
    end

    scenario "when not signed in" do
      visit new_log_path

      expect(page).to have_current_path(new_user_session_path)
    end

    scenario "user can add multiple entries to a log", js: true do
      user = create(:user)
      recipe = build(:recipe)
      food = create(:food)
      recipe.foods << food
      recipe.save

      login_as(user, :scope => :user)

      visit new_log_path

      click_button "Add Entry"

      within "#entries div:first-child" do
        select "Apple", from: "Recipe"
        fill_in "Quantity", with: "1"
        select "Snack", from: "Category"
      end

      click_link "Add Entry"

      within "#entries div:nth-child(2)" do
        select "Apple", from: "Recipe"
        fill_in "Quantity", with: "1"
        select "Breakfast", from: "Category"
      end

      click_button "Create Log"

      user.reload
      expect(user.logs.first.entries.count).to eq(2)
      expect(page).to have_content("Apple - Snack")
      expect(page).to have_content("Apple - Breakfast")
    end
  end

  feature "users can remove entries from their logs", js: true do
    scenario "when signed in" do
      user = create(:user)
      recipe = build(:recipe)
      food = create(:food)
      recipe.foods << food
      recipe.save

      user.logs.create(log_date: Time.current.to_date).recipes << recipe
      user.logs.first.recipes << recipe
      user.save

      expect(user.logs.first.entries.count).to eq(2)
      login_as(user, :scope => :user)

      visit edit_log_path(user.logs.first)

      click_link "Remove Entry", match: :first
      click_button "Update Log"

      expect(user.logs.first.entries.count).to eq(1)
    end
  end
end

