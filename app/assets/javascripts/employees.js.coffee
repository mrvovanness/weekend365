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
    format: 'Y-m-d'
    mask: true
    lang: $('html').attr('lang')

  $('#add-selected-to-survey').click (e) ->
    e.preventDefault()
    $('#dialog').dialog('open')

  $('#form-submit').click (e) ->
    e.preventDefault()
    $('#survey-form').append($('.bulk_actors'))
    $('.bulk_actors').hide()
    $('#dialog-form').submit()

  $('#dialog').dialog
    autoOpen: false
    modal: true
    height: 300
    width: 500
