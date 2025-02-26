import 'package:atd/models/product.dart';
import 'package:atd/providers/stock_out_list_provider.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:atd/utils/widgets/stock_transfer_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StockOutPage extends StatelessWidget {
  const StockOutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockOutListProvider = Provider.of<StockOutListProvider>(context);
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Products",
            style: Theme.of(context).textTheme.titleMedium,
          ),
          ListView.builder(
            shrinkWrap: true,
            itemCount: stockOutListProvider.list.length,
            itemBuilder: (context, index) {
              return StockTransferCard(
                product: stockOutListProvider.list[index],
                onTap: () => productCLickEvent(
                    context, stockOutListProvider.list[index]),
              );
            },
          ),
        ],
      ),
    );
  }

  void productCLickEvent(BuildContext context, Product product) async {
    await showDialog(
      useSafeArea: true,
      context: context,
      builder: (context) {
        return Padding(
          padding:
              const EdgeInsets.only(left: 20, right: 20, top: 70, bottom: 70),
          child: Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(30)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Your Stock",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Material(
                      child: StockTransferCard(product: product, onTap: () {})),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, bottom: 10),
                    child: Text(
                      "Stock Out",
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  Material(
                    child: ListTile(
                      title: Text(
                        "Transfer to",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      trailing: DropdownButton<String>(
                        alignment: AlignmentDirectional.centerEnd,
                        value: "SELECT",
                        elevation: 16,
                        onChanged: (String? value) {
                          if (value != null) {}
                        },
                        items: ["SELECT", "Vashi RO"]
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                  Material(
                    child: ListTile(
                      title: Text(
                        "Quantity",
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                      trailing: const SizedBox(
                          width: 50,
                          child: TextField(
                            keyboardType: TextInputType.number,
                          )),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: CustomButton(
                              onTap: () => Navigator.of(context).pop(),
                              title: "Cancel")),
                      const SizedBox(width: 10),
                      Expanded(
                          child: CustomButton(
                        onTap: () {},
                        title: "Transfer",
                        textColor: Colors.white,
                        splashColor: primary500,
                        backgroundColor: secondary500,
                      )),
                    ],
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
