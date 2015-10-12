jQuery ->

  $('#select_all').click ->

    if $(this).prop 'checked'
      $('.bulk_actors').each ->
        $(this).addClass 'checked'
        $('input', this).prop 'checked', true
    else
      $('.bulk_actors').each ->
        $(this).removeClass 'checked'
        $('input', this).prop 'checked', false

  $('#destroy-selected-submit').click (e) ->
    e.preventDefault()
    if $('.bulk_actors:checked').length > 0
      if confirm $('#destroy-selected-submit').data('allow')
        $('.link-add').click ->
        $('#destroy-selected-form').submit()

  $('#employee_birthday').datetimepicker
    timepicker: false
    format: 'Y-M-d'
    lang: $('html').attr('lang')
