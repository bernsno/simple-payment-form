Template.payment_form.charge_amount = ->
  product = Products.findOne({_id: Session.get('product_id')})
  return accounting.formatMoney(product?.product_amount / 100)

Template.payment_form.card_error = ->
  Session.get('card_error') or ''

Template.payment_form.current_user_is_creator = ->
  product = Products.findOne({_id: Session.get('product_id')})
  return product?.user_id is Meteor.userId()

Template.payment_form.product = ->
  return Products.findOne({_id: Session.get('product_id')})


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

