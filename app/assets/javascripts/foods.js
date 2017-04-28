$(function () {
  $('#foods-search-form input[type=submit]').on('click', function(event) {
    var $searchBox = $('#foods-search-form #recipe_search');
    var url = "/foods/search";

    $('#foods-search-form .foods-search-flash').remove();

    event.preventDefault();
    event.stopPropagation();

    $.getJSON(url, {query: $searchBox.val()})
      .done(function(data) {
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

