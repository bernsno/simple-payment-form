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
    return 'payment_form'

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
  # Update the Stripe publishable key whenever the signed in user changes
  user = Meteor.users.findOne()
  Stripe.setPublishableKey(user?.stripe_settings?.stripe_publishable_key)


Charges.find().observe
  changed: (charge, index, oldCharge)->
    if Session.equals('stripe_token', charge.token) and charge.stripe_charge_id?
      Meteor.Router.to('/confirmation')
