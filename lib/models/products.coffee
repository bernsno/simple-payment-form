Products = new Meteor.Collection('products')

Meteor.methods
  createNewProduct: (formData) ->
    if not this.userId
      throw new Meteor.Error(403, 'You must be logged in to create a product')

    # Should add validation for form fields

    data = formData
    data.user_id = this.userId
    data.product_amount = accounting.toFixed(formData.product_amount, 2)

    Products.insert(
      data
    )

  deleteProduct: (product_id) ->
    if not this.userId
      throw new Meteor.Error(403, 'You must be logged in to delete products')

    Products.remove(
      {_id: product_id, user_id: this.userId}
    )