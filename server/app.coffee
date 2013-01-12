root = this

Meteor.publish 'charges', ->
  Charges.find({created_by_id: this.userId})

Meteor.publish 'products', ->
  Products.find()

Meteor.publish 'directory', ->
  return if not this.userId
  users = Meteor.users.find({_id: this.userId}, {fields: {emails: 1, profile: 1, name: 1, stripe_settings: 1}})
  return users

Charges.find().observe
  added: (charge) ->
    if charge.token? and not charge.stripe_charge_id?
      Meteor.call('createStripeCharge', charge)
  changed: (charge, index, oldCharge) ->
    if charge.stripe_charge_id? and not charge.receipt_sent?
      Meteor.call('sendChargeReceipt', charge)
