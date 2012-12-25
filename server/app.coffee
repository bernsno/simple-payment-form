Stripe = StripeAPI('sk_test_dD9AuSRT9AeuDv489WI2ZFzu')


Meteor.publish 'charges', ->
  Charges.find()

Charges.find().observe
  added: (charge)->
    if charge.token and not charge.stripe_charge_id?
      Meteor.call('createStripeCharge', charge)
  changed: (charge, index, oldCharge)->
    if charge.stripe_charge_id? and not charge.receipt_sent?
      Meteor.call('sendChargeReceipt', charge)

