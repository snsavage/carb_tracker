# Carb Tracker

[Carb Tracker](https://carbtracker.herokuapp.com/static/index) allows users to
track their daily nutrition (carbohydrates, protein, and fat) as a way to reach
health goals.  Nutrition data is provided by the [NutritionIx
API](https://www.nutritionix.com/business/api).  More information about the
project is available at: [Creating Carb Tracker with Ruby on
Rails](https://www.snsavage.com/blog/2017/creatingcarbtrackerwithrubyonrails.html).

**Update:** This project was recently updated with several JavaScript based
front-end user interactions.  More information can be found
[here](https://www.snsavage.com/blog/2017/adding-javascript-and-jquery-user-interactions-to-carb-tracker.html).

Carb Tracker is built with the [Ruby on Rails](http://rubyonrails.org) web
development framework.

*Carb Tracker was created as a project for the [Flatiron School's Online Web
Developer
Program](https://flatironschool.com/programs/online-web-developer-career-course/).*

## Setup
Local development for Carb Tracker can be setup with the following steps.  Please submit a [bug report](https://github.com/snsavage/carb_tracker/issues) if these steps don't work for you.

You will need the following software:

* Git
* Ruby v2.3.1
* PostgreSQL

After cloning this GitHub repo, don't forget to run bundle install and run the database migrations.

```
$ git clone https://github.com/snsavage/carb_tracker.git
$ bundle install
$ rake db:migrate
$ rake db:migrate RAILS_ENV=test
```

Carb Tracker uses the ```dotenv``` gem to manage environment variables.  You will need to provide the following variables in a ```.env``` file located in the project root.

```
NUTRITION_IX_ID=<your id here>
NUTRITION_IX_APP=<your key here>
FB_APP_ID=<your id here>
FB_APP_SECRET=<your secret here>
```

The NutritionIx keys can be obtained [here](https://developer.nutritionix.com/) and the Facebook keys [here](https://developers.facebook.com).

Seed data is available by running ```rake db:seed```.

## Testing
Carb Tracker has a test suite built with [rspec](http://rspec.info).  The test suite can be run with the commands:

```
$ rspec              # OR
$ bundle exec rspec  # Depending on your system configuration.
```

Additional front-end testing is done with Jasmine.  These tests can be accessed at:

```
http://localhost:3000/specs
```

## Contributing

Bug reports and pull requests are welcome on GitHub at
[https://github.com/snsavage/carb_tracker/issues](https://github.com/snsavage/carb_tracker/issues).
Please read the [Contributing Guide](./CONTRIBUTING.md).  This project is
intended to be a safe, welcoming space for collaboration, and contributors are
expected to adhere to the [Code of Conduct](./CODE_OF_CONDUCT.md).

## Questions?

Please contact [carbtracker@snsavage.com](mailto:carbtracker@snsavage.com).

## License

Carb Tracker is released on the [MIT License](./LICENSE).

