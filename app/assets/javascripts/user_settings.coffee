$(document).on 'page:change', ->
  sectionTop = $('.error-messages-box').prev().offset().top
  $(window).scrollTop(sectionTop)
  
  $('.field_with_errors>input').first().focus()
