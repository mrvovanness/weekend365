jQuery ->
  $('#float-filter-form').hcSticky({
    top: 50
    right: 0
  })
  setTimeout callback, 2000

callback = ->
  $('#float-filter-form').hcSticky('reinit')
  
