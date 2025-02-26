import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:atd/features/routine_feature/display/pages/dashboard_screen.dart';
import 'package:atd/utils/helper.dart';
import 'package:flutter/material.dart';

class DrawerNavigationProvider with ChangeNotifier {
  int _selectedPageIndex = 0;

  SessionStage _sessionStage = SessionStage.loginDetails;

  set sessionStage(SessionStage sessionStage) {
    _sessionStage = sessionStage;
    notifyListeners();
  }

  int get selectedPageIndex => _selectedPageIndex;

  set selectedPageIndex(int value) {
    _selectedPageIndex = value;
    for (DrawerPage page in pageList) {
      page.isSelected = false;
    }
    pageList[value].isSelected = !pageList[value].isSelected;
    notifyListeners();
  }

  /* final pageList = [
    DrawerPage(
        title: "Orders",
        page: const RoutinePage(),
        isSelected: true,
        icon: const ImageIcon(
          AssetImage("$imagesPath/icons/orders.png"),
          size: 20,
        )),
    DrawerPage(
      title: "Vehicle Checks",
      page: const VehicleChecksPage(),
      isSelected: false,
      icon: const ImageIcon(
        AssetImage("$imagesPath/icons/vehicle_checks.png"),
        size: 20,
      ),
    ),
    DrawerPage(
      title: "Dispenser Checks",
      page: const DispenserChecksPage(),
      isSelected: false,
      icon: const ImageIcon(
        AssetImage("$imagesPath/icons/dispenser_checks.png"),
        size: 20,
      ),
    ),
    DrawerPage(
      title: "Stock Transfer",
      page: StockTransferPage(),
      isSelected: false,
      icon: const ImageIcon(
        AssetImage("$imagesPath/icons/stock_transfer.png"),
        size: 20,
      ),
    ),
  ]; */
  final pageList = [
    DrawerPage(
        title: "Home",
        page: const DashboardScreen(),
        isSelected: true,
        icon: const ImageIcon(
          AssetImage("$imagesPath/icons/orders.png"),
          size: 20,
        )),
  ];
}

class DrawerPage {
  final String title;
  final ImageIcon icon;
  final Widget page;
  bool isSelected;

  DrawerPage(
      {required this.title,
      required this.icon,
      required this.page,
      required this.isSelected});
}
