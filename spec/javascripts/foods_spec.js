describe("foods.js", function() {
  describe("Food", function() {
    beforeEach(function() {
      data = {
        "id":90,
        "unique_name":"Apple - 1.0 - Medium (3\" Dia)"
      }
    });

    it("is defined", function() {
      expect(new Food(data)).toBeDefined();
    });

    it("has id and name properties", function() {
      var food = new Food(data);
      expect(food.id).toBe(data.id);
      expect(food.name).toBe(data.unique_name);
    });

    it("has a showLink property", function() {
      var food = new Food(data);
      expect(food.showLink).toBe("/foods/" + data.id);
    });

    it("has a tempId property that with memoization", function() {
      spyOn(FoodHelpers, 'rand').and.callThrough();
      var food = new Food(data);

      var randNumber = food.tempId;
      expect(FoodHelpers.rand).toHaveBeenCalled();
      expect(food.tempId).not.toBe(null);

      food.tempId;
      expect(FoodHelpers.rand.calls.count()).toBe(1);
      expect(randNumber).toBe(food.tempIdCache);
    });
  });

  describe("FoodHelpers", function() {
    describe("rand", function() {
      it("creates a 10 digit random number", function() {
        expect(FoodHelpers.rand().toString().length).toBe(10);
        expect(typeof(FoodHelpers.rand())).toBe("number");
      });
    });

    describe("parse", function() {
      beforeEach(function() {
        data = [{
          "id": 90,
          "unique_name": "Apple - 1.0 - Medium (3\" Dia)"
        }, {
          "id": 91,
          "unique_name": "Banana - 1.0 - Medium (7\" To 7 7/8\" Long)"
        }, {
          "id": 110,
          "unique_name": "Blueberries - 2.0 - Cups"
        }];

        parsedData = FoodHelpers.parse(data);
      });

      it("returns an Array", function() {
        expect(parsedData instanceof Array).toBe(true);
      });

      it("returns an array of Food instances", function() {
        expect(parsedData[0] instanceof Food).toBe(true);
      });

      it("parses all foods in json data", function() {
        expect(parsedData.length).toBe(3);
      });
    });
  });

  describe("foods index clicking on sort links", function() {
    beforeEach(function() {
      links = affix('p');
      links.affix('a.foods-sort[href="/foods?sort=asc"]');
      links.affix('a.foods-sort[href="/foods?sort=desc"]');
      foods = affix('div#foods-index');

      init();

      data = [{
        "id": 90,
        "unique_name": "Apple - 1.0 - Medium (3\" Dia)"
      }, {
        "id": 91,
        "unique_name": "Banana - 1.0 - Medium (7\" To 7 7/8\" Long)"
      }];

      this.server = sinon.fakeServer.create();
      this.server.fakeHTTPMethods = true;
    });

    xit("clicking 'ascending' link sort foods ascending", function() {
      $('.foods-sort')[0].click();
      this.server.respond(JSON.stringify([data[0], data[1]]));
      expect($('#foods-index').children().length).toBe(2);
      expect($.map($('#foods-index a'), function(e) { return e.text; }))
        .toEqual([data[0].unique_name, data[1].unique_name]);
    });

    xit("clicking 'descending' link sort foods descending", function() {
      $('.foods-sort')[1].click();
      this.server.respond(JSON.stringify([data[1], data[0]]));
      expect($('#foods-index').children().length).toBe(2);
      expect($.map($('#foods-index a'), function(e) { return e.text; }))
        .toEqual([data[1].unique_name, data[0].unique_name]);
    });

    afterEach(function() {
      this.server.restore;
    });
  });

  describe("food search for recipe new and edit", function() {
    var searchForm;

    beforeEach(function() {
      searchForm = affix('#foods-search-form input[type=submit]');

      init();
    });

    it("searching without search terms flashes search error", function() {
      $(searchForm).click();

      expect(searchForm).toHandle('click');
      expect($.getJSON).toHaveBeenCalledWith("/foods/search", {query: ""});
    });
  });
});

