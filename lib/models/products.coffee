Products = new Meteor.Collection('products')

Meteor.methods
  createNewProduct: (formData) ->
    if not this.userId
      throw new Meteor.Error(403, 'You must be logged in to create a product')

    # Perform validation on options
    if not formData.product_name.length or formData.product_amount.length or formData.product_quantity.length
      throw new Meteor.Error(400, 'You missed some things!')

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