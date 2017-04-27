$(function () {
  $('.foods-sort').on('click', function(event) {
    const url = event.target.pathname + event.target.search;

    function indexList($id, data) {
      const foods = data.map((e) => {
        return `
          <div class="food">
          <a href="/foods/${e.id}">${e.unique_name}</a>
          </div>
          `
      }).join("");

      $id.html(foods);
    }

    event.preventDefault();

    $.getJSON(url)
      .done(function(data) {
        indexList($('#foods-index'), data);
      });
  });
});

