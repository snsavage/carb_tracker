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
        var error = data.responseJSON['error'];

        result = '<div class="foods-search-flash flash-notice">';
        result += '<span>' + error + '</span>';
        result += '</div>';

        $('#foods-search-form').prepend(result);
      });
    // Call the api
    // On success add to ingredients list
    // Remove search terms
    // On failure add message

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

