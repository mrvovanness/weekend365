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

  $('#add-to-survey-submit').click (e) ->
    e.preventDefault()

  #$('.link-add').click ->
  #$('#add-to-survey-form').submit()
