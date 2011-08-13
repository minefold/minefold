products = $('#orders-new #products li')

products.click (e) ->
  self = $(e.currentTarget)
  products.removeClass 'active'
  self.addClass('active')
      .find('input:radio')
      .click()

  e.preventDefault()
