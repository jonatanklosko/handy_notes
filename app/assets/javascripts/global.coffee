onEveryPage ->
  $('textarea').autosize()
  
  $('a[href="#"]').on 'click', (e) ->
    e.preventDefault()