class Images {
  int? productId;
  int? id;
  int? position;
  String? createdAt;
  String? updatedAt;
  String? alt;
  int? width;
  int? height;
  String? src;
  List<int>? variantIds;
  String? adminGraphqlApiId;

  Images({this.productId, this.id, this.position, this.createdAt, this.updatedAt, this.alt, this.width, this.height, this.src, this.variantIds, this.adminGraphqlApiId});

  Images.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    id = json['id'];
    position = json['position'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    alt = json['alt'];
    width = json['width'];
    height = json['height'];
    src = json['src'];
    variantIds = json['variant_ids'] != null ? json['variant_ids']!.cast<int>() : null;
    adminGraphqlApiId = json['admin_graphql_api_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['id'] = id;
    data['position'] = position;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['alt'] = alt;
    data['width'] = width;
    data['height'] = height;
    data['src'] = src;
    data['variant_ids'] = variantIds;
    data['admin_graphql_api_id'] = adminGraphqlApiId;
    return data;
  }
}
