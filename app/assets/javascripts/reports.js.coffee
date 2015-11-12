jQuery ->
  $('#float-filter-form').hcSticky({
    top: $(window).height() - 530
    bottom: 10
    right: 0
  })
  $('#toggle-link').click (e) ->
    e.preventDefault()
    $('#sticky-panel').toggle()
    $str = $('#toggle-link').html()
    if $str == '▽'
      $str = '&#9665;'
    else
      $str = '&#9661;'
    $('#toggle-link').html($str)

  $('#see-all-comments').click (e) ->
    e.preventDefault()
    questionBlock = $(this).parents('.info-table')
    questionBlock.find('.hide').removeClass('hide')
    $(this).css('display': 'none')

  $('.to-comments').click (e) ->
    e.preventDefault()
    questionId = $(this).attr('id')
    commentsBlock = $('.panel-holder').find('#' + questionId)
    commentsBlock.find('#see-all-comments').click()
    $('#tabs').tabs('option', 'active', 1)
    $('html,body').animate({scrollTop: commentsBlock.offset().top}, 'slow')

  $('#tabs').tabs({ active: $('.active_tab').data('active') })

  $('#question-select').change ->
    $('#comments .info-table').hide()
    questionId = $('#question-select').val()
    if questionId == ''
      $('#comments .info-table').show()
    else
      commentsBlock = $('#comments .panel-holder').find('#question-' + questionId)
      commentsBlock.show()
      commentsBlock.find('#see-all-comments').click()

  $('#tabs .search').click ->
    activeTab = $('#tabs').tabs('option', 'active')
    input = $('<input>').attr('type', 'hidden').attr('name', 'active_tab').val(activeTab)
    $('#employee_search').append(input)
