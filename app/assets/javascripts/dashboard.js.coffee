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
    $('html,body').animate({scrollTop: commentsBlock.offset().top}, 'slow')
