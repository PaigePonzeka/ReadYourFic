(function() {

  $(document).ready(function() {
    window.current_controller = $('body').attr('id');
    console.log(current_controller);
    if (current_controller === "stories") return $(".chzn-select").chosen();
  });

}).call(this);
