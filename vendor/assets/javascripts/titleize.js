(function () {
  String.prototype.titleize = function() {
    var words = this.split(" ")
      var word_count = words.length

      for(var i = 0; i < word_count; i++)
        if(i == 0 || !is_article(words[i]))
          words[i] = words[i].capitalize()

            return words.join(" ");
  }

  String.prototype.capitalize = function() {
    var word = this;
    if (word[0] && word.toUpperCase)
      return word[0].toUpperCase() + word.slice(1);
  }

  function is_article(word) {
    return (word == "a" || word == "an") ? true : false
  }
})();
