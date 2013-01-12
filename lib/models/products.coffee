Products = new Meteor.Collection('products')

Meteor.methods
  createNewProduct: (formData) ->
    if not this.userId
      throw new Meteor.Error(403, 'You must be logged in to create a product')

    # TODO: Should add validation for form fields
    
    if Meteor.isServer
      data = formData
      data.user_id = this.userId
      data.product_amount = accounting.toFixed(formData.product_amount * 100, 0) 

      Products.insert(
        data
      )

  deleteProduct: (product_id) ->
    if not this.userId
      throw new Meteor.Error(403, 'You must be logged in to delete products')

    Products.remove(
      {_id: product_id, user_id: this.userId}
    )

  getPublishableKeyByProductId: (product_id) ->
    product = Products.findOne({_id: product_id})
    user = Meteor.users.findOne({_id: product?.user_id})
    key = user?.stripe_settings?.stripe_publishable_key
    return key