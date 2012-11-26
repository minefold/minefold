# Most of this is shamelessly stolen from https://button.stripe.com/assets/inner/index.js
# Bless those Irish bastards.

class Application.OrderFormView extends Backbone.View

  @cardTypes =
    'Visa': 'visa'
    'American Express': 'amex'
    'MasterCard': 'mastercard'
    'Discover': 'discover'
    'Unknown': 'unknown'

  events:
    'keydown .number': 'formatNumber'
    'keyup .number': 'changeCardType'
    'submit': 'submit'


  show: ->
    @$el.slideDown()

  hide: ->
    @$el.slideUp()

  selectCoinPack: ($el) ->
    @cents = parseInt($el.data('cents'), 10)
    @$('#coin_pack_id').val($el.data('id'))
    @$('.form-actions .btn-success .price').text centsToCurrency(@cents)


  # Adds spaces between groups of digits when entering a card
  formatNumber: (e) =>
    number = @$('.number')
    digit = String.fromCharCode(e.which)
    return if !/^\d+$/.test(digit)

    value = number.val()

    if Stripe.cardType(value) is 'American Express'
      lastDigits = value.match /^(\d{4}|\d{4}\s\d{6})$/
    else
      lastDigits = value.match /(?:^|\s)(\d{4})$/

    if lastDigits
      number.val(value + ' ')


  # Changes the class on the card number field to reflect the type of coin card that is being entered.
  changeCardType: (e) =>
    number = @$('.number')
    type = @constructor.cardTypes[Stripe.cardType(number.val())]

    if not number.hasClass(type)
      number.removeClass(t) for _, t of @constructor.cardTypes
      number.addClass(type)
      number.toggleClass('identified', type isnt 'unknown')

  # TODO!
  validate: ->
    # var expiry, valid,
    #   _this = this;
    # valid = true;
    # this.$('input').removeClass('invalid');
    # this.$message.hide().empty();
    # this.$('input[required]').each(function(i, input) {
    #   input = $(input);
    #   if (!input.val()) {
    #     valid = false;
    #     return _this.handleError({
    #       code: 'required',
    #       input: input
    #     });
    #   }
    # });
    # if (!Stripe.validateCardNumber(this.$number.val())) {
    #   valid = false;
    #   this.handleError({
    #     code: 'invalid_number'
    #   });
    # }
    # expiry = this.expiryVal();
    # if (!Stripe.validateExpiry(expiry.month, expiry.year)) {
    #   valid = false;
    #   this.handleError({
    #     code: 'expired_card'
    #   });
    # }
    # if (this.options.cvc && !Stripe.validateCVC(this.$cvc.val())) {
    #   valid = false;
    #   this.handleError({
    #     code: 'invalid_cvc'
    #   });
    # }
    # if (!valid) {
    #   this.$('.invalid:input:first').select();
    # }
    # return valid;


  # TODO!
  handleError: (err) ->
    # case 'required':
    #   return this.invalidInput(err.input);
    # case 'card_declined':
    #   return this.invalidInput(this.$number);
    # case 'invalid_number':
    # case 'incorrect_number':
    #   return this.invalidInput(this.$number);
    # case 'invalid_expiry_month':
    #   return this.invalidInput(this.$expiryMonth);
    # case 'invalid_expiry_year':
    # case 'expired_card':
    #   return this.invalidInput(this.$expiryYear);
    # case 'invalid_cvc':
    #   return this.invalidInput(this.$cvc);

  submit: (e) =>
    e.preventDefault()

    submitButton = @$('input[type=submit]').attr('disabled', true)

    card =
      name: @$('#card_name').val()
      number: @$('#card_number').val()
      cvc: @$('#card_cvc').val()
      exp_month: @$('#card_exp_month').val()
      exp_year: @$('#card_exp_year').val()

    Stripe.createToken card, @cents, (status, response) =>
      if status isnt 200
        submitButton.attr('disabled', false)
        @handleError(response.error)

      else
        @$('#stripe_token').val(response.id)
        @el.submit()
