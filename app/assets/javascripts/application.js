//= require jquery
//= require jquery_ujs
//= require moment
//= require jquery.datetimepicker.js
//= require jquery.formstyler.js
//= require select2.full
//= require jquery-ui/dialog
//= require_tree .
$(document).ready(function() {
  setTimeout(function() {
    $('#flash_wrapper').fadeOut('slow', function() {
      $(this).remove();
    }); 
  }, 4000);
})
