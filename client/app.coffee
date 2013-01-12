Meteor.startup ->
  Session.set('stripe_token', null)

Meteor.Router.add
  '': ->
    if Meteor.userId()
      return 'product_list'
    else
      return 'signup'

  '/payment/:id': (id) ->
    Session.set('product_id', id)
    if Meteor.userId()
      return 'payment_form'
    else
      return 'signup'

  '/confirmation': ->
    return 'payment_confirmation'

  '/admin': ->
    if Meteor.userId()
      return 'admin'
    else
      return 'signup'


Meteor.autosubscribe ->
  Meteor.subscribe('charges')
  Meteor.subscribe('products')
  Meteor.subscribe('directory')

Meteor.autorun ->
  # Update the Stripe publishable key whenever the product changes
  product_id = Session.get('product_id')
  return if not product_id
  Meteor.call 'getPublishableKeyByProductId', product_id, (error, result) ->
    key = result
    Stripe.setPublishableKey(key)


Charges.find().observe
  changed: (charge, index, oldCharge)->
    if Session.equals('stripe_token', charge.token) and charge.stripe_charge_id?
      Meteor.Router.to('/confirmation')