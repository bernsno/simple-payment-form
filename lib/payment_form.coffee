Charges = new Meteor.Collection("charges")

stripeTokenResponseManager = (status, response) ->
  if response.error
    Session.set('card_error', response.error.message)
  else
    Session.set('stripe_token', response.id)
    Session.set('card_error', null)
    console.log response
    Charges.insert({ token: response.id, amount: Session.get('charge_amount') })

updateChargeWithStripeData = (charge, token)->
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
 createStripeToken: (data)->
    if Meteor.isClient
      Stripe.createToken
        name: data['card-name']
        number: data['card-number'] # "4242424242424242"
        cvc: data['card-cvc'] #"123"
        exp_month: data['card-expiry-month'] #"03"
        exp_year: data['card-expiry-year'], #"13",
        stripeTokenResponseManager


  createStripeCharge: (charge)->
    if Meteor.isServer
      Stripe.charges.create
        amount: charge.amount
        currency: 'USD'
        card: charge.token,
        (error, response) ->
          return if error
          updateChargeWithStripeData(response, charge.token)

  sendChargeReceipt: (charge)->
    toAddress = charge.email or 'bernsno@gmail.com'
    Email.send
      from: 'bernsno@gmail.com'
      to: toAddress
      subject: 'Thank you for signing up'
      html: "<p>Thanks for signing up for our awesome thing. This email is confirming that your card will be charged #{charge.amount}.</p>"

    Charges.update({ _id: charge._id}, {$set: {receipt_sent: true}})