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
  },

  parseWithSelect: function(data) {
    return {foods: FoodHelpers.parse(data.foods), select: data.select};
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

window.init = function() {
  $(function () {
    $('#recipes-index div a').on('click', function(event) {
      $link = $(this);
      $parent = $link.parent();

      event.preventDefault();

      if($link.parent().data().expand === "expanded") {
        $($link.siblings()[0]).hide();
        $parent.data("expand", "collapsed");
      } else if ($link.parent().data().expand === "collapsed") {
        $($link.siblings()[0]).show();
        $parent.data("expand", "expanded");
      } else {
        $.getJSON($link.attr('href'))
          .done(function(data) {
            var template = HandlebarsTemplates['recipes/recipe_show'];
            $parent.append(template(data));
            $parent.data("expand", "expanded");
          });
      }
    });
  })

  $(function () {
    $('#foods-search-form input[type=submit]').on('click', function(event) {
      event.preventDefault();
      $('.foods-search-flash').remove();

      $.getJSON("/foods/search", {query: $('#recipe_search').val()})
        .done(function(data) {
          var template = HandlebarsTemplates['recipes/ingredient_fields'];
          $('#ingredients legend')
            .after(template(FoodHelpers.parseWithSelect(data)));
          $('#recipe_search').val("");
        })
        .fail(function(data) {
          var template = HandlebarsTemplates['foods/foods_search_flash'];
          $('#foods-search-form').prepend(template(data.responseJSON));
        });
    });

    $('.foods-sort').on('click', function(event) {
      event.preventDefault();

      $.getJSON(event.target.pathname + event.target.search)
        .done(function(data) {
          var template = HandlebarsTemplates['foods/index'];
          $('#foods-index').html(template(FoodHelpers.parse(data)));
        });
    });
  });
};

init();
