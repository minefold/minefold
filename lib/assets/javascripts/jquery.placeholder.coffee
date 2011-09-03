$('[placeholder]')
  .focus ->
    input = $(@)
    if input.val() is input.attr('placeholder')
      input.removeClass 'placeholder'
      input.val ''

  .bind 'blur change', ->
    input = $(@)
    if input.val() is '' or input.val() is input.attr('placeholder')
      input.addClass 'placeholder'
      input.val input.attr('placeholder')

  .change()
  .parents('form').submit ->
    $(@).find('[placeholder]').each ->
      input = $(@)
      input.val('') if input.val() is input.attr('placeholder')
