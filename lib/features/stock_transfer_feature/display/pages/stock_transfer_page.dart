import 'package:atd/providers/stock_transfer_navigation_provider.dart';
import 'package:atd/features/stock_transfer_feature/display/pages/stock_in_page.dart';
import 'package:atd/features/stock_transfer_feature/display/pages/stock_out_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../../utils/utils_export.dart';

class StockTransferPage extends StatelessWidget {
  final pageController = PageController();

  StockTransferPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final stockTransferNavigationProvider = Provider.of<StockTransferNavigationProvider>(context);

    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: Card(
                  color: white500,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          GestureDetector(
                            onTap: () {
                              stockTransferNavigationProvider.selectedPageIndex = 0;
                              pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn);
                            },
                            child: Text("Stock Out",
                                style: TextStyle(
                                    color: stockTransferNavigationProvider.selectedPageIndex == 0
                                        ? primary500
                                        : Colors.black38,
                                    fontWeight: FontWeight.bold)),
                          ),
                          GestureDetector(
                            onTap: () {
                              stockTransferNavigationProvider.selectedPageIndex = 1;
                              pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn);
                            },
                            child: Text("Stock In",
                                style: TextStyle(
                                    color: stockTransferNavigationProvider.selectedPageIndex == 1
                                        ? primary500
                                        : Colors.black38,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                              child: Container(
                            height: 2,
                            color: stockTransferNavigationProvider.selectedPageIndex == 0
                                ? primary500
                                : null,
                          )),
                          Expanded(
                              child: Container(
                            height: 2,
                            color: stockTransferNavigationProvider.selectedPageIndex == 1
                                ? primary500
                                : null,
                          )),
                        ],
                      ),
                      Expanded(
                        child: PageView(
                          controller: pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (value) {
                            stockTransferNavigationProvider.selectedPageIndex = value;
                          },
                          children: const [StockOutPage(), StockInPage()],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
