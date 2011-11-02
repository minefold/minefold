#= require jquery

jQuery.fn.stripe = (opts={}) ->
  self = @filter('form')

  # Default options
  opts.card or= {}

  # Find the form and bind to sumbit
  self.submit (e) ->
    e.preventDefault()

    amount = if $.isFunction(opts.amount)
               opts.amount.call(window)
             else
               opts.amount

    card =
      number:    jQuery(opts.card.number || 'input.stripe.number')
                   .removeAttr('name')
                   .val()
      cvc:       jQuery(opts.card.cvc || 'input.stripe.cvc')
                   .removeAttr('name')
                   .val()
      exp_month: jQuery(opts.card.month || 'input.stripe.expiry-month')
                   .removeAttr('name')
                   .val()
      exp_year:  jQuery(opts.card.year || 'input.stripe.expiry-year')
                   .removeAttr('name')
                   .val()

    opts.submit.call(window) if $.isFunction(opts.submit)

    # TODO: Stripe.validateCardNumber(number)
    #       Stripe.validateExpiry(month, year)
    #       Stripe.validateCVC(cvc)
    
    self.get(0).submit()

    Stripe.createToken card, amount, (status, response) ->
      if status is 200

        $('<input/>')
          .attr(type: 'hidden', name: 'stripe_token')
          .val(response.id)
          .prependTo(self)

        self.get(0).submit()

      else
        opts.error.call(window, status, response) if $.isFunction(opts.error)
