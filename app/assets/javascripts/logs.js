function Log (data) {
  this.id = data.id;
  this.log_date = data.log_date;
  this.next = data.next;
  this.prev = data.prev;
  this.user_id = data.user_id;
  this.per_recipe_stats = data.per_recipe_stats;
  this.total_stats = data.total_stats;
}

Log.prototype.date = function() {
  var date = new Date(this.log_date);
  var options = {
    weekday: 'long',
    year: 'numeric',
    month: 'long',
    day: 'numeric',
    timeZone: 'UTC'
  };
  return date.toLocaleString('en-US', options);
}

Handlebars.registerHelper('num', function(number) {
  return number.toFixed(1).toLocaleString();
});

Handlebars.registerHelper('title', function(string) {
  return string.titleize();
});

$(function() {
  $('#log-history').on('click', function(event) {
    event.preventDefault();
    event.stopPropagation();

    $('section.flash').empty();

    var url = event.target.pathname;
    var request = $.getJSON(url);

    request.done(function(data) {
      var log = new Log(data);
      var template = HandlebarsTemplates['logs/stats'];
      var chart = Chartkick.charts["chart-1"];
      var chart_data = {
        Carbs: data.total_stats.total_carbs,
        Protein: data.total_stats.total_protein,
        Fat: data.total_stats.total_fat
      };

      function historyLink(data) {
        var historyTemplate = HandlebarsTemplates['logs/history'];
        var result = "";

        if (data.prev !== null) {
          result += historyTemplate({
            direction: "prev",
            userId: data.user_id,
            logId: data.prev,
            linkText: "Previous"
          });
        }

        if (data.next !== null) {
          result += historyTemplate({
            direction: "next",
            userId: data.user_id,
            logId: data.next,
            linkText: "Next"
          });
        }

        return result;
      }

      $('#log-show-date').text("Log Date: " + log.date());
      $('#log-history').html(historyLink(log));
      chart.updateData(chart_data);
      $('#log-show-stats-table-body').html(template(data));
    });

    request.fail(function(data) {
      var message = {error: "Your request couldn't be processed!"};
      var template = HandlebarsTemplates['flashes'];
      var $flashes = $('section.flash');

      $flashes.html(template(message));
    });
  })
});

$(function() {
  $('#log-show-form form').on('submit', function(event) {
    event.preventDefault();
    event.stopPropagation();

    $('section.flash').empty();

    var $form = $(this);
    var values = $form.serialize();
    var url = $form.attr('action') + '.json';
    var post = $.ajax({
      type: "PATCH",
      url: url,
      data: values,
      dataType: 'json'
    });

    post.done(function(data) {
      var log = new Log(data);
      var template = HandlebarsTemplates['logs/stats'];
      var chart = Chartkick.charts["chart-1"];
      var chart_data = {
        Carbs: data.total_stats.total_carbs,
        Protein: data.total_stats.total_protein,
        Fat: data.total_stats.total_fat
      };

      $('#log-show-date').text("Log Date: " + log.date());
      chart.updateData(chart_data);
      $('#log-show-stats-table-body').html(template(data));
    });

    post.fail(function(data) {
      var message = {error: "Your request couldn't be processed!"};
      var template = HandlebarsTemplates['flashes'];
      var $flashes = $('section.flash');

      $flashes.html(template(message));
    });
  });
});
