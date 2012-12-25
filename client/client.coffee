Meteor.startup ->
  Stripe.setPublishableKey('pk_test_Pi7dtNNbAP2Wc6lDcoA8fFtY');

  Session.set('stripe_token', null)
  Session.set('charge_amount', 2000)


Meteor.Router.add
  '': ->
    return 'payment_form'

  '/confirmation': ->
    return 'payment_confirmation'

  '/admin': ->
    return 'admin'


Meteor.autosubscribe ()->
  Meteor.subscribe('charges')


Charges.find().observe
  changed: (charge, index, oldCharge)->
    if Session.equals('stripe_token', charge.token) and charge.stripe_charge_id?
      Meteor.Router.to('/confirmation')
