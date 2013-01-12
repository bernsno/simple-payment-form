Meteor.startup ->
  Session.set('stripe_token', null)


Meteor.Router.filters
  'checkLoggedIn': (page) ->
    if Meteor.loggingIn()
      return 'loading'
    else if Meteor.user()
      return page
    else
      return 'signup'

Meteor.Router.add
  '': ->
    return 'product_list'

  '/payment/:id': (id) ->
    Session.set('product_id', id)
    return 'payment_form'

  '/confirmation': ->
    return 'payment_confirmation'

  '/admin': ->
    return 'admin'


Meteor.Router.filter('checkLoggedIn')


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