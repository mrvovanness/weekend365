$(document).ready(function () {

  $('#select_all').click(function() {
    if(this.checked) {
      $('.bulk_actors').each(function() {
        this.checked = true;
      });
    } else {
      $('.bulk_actors').each(function() {
        this.checked = false;
      });
    }
  });

  $('.bulk_actors, #select_all').click(function() {
    check_count = $('.bulk_actors:checked').size();
    if (check_count > 0) {
      $('#add-to-survey-submit').show();
    } else {
      $('#add-to-survey-submit').hide();
    }
  });
});
