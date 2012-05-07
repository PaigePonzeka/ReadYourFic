(function() {
  var getUrlVars, intializeFilters;

  $(document).ready(function() {
    window.current_controller = $('body').attr('id');

    if (current_controller === "stories") {
      intializeFilters();
      return $(".chzn-select").chosen();
    }
  });

  getUrlVars = function() {
    var characters, parts, themes, vars;
    vars = {};
    characters = [];
    themes = [];
    ships = [];
    parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/g, function(m, key, value) {
      vars[key] = value;
      if (key === "character%5B%5D") {
        return characters.push(value);
      } else if (key === "themes%5B%5D") {
        return themes.push(value);
      }
      } else if (key === "ships%5B%5D") {
        return ships.push(value);
      }
    });
    vars["characters"] = characters;
    vars["themes"] = themes;
    vars["ships"] = ships;
    return vars;
  };

  intializeFilters = function() {
    var character, characters, theme, themes, url_vars, _results;
    url_vars = getUrlVars();
    if (url_vars['search']) $('#search').val(url_vars['search']);
    characters = url_vars['characters'];
    if (characters.length > 0) {
      for (character in characters) {
        $("#character option[value=" + characters[character] + "]").attr("selected", "selected");
      }
    }
    themes = url_vars['themes'];
    if (themes.length > 0) {
      _results = [];
      for (theme in themes) {
        _results.push($("#themes option[value=" + themes[theme] + "]").attr("selected", "selected"));
      }
      return _results;
    }
  };

}).call(this);
