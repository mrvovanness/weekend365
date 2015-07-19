$(document).on('ready page:load', function() {
  $('.bulk_actors').click(function() {
    check_count = $('.bulk_actors:checked').size();
    if (check_count > 0) {
      $('#add-to-survey-submit').show();
    } else {
      $('#add-to-survey-submit').hide();
    }
  });
})
