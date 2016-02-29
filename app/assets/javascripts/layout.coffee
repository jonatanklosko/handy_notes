$(document).on 'page:change', ->
  $('.hide-alert').on 'click', ->
    $(this).parent('.alert').hide();
