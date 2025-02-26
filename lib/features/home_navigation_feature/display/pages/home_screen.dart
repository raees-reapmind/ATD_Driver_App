import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:atd/utils/palette.dart';
import 'package:atd/utils/widgets/custom_background.dart';
import 'package:atd/utils/widgets/failure_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../utils/widgets/provider_export.dart';
import '../../../login_feature/display/pages/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final navigationProvider = Provider.of<DrawerNavigationProvider>(context);
    final loginProvider = Provider.of<LoginProvider>(context);
    final routineProvider = Provider.of<RoutinesProvider>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          title: Text(navigationProvider
              .pageList[navigationProvider.selectedPageIndex].title),
          actions: [
            IconButton(
                onPressed: () =>
                    syncClickEvent(context, routineProvider, loginProvider),
                icon: const Icon(Icons.sync))
          ],
        ),
        drawer: Drawer(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 120,
                child: DrawerHeader(
                    decoration: const BoxDecoration(color: secondary500),
                    padding: const EdgeInsets.all(0),
                    child: Container(
                      color: secondary500,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const CircleAvatar(
                              radius: 22,
                              backgroundColor: Colors.white,
                              child: Icon(
                                Icons.person,
                                color: secondary500,
                                size: 30,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  loginProvider.userDetails!.vehicleRegNo,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(color: Colors.white),
                                ),
                                Text(
                                  loginProvider.userDetails!.phoneNo,
                                  style: Theme.of(context)
                                      .textTheme
                                      .subtitle2
                                      ?.copyWith(color: Colors.white60),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    )),
              ),
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: navigationProvider.pageList.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: navigationProvider.pageList[index].icon,
                    tileColor: navigationProvider.pageList[index].isSelected
                        ? primary500
                        : null,
                    title: Text(navigationProvider.pageList[index].title),
                    onTap: () {
                      navigationProvider.selectedPageIndex = index;
                      Navigator.pop(context);
                    },
                  );
                },
              ),
              ListTile(
                onTap: () => logOutClickEvent(context, loginProvider),
                leading: const Icon(
                  Icons.logout,
                  color: red500,
                ),
                title: const Text("Logout"),
              )
            ],
          ),
        ),
        body: SafeArea(
          child: Stack(
            children: [
              const CustomBackground(),
              navigationProvider
                  .pageList[navigationProvider.selectedPageIndex].page,
            ],
          ),
        ),
      ),
    );
  }

  void logOutClickEvent(
      BuildContext context, LoginProvider loginProvider) async {
    await loginProvider
        .changeSessionStage(sessionStage: SessionStage.logout)
        .whenComplete(() {
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const LoginScreen()));
    });
  }

  void syncClickEvent(BuildContext context, RoutinesProvider routineProvider,
      LoginProvider loginProvider) {
    routineProvider
        .eitherFailureOrGetRoutines(
            apiToken: loginProvider.userDetails!.apiToken!)
        .then((value) {
      if (!value) {
        showDialog(
            context: context,
            builder: (context) => FailureDialog(
                  content: routineProvider.failure!.errorMessage.toString(),
                ));
      }
    });
  }
}
