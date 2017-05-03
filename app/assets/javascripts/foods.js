function Food(food) {
  this.id = food.id;
  this.name = food.unique_name;
  this.tempIdCache = null
};

var FoodHelpers = {
  rand: function() {
    return Math.floor(Math.random() * 9000000000) + 1000000000;
  },

  parse: function(data) {
    return $.map(data, function(element) {
      return new Food(element);
    });
  }
}

Object.defineProperty(Food.prototype, "showLink", {
  get: function() { return "/foods/" + this.id; }
});

Object.defineProperty(Food.prototype, "tempId", {
  get: function() {
    if (this.tempIdCache) {
      return this.tempIdCache;
    } else {
      this.tempIdCache = FoodHelpers.rand();
      return this.tempIdCache;
    }
  }
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

        var parsedData = {
          foods: FoodHelpers.parse(data.foods),
          select: data.select
        }

        $('#ingredients legend').after(template(parsedData));
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
  $(document).on('click', '.foods-sort', function(event) {
    var url = event.target.pathname + event.target.search;

    event.preventDefault();

    $.getJSON(url)
      .done(function(data) {
        var template = HandlebarsTemplates['foods/index'];
        $('#foods-index').html(template(FoodHelpers.parse(data)));
      });
  });
});

