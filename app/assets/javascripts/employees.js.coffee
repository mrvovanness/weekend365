jQuery ->

  $('#select_all-styler').click ->
    if $(this).hasClass 'checked'
      $('.bulk_actors').each ->
        $(this).addClass 'checked'
        $('input', this).prop 'checked', true
    else
      $('.bulk_actors').each ->
        $(this).removeClass 'checked'
        $('input', this).prop 'checked', false

  $('.bulk_actors, #select_all-styler').click ->
    check_count = $('.checked').size()
    if check_count > 0
      $('#add-to-survey-submit').fadeIn 'slow'
    else
      $('#add-to-survey-submit').fadeOut 'slow'

  $('.link-add').click ->
    $('#add-to-survey-form').submit()
