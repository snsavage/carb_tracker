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

var LogHelpers = {
  historyLink: function(data) {
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
  },

  formID: function (data) {
    return "edit_log_" + data.id;
  },

  formAction: function(data) {
    return "/users/" + data.user_id + "/logs/" + data.id;
  },

  chartData: function(data) {
    return {
      Carbs: data.total_stats.total_carbs,
      Protein: data.total_stats.total_protein,
      Fat: data.total_stats.total_fat
    }
  }
}

window.init = function() {
  $(function() {
    $('#log-history').on('click', function(event) {
      event.preventDefault();
      event.stopPropagation();

      $('section.flash').empty();

      $.getJSON(event.target.pathname)
        .done(function(data) {
          var log = new Log(data);
          var template = HandlebarsTemplates['logs/stats'];
          var chart = Chartkick.charts["chart-1"];

          $('#log-show-date').text("Log Date: " + log.date());
          $('#log-history').html(LogHelpers.historyLink(log));
          chart.updateData(LogHelpers.chartData(data));
          $('#log-show-form form').attr('id', LogHelpers.formID(data));
          $('#log-show-form form').attr('action', LogHelpers.formAction(data));
          $('#log-show-stats-table-body').html(template(data));
        })
        .fail(function(data) {
          var message = {error: "Your request couldn't be processed!"};
          var template = HandlebarsTemplates['flashes'];
          var $flashes = $('section.flash');

          $flashes.html(template(message));
        });
    })

    $('#log-show-form form').on('submit', function(event) {
      event.preventDefault();
      event.stopPropagation();

      $('section.flash').empty();

      $.ajax({
        type: "PATCH",
        url: $(this).attr('action') + '.json',
        data: $(this).serialize(),
        dataType: 'json'
      })
      .done(function(data) {
        var log = new Log(data);
        var template = HandlebarsTemplates['logs/stats'];
        var chart = Chartkick.charts["chart-1"];

        $('#log-show-date').text("Log Date: " + log.date());
        chart.updateData(LogHelpers.chartData(data));
        $('#log-show-stats-table-body').html(template(data));
      })
      .fail(function(data) {
        var message = {error: "Your request couldn't be processed!"};
        var template = HandlebarsTemplates['flashes'];
        var $flashes = $('section.flash');

        $flashes.html(template(message));
      });
    });
  });
};

init();
