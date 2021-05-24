class ColorByProductsDataModel {
  final String id;
  final String product_id;
  final String color_id;
  final String color_name;
  final String color_code;

  ColorByProductsDataModel(
      {this.id,
      this.product_id,
      this.color_id,
      this.color_name,
      this.color_code});

  factory ColorByProductsDataModel.fromMap(Map<String, dynamic> json ) => ColorByProductsDataModel(
    id: json['id'],
    product_id: json['product_id'],
    color_id: json['color_id'],
    color_code: json['color_code'],
    color_name: json['color_name']
  );
}

