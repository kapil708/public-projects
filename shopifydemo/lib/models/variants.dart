class Variants {
  int? productId;
  int? id;
  String? title;
  String? price;
  String? sku;
  int? position;
  String? inventoryPolicy;
  String? compareAtPrice;
  String? fulfillmentService;
  String? inventoryManagement;
  String? option1;
  String? option2;
  String? option3;
  String? createdAt;
  String? updatedAt;
  bool? taxable;
  bool? inStock;
  int? stockQuantity;
  String? barcode;
  int? grams;
  int? imageId;
  double? weight;
  String? weightUnit;
  int? inventoryItemId;
  int? inventoryQuantity;
  int? oldInventoryQuantity;
  bool? requiresShipping;
  String? adminGraphqlApiId;

  Variants({this.productId, this.id, this.title, this.price, this.sku, this.position, this.inStock, this.stockQuantity, this.inventoryPolicy, this.compareAtPrice, this.fulfillmentService, this.inventoryManagement, this.option1, this.option2, this.option3, this.createdAt, this.updatedAt, this.taxable, this.barcode, this.grams, this.imageId, this.weight, this.weightUnit, this.inventoryItemId, this.inventoryQuantity, this.oldInventoryQuantity, this.requiresShipping, this.adminGraphqlApiId});

  Variants.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    id = json['id'];
    title = json['title'];
    price = json['price'];
    sku = json['sku'];
    position = json['position'];
    inventoryPolicy = json['inventory_policy'];
    inStock = json['inStock'];
    stockQuantity = json['stockQuantity'];
    compareAtPrice = json['compare_at_price'];
    fulfillmentService = json['fulfillment_service'];
    inventoryManagement = json['inventory_management'];
    option1 = json['option1'];
    option2 = json['option2'];
    option3 = json['option3'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    taxable = json['taxable'];
    barcode = json['barcode'];
    grams = json['grams'];
    imageId = json['image_id'];
    weight = json['weight'];
    weightUnit = json['weight_unit'];
    inventoryItemId = json['inventory_item_id'];
    inventoryQuantity = json['inventory_quantity'];
    oldInventoryQuantity = json['old_inventory_quantity'];
    requiresShipping = json['requires_shipping'];
    adminGraphqlApiId = json['admin_graphql_api_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['id'] = id;
    data['title'] = title;
    data['price'] = price;
    data['sku'] = sku;
    data['position'] = position;
    data['inventory_policy'] = inventoryPolicy;
    data['compare_at_price'] = compareAtPrice;
    data['stockQuantity'] = stockQuantity;
    data['inStock'] = inStock;
    data['fulfillment_service'] = fulfillmentService;
    data['inventory_management'] = inventoryManagement;
    data['option1'] = option1;
    data['option2'] = option2;
    data['option3'] = option3;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['taxable'] = taxable;
    data['barcode'] = barcode;
    data['grams'] = grams;
    data['image_id'] = imageId;
    data['weight'] = weight;
    data['weight_unit'] = weightUnit;
    data['inventory_item_id'] = inventoryItemId;
    data['inventory_quantity'] = inventoryQuantity;
    data['old_inventory_quantity'] = oldInventoryQuantity;
    data['requires_shipping'] = requiresShipping;
    data['admin_graphql_api_id'] = adminGraphqlApiId;
    return data;
  }
}
