

$(document).ready ->

  window.current_controller = $('body').attr('id')
  console.log(current_controller)
  if(current_controller == "stories")

    # Intialize the filters
    intializeFilters()

    # intialize the chosen library
    $(".chzn-select").chosen()


# TODO maybe look into making a stories class object for funtions

# Get the url variables from
getUrlVars = ->
  vars = {}
  characters = []
  themes = []
  ships = []
  parts = window.location.href.replace(/[?&]+([^=&]+)=([^&]*)/g, (m, key, value) ->
    vars[key]=value
    if key == "character%5B%5D"
      characters.push(value)
    else if key == "themes%5B%5D"
      themes.push(value)
    else if key == "ships%5B%5D"
      ships.push(value)
  )
  vars["characters"] = characters
  vars["themes"] = themes
  vars["ships"] = ships
  vars


# Intialize selected fields based on the params in the url
intializeFilters= ->

  # get the parameters from the url
  url_vars = getUrlVars()

  # set the content for the search bar
  if url_vars['search']
    $('#search').val(url_vars['search'])

  # set the selected values for the characters
  characters = url_vars['characters']
  if(characters.length > 0)
    for character of characters
      $("#character option[value=" + characters[character]+"]").attr("selected","selected")


  # set the selected values for the theme
  themes = url_vars['themes']
  if(themes.length > 0)
    for theme of themes
      $("#themes option[value=" + themes[theme]+"]").attr("selected","selected")

  # set the selected for the ships
  ships = url_vars['ships']
  if(ships.length > 0)
    for ship of ships
      $("#ships option[value=" + ships[ship]+"]").attr("selected","selected")



