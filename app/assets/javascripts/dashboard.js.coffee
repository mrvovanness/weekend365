jQuery ->
  $('#float-filter-form').hcSticky({
    top: $(window).height() - 430
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
  
