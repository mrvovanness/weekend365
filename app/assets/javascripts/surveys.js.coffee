jQuery ->
  $('#survey_start_at').datetimepicker
    format: 'Y-M-d H:i'

  $('#survey_finish_on').datetimepicker
    format: 'Y-M-d'

  joinValues = (obj) ->
    name = obj.name + ' - '
    department = obj.department + ' - '
    position = obj.position
    return name + department + position


  $('#survey_employee_ids').select2
    closeOnSelect: false
    width: '570px'
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
