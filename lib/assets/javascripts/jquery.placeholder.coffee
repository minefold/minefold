$('[placeholder]')
  .focus ->
    input = $(@)
    console.log 'focus change', input.val(), input.attr('placeholder')
    if input.val() is input.attr('placeholder')
      console.log 'SHAWSOME'
      input.removeClass 'placeholder'
      input.val ''

  .bind 'blur change', ->
    input = $(@)
    console.log 'blur', input.val()
    if input.val() is '' or input.val() is input.attr('placeholder')
      input.addClass 'placeholder'
      input.val input.attr('placeholder')

  .change()
  .parents('form').submit ->
    $(@).find('[placeholder]').each ->
      input = $(@)
      input.val('') if input.val() is input.attr('placeholder')
