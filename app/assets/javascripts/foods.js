Handlebars.registerHelper('select_list', function(select_options) {
  var food = this;
  var template = HandlebarsTemplates['recipes/foods_select'];

  var list = $.map(select_options, function(e) {
    if (food.id === e.id){
      e.selected = "selected";
      return e;
    } else {
      return e;
    }
  });

  return new Handlebars.SafeString(template(list));
});

$(function () {
  $('#foods-search-form input[type=submit]').on('click', function(event) {
    var $searchBox = $('#foods-search-form #recipe_search');
    var url = "/foods/search";

    $('#foods-search-form .foods-search-flash').remove();

    event.preventDefault();
    event.stopPropagation();

    $.getJSON(url, {query: $searchBox.val()})
      .done(function(data) {
        var template = HandlebarsTemplates['recipes/ingredient_fields'];

        function Ingredient(ingredient) {
          this.id = ingredient.id,
          this.name = ingredient.unique_name,
          this.idCache = null
        }

        Object.defineProperty(Ingredient.prototype, "tempId", {
          get: function() {
            if (this.idCache) {
              return this.idCache;
            } else {
              this.idCache = Math.floor(Math.random() * 9000000000) + 1000000000;
              return this.idCache;
            }
          }
        });

        var parsedIngredients = $.map(data.foods, function(element) {
          return new Ingredient(element);
        });

        var dataWithParsedIngredients = {
          foods: parsedIngredients,
          select: data.select
        }

        $('#ingredients legend').after(template(dataWithParsedIngredients));
        $searchBox.val("");
      })
      .fail(function(data) {
        var template = HandlebarsTemplates['foods/foods_search_flash'];
        var error = template(data.responseJSON);

        $('#foods-search-form').prepend(error);
      });
  });
});

$(function () {
  $('.foods-sort').on('click', function(event) {
    var url = event.target.pathname + event.target.search;

    event.preventDefault();
    event.stopPropagation();

    function indexList($id, data) {
      var template = HandlebarsTemplates['foods/index']

      function Food(food) {
        this.id = food.id;
        this.name = food.unique_name;
      };

      Object.defineProperty(Food.prototype, "showLink", {
        get: function() { return "/foods/" + this.id; }
      });

      var foods = $.map(data, function(element) {
        return new Food(element);
      });

      var foods = template(foods);
      $id.html(foods);
    }


    $.getJSON(url)
      .done(function(data) {
        indexList($('#foods-index'), data);
      });
  });
});

