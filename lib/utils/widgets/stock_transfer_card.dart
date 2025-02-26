import 'package:atd/models/product.dart';
import 'package:flutter/material.dart';
import '../utils_export.dart';

class StockTransferCard extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;

  const StockTransferCard({Key? key, required this.product, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => onTap(),
      style: ListTileStyle.list,
      horizontalTitleGap: 10,
      contentPadding: const EdgeInsets.only(left: 10, right: 10),
      title: Text(product.name),
      subtitle: Text(product.custody),
      trailing: Text(product.quantity.toString()),
      leading: product.id == 1
          ? const ImageIcon(AssetImage("$imagesPath/icons/lubricant.png"))
          : const ImageIcon(AssetImage("$imagesPath/icons/jerry_can.png")),
    );
  }
}
