import 'package:atd/features/dispenser_feature/display/providers/dispenser_page_navigation_provider.dart';
import '../../../../routine_feature/data/models/routine.dart'; 
import 'dispenser_2_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../../utils/utils_export.dart';
import 'dispenser_1_page.dart';

class DispenserScreen extends StatelessWidget {
  final Routine routine;
  final pageController = PageController();

  DispenserScreen({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final dispenserNavigationProvider =
        Provider.of<DispenserPageNavigationProvider>(context);
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
                              dispenserNavigationProvider.selectedPageIndex = 0;
                              pageController.animateToPage(0,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn);
                            },
                            child: Text("DU 1",
                                style: TextStyle(
                                    color: dispenserNavigationProvider
                                                .selectedPageIndex ==
                                            0
                                        ? primary500
                                        : Colors.black38,
                                    fontWeight: FontWeight.bold)),
                          ),
                          GestureDetector(
                            onTap: () {
                              dispenserNavigationProvider.selectedPageIndex = 1;
                              pageController.animateToPage(1,
                                  duration: const Duration(milliseconds: 400),
                                  curve: Curves.fastOutSlowIn);
                            },
                            child: Text("DU 2",
                                style: TextStyle(
                                    color: dispenserNavigationProvider
                                                .selectedPageIndex ==
                                            1
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
                            color:
                                dispenserNavigationProvider.selectedPageIndex ==
                                        0
                                    ? primary500
                                    : null,
                          )),
                          Expanded(
                              child: Container(
                            height: 2,
                            color:
                                dispenserNavigationProvider.selectedPageIndex ==
                                        1
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
                            dispenserNavigationProvider.selectedPageIndex =
                                value;
                          },
                          children: [
                            Dispenser1Page(routine: routine),
                            Dispenser2Page(routine: routine)
                          ],
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
