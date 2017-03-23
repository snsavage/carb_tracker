namespace :db do
  desc 'Remove all data from all db models'
  task clean: :environment do |_env|
    if Rails.env == 'development'
      User.delete_all
      Log.delete_all
      Entry.delete_all
      Recipe.delete_all
      Ingredient.delete_all
      Food.delete_all
    else
      puts 'DB Clear: *** DO NOT RUN THIS IN PRODUCTION*** '
    end
  end
end
