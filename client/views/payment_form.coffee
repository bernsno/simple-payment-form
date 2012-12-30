Template.payment_form.charge_amount = ->
  product = Products.findOne({_id: Session.get('product_id')})
  return accounting.formatMoney(product?.product_amount / 100)

Template.payment_form.card_error = ->
  Session.get('card_error') or ''


Template.payment_form.events =
  'click button': (evt) ->
    formData = $('form').serializeJSON()
    Meteor.call 'createStripeToken', formData

    # Meteor.call('createNewCharge')
    # Call some sort of Charge creator
    #  Create stripe token
    #  Create stripe charge
    #  Create new charge in Charges collection
    # createStripeToken()

