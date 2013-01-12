Charges = new Meteor.Collection('charges')

stripeTokenResponseManager = (status, response) ->
  if response.error
    Session.set('card_error', response.error.message)
  else
    Session.set('stripe_token', response.id)
    Session.set('card_error', null)
    console.log response

    charge = {
      token: response.id
    }

    product = Products.findOne({_id: Session.get('product_id')})
    if product?
        charge.amount = product.product_amount
        charge.name = product.product_name
        charge.product_id = product._id
        charge.created_by_id = product.user_id

    Charges.insert(
      charge
    )

updateChargeWithStripeData = (charge, token) ->
  Fiber ->
      Charges.update(
        {token: token},
        $set:
          amount: charge['amount']
          stripe_charge_id: charge['id']
          card_name: charge['card']['name']
          charge_completed_at: new Date().getTime()
      )
  .run()
  # Need to send an email receipt at this point.


Meteor.methods
 createStripeToken: (data) ->
    if Meteor.isClient
      Stripe.createToken
        name: data['card-name']
        number: data['card-number'] # "4242424242424242"
        cvc: data['card-cvc'] #"123"
        exp_month: data['card-expiry-month'] #"03"
        exp_year: data['card-expiry-year'], #"13",
        stripeTokenResponseManager

  ###
  Test payments in console with the following:

  Meteor.call('createStripeToken', {
    'card-name': 'Jonathan Doe',
    'card-number': '4242424242424242',
    'card-cvc': '123',
    'card-expiry-month': '03',
    'card-expiry-year': '13'
  });
  ###

  createStripeCharge: (charge)->
    if Meteor.isServer
      users = Meteor.users.find({_id: charge.created_by_id}, {fields: {stripe_settings: 1}})
      return if not users.count()
      user = users.fetch()[0]
      Stripe = StripeAPI(user.stripe_settings?.stripe_secret_key)

      Stripe.charges.create
        amount: charge.amount
        currency: 'USD'
        card: charge.token,
        (error, response) ->
          return if error
          updateChargeWithStripeData(response, charge.token)

  sendChargeReceipt: (charge) ->
    user = Meteor.users.findOne()
    toAddress = charge.email or user?.emails[0].address
    Email.send
      from: 'bernsno@gmail.com'
      to: toAddress
      subject: 'Thank you for signing up'
      html: "<p>Thanks for signing up for our awesome thing. This email is confirming that your card will be charged #{charge.amount}.</p>"

    Charges.update({ _id: charge._id}, {$set: {receipt_sent: true}})

  updateStripeSettings: (settings_data) ->
    if not this.userId
      throw new Meteor.Error(403, 'You must be logged in to set Stripe settings')

    Meteor.users.update(
      {_id: this.userId},
      {$set: {'stripe_settings': settings_data}}
    )