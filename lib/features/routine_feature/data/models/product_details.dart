class ProductDetails {
  final int id;
  final String name;
  final String skuUom;
  final int skuQuantity;

  ProductDetails({
    required this.id,
    required this.name,
    required this.skuUom,
    required this.skuQuantity,
  });


  @override
  String toString() {
    return 'ProductDetails{id: $id, name: $name, skuUom: $skuUom, skuQuantity: $skuQuantity}';
  }

  factory ProductDetails.fromMap(Map<String, dynamic> data) {
    return ProductDetails(
      id: data['id'],
      name: data['name'],
      skuUom: data['sku_uom'],
      skuQuantity: int.parse(data['sku_qty']),
    );
  }
}
