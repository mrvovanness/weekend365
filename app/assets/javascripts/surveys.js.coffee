jQuery ->

  # Dinamically add/remove email recepients and respond with number of recipients
  $('.edit_company_survey').on 'ajax:complete', (e, data, status, xhr) ->
    message = JSON.parse(data.responseText)
    $('.control-label', this).html('Send to ' + '(' + message.employees_count + '):')

  $('#company_survey_start_at').datetimepicker
    format: 'Y-M-d H:i'

  $('#company_survey_finish_on').datetimepicker
    format: 'Y-M-d'

  joinValues = (obj) ->
    name = obj.name + ' - '
    department = obj.department + ' - '
    position = obj.position
    return name + department + position

  # Search via ajax in 'send to' form field
  $('#company_survey_employee_ids').select2
    tags: true
    closeOnSelect: false
    placeholder: 'Search by name, department, position ...'
    allowClear: true
    delay: 500
    ajax:
      url: '/employees'
      dataType: 'json'
      data: (params) ->
        q: { name_or_department_or_position_cont: params.term }
      processResults: (data) ->
        return {
          results: $.map data.employees, (obj) ->
            return { id: obj.id, text: joinValues(obj) } }

  # workaround of issue https://github.com/select2/select2/issues/3632(not work for me)
  $('.select2').on 'select2:unselect', ->
    console.log('hello')
    setTimeout ( ->
     $('.select2').select2 'close'
    ), 100

  $('#dialog').dialog
    autoOpen: false
    modal: true
    draggable: false
    resizable: false
    width: 500
  $('#add-survey-btn, .btn-create').click (e) ->
    e.preventDefault()
    $('#dialog').dialog 'open'

  $('.btn-delete').click (e) ->
    e.preventDefault()
    if $('.btn-delete').length > 1
      $(this).closest('.box').fadeOut 'slow', ->
        $(this).remove()
