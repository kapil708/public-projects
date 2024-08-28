class Options {
  int? productId;
  String? id;
  String? name;
  int? position;
  List<String>? values;

  Options({this.productId, this.id, this.name, this.position, this.values});

  Options.fromJson(Map<String, dynamic> json) {
    productId = json['product_id'];
    id = json['id'];
    name = json['name'];
    position = json['position'];
    values = json['values'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['product_id'] = productId;
    data['id'] = id;
    data['name'] = name;
    data['position'] = position;
    data['values'] = values;
    return data;
  }
}
