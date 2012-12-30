Template.admin.charges = ->
  Charges.find()

Template.admin.stripe_secret_key = ->
  user = Meteor.users.findOne()
  return user?.stripe_settings?.stripe_secret_key

Template.admin.stripe_publishable_key = ->
  user = Meteor.users.findOne()
  return user?.stripe_settings?.stripe_publishable_key

Template.admin.receipt_from_email = ->
  user = Meteor.users.findOne()
  return user?.stripe_settings?.receipt_from_email

Template.admin.products = ->
  return Products.find()

Template.admin.product_amount = ->
  return accounting.formatMoney(this.product_amount / 100)

Template.admin.amount = ->
  return accounting.formatMoney(this.amount / 100)

Template.admin.events
  'click .save-stripe-details-btn': (evt) ->
    formData = $(evt.target).closest('form').serializeJSON()
    Meteor.call('updateStripeSettings', formData)

  'click .add-product-btn': (evt) ->
    formInputs = $(evt.target).closest('tr').find('input')
    formData = formInputs.serializeJSON()
    Meteor.call('createNewProduct', formData)
    formInputs.val('')


  'click .delete-product-btn': (evt) ->
    Meteor.call('deleteProduct', this._id)