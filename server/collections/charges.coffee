Charges.find().observe
  added: (charge)->
    _suppress_initial: true
    if charge.token and not charge.stripe_charge_id?
      Meteor.call('createStripeCharge', charge)
  changed: (charge, index, oldCharge)->
    if charge.stripe_charge_id? and not charge.receipt_sent?
      Meteor.call('sendChargeReceipt', charge)