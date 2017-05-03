describe("handlebars_helpers.js", function() {
  describe("select_list", function() {
    beforeEach(function() {
      data = {
        "foods": [
        {
          "id": 90,
          "unique_name": "Apple - 1.0 - Medium (3\" Dia)"
        },
        {
          "id": 100,
          "unique_name": "Food"
        }
        ],
        "select": [
        {
          "id": 90,
          "unique_name": "Apple - 1.0 - Medium (3\" Dia)"
        }
        ]
      }
    });

    it("renders a single select list item", function() {
      var result = '<option value="90">'
        + 'Apple - 1.0 - Medium (3&quot; Dia)'
        + '</option>\n';
      var helper = Handlebars.helpers.select_list;
      var select = helper(data.select, data.foods[1].id).string;

      expect(select).toBe(result);
    });

    it("renders the select with a selected attribute", function() {
      var result = '<option selected="selected" value="90">'
        + 'Apple - 1.0 - Medium (3&quot; Dia)'
        + '</option>\n';
      var helper = Handlebars.helpers.select_list;
      var select = helper(data.select, data.foods[0].id).string;

      expect(select).toBe(result);
    });
  });
});

