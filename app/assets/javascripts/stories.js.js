(function() {
  var getUrlVars, intializeFilters;

  $(document).ready(function() {
    window.current_controller = $('body').attr('id');
    console.log(current_controller);
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
    parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/g, function(m, key, value) {
      vars[key] = value;
      if (key === "character%5B%5D") {
        return characters.push(value);
      } else if (key === "themes%5B%5D") {
        return themes.push(value);
      }
    });
    vars["characters"] = characters;
    vars["themes"] = themes;
    return vars;
  };

  intializeFilters = function() {
    var character, characters, theme, themes, url_vars, _results;
    url_vars = getUrlVars();
    console.log(url_vars);
    console.log(url_vars['search']);
    console.log(url_vars['character%5B%5D']);
    console.log(url_vars['themes%5B%5D']);
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
