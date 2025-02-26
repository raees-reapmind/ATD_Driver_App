import 'package:flutter/material.dart';

import '../../../../../../utils/utils_export.dart';

class StockInPage extends StatelessWidget {
  const StockInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Products",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ListTile(
            onTap: (){},
            style: ListTileStyle.list,
            horizontalTitleGap: 10,
            contentPadding:
            const EdgeInsets.only(left: 10, right: 10),
            title: const Text("Lubricant"),
            subtitle: const Text("Vashi Retail Outlet"),
            trailing: const Text("4"),
            leading: const ImageIcon(AssetImage("$imagesPath/icons/lubricant.png")),
          ),
          ListTile(
            onTap: (){},
            style: ListTileStyle.list,
            horizontalTitleGap: 10,
            contentPadding:
            const EdgeInsets.only(left: 10, right: 10),
            title: const Text("Jerry Can"),
            subtitle: const Text("Nerul Retail Outlet"),
            trailing: const Text("7"),
            leading: const ImageIcon(AssetImage("$imagesPath/icons/jerry_can.png")),
          ),
          ListTile(
            onTap: (){},
            style: ListTileStyle.list,
            horizontalTitleGap: 10,
            contentPadding:
            const EdgeInsets.only(left: 10, right: 10),
            title: const Text("Lubricant"),
            subtitle: const Text("Nerul Retail Outlet"),
            trailing: const Text("2"),
            leading: const ImageIcon(AssetImage("$imagesPath/icons/lubricant.png")),
          ),
        ],
      ),
    );
  }
}
