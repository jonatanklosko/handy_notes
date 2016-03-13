onEveryPage ->
  $('.hide-alert').on 'click', ->
    $(this).parent('.alert').hide()