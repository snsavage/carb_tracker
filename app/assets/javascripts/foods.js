$(function () {
  $('.foods-sort').on('click', function(event) {
    var url = event.target.pathname + event.target.search;

    function indexList($id, data) {
      var foods = $.map(data, function(e) {
        var result = "";

        result = "<div class='food'>";
        result += "<a href='/foods/" + e.id + "' >" + e.unique_name + "</a>";
        result += "</div>";

        return result;
      });

      $id.html(foods);
    }

    event.preventDefault();

    $.getJSON(url)
      .done(function(data) {
        indexList($('#foods-index'), data);
      });
  });
});

