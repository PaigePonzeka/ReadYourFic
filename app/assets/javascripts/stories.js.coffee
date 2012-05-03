

$(document).ready ->
  window.current_controller = $('body').attr('id')
  console.log(current_controller)
  if(current_controller == "stories")
    $(".chzn-select").chosen()