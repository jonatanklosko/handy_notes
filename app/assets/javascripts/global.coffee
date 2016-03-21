onEveryPage ->
  # Make textareas auto resizing
  $('textarea').autosize()
  # Focus first text input on a page
  $('input[type="text"]:first').focus()
  # Prevent empty links from scrolling up the page
  $('a[href="#"]').on 'click', (e) ->
    e.preventDefault()