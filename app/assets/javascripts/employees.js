$(document).on('ready page:load', function() {
  $('.downloadable').click(function() {
    check_count = $('.downloadable:checked').size();
    if (check_count > 0) {
      $('#add-to-survey-submit').show();
    } else {
      $('#add-to-survey-submit').hide();
    }
  });
})
