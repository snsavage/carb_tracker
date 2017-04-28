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
        var id = tempID();
        var ingredient_fields = template(data);

        function tempID () {
          return Math.floor(Math.random() * 9000000000) + 1000000000;
        }

        $('#ingredients legend').after(ingredient_fields);
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

    function indexList($id, data) {
      var template = HandlebarsTemplates['foods/index'];
      var foods = template(data);

      $id.html(foods);
    }

    event.preventDefault();

    $.getJSON(url)
      .done(function(data) {
        indexList($('#foods-index'), data);
      });
  });
});

