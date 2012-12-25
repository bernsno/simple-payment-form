# Welcome to Meteor Payment Form

This is a simple implementation of a payment form using the Stripe API and meteor.


# To be implemented:

## General
* Store Stripe API config somewhere


## Payment Form (Iteration 1)
* Dev/Admin? can easily setup cost for purchase
* User can pay a set price for something.
  * User enters CC deets (including their name)
  * User submits the form
  * charge created at this point
  * customer/charge information stored in db
  * If successful User sees a nice thank you message (install routing)
* Admin can see charges/user information