//= require jquery
//= require jquery_ujs
//= require jquery-input-file-text
//= require moment
//= require jquery.datetimepicker.js
//= require jquery.formstyler.js
//= require select2.full
//= require jquery-ui/dialog
//= require jquery-ui/tabs
//= require jquery-ui/autocomplete
//= require epiceditor
//= require jquery.hc-sticky.js
//= require_tree .
$(document).ready(function() {
  setTimeout(function() {
    $('#flash_wrapper').fadeOut('slow', function() {
      $(this).remove();
    });
  }, 6000);

  $('.checkable, .selectable').styler();
})
