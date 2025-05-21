import 'package:atd/core/connection/network_info.dart';
import 'package:atd/core/database/database_helper.dart';
import 'package:atd/features/dispenser_checks_feature/display/pages/dispenser_checks_screen.dart';
import 'package:atd/features/dispenser_checks_feature/display/providers/dispenser_checks_provider.dart';
import 'package:atd/features/home_navigation_feature/display/pages/home_screen.dart';
import 'package:atd/features/login_feature/data/datasources/login_local_data_source.dart';
import 'package:atd/features/login_feature/data/datasources/login_remote_data_source.dart';
import 'package:atd/features/login_feature/data/models/session_stage.dart';
import 'package:atd/features/login_feature/display/pages/login_details_screen.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/display/pages/dashboard_screen.dart';
import 'package:atd/features/vehicle_checks_feature/display/pages/vehicle_checks_screen.dart';
import 'package:atd/features/vehicle_checks_feature/display/provider/vehicle_checks_provider.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:device_info_plus/device_info_plus.dart';
import '../../data/models/user_details.dart';
import 'package:atd/features/login_feature/data/repository/login_repository_impl.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final phoneNoController = TextEditingController();
  final vehicleRegNoController = TextEditingController();
  final otpController = TextEditingController();
  bool isFinished = false;

  @override
  void initState() { 
    clearSharedPref();
    LoginRepositoryImpl repository = LoginRepositoryImpl(
      remoteDataSource: LoginRemoteDataSourceImpl(dio: Dio()),
      localDataSource: LoginLocalDataSourceImpl(
          loginDetailsBox: DatabaseHelper().userDetailsBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    repository.localDataSource.setUserDetails(userDetails: null);

      WidgetsBinding.instance.addPostFrameCallback((_) {
      final dispenserChecksProvider =  Provider.of<DispenserChecksProvider>(context, listen: false); 
      final vehicleChecksProvider =  Provider.of<VehicleChecksProvider>(context, listen: false); 

      clearDataOnLogOut(
          context, 
          dispenserChecksProvider,
          vehicleChecksProvider,
        );
    });
      
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: Stack(
          children: [
            const CustomBackground(),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 40, right: 40),
                          child: Image.asset("$imagesPath/logo.png"),
                        ),
                        Card(
                          color: white500,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                          child: Padding(
                            padding: const EdgeInsets.all(30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const SizedBox(height: 10),
                                const Center(
                                  child: Text(
                                    "Login",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                CustomTextField(
                                  controller: phoneNoController,
                                  hintText: "Phone No",
                                  isNumber: true,
                                  maxLength: 10,
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                        child: CustomTextField(
                                            controller: vehicleRegNoController,
                                            hintText: "Vehicle Reg No")),
                                    const Padding(
                                      padding:
                                          EdgeInsets.only(left: 10, right: 10),
                                      child: Text("OR"),
                                    ),
                                    IconButton(
                                        style: const ButtonStyle(),
                                        onPressed: () {},
                                        icon: const Icon(
                                          Icons.qr_code_scanner_rounded,
                                          color: Colors.black,
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  children: [
                                    Expanded(
                                        flex: 2,
                                        child: CustomTextField(
                                          controller: otpController,
                                          hintText: "OTP",
                                          isNumber: true,
                                        )),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: CustomButton(
                                          onTap: () => getOtpClickEvent(
                                              context: context,
                                              phoneNo: phoneNoController.text,
                                              vehicleRegNo:
                                                  vehicleRegNoController.text,
                                              provider: loginProvider),
                                          backgroundColor:
                                              loginProvider.isTimerActive
                                                  ? white300
                                                  : primary500,
                                          title: loginProvider.otpTitle,
                                          isEnable:
                                              loginProvider.isTimerActive ==
                                                  false,
                                        )),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                loginProvider.response.isEmpty
                                    ? const SizedBox.shrink()
                                    : Text(loginProvider.response),
                                const SizedBox(height: 5),
                                CustomButton(
                                  onTap: () => loginClickEvent(
                                    context: context,
                                    phoneNo: phoneNoController.text,
                                    vehicleRegNo: vehicleRegNoController.text,
                                    otp: otpController.text,
                                    provider: loginProvider,
                                  ),
                                  title: "Log in",
                                  backgroundColor: secondary500,
                                  splashColor: primary500,
                                  textColor: Colors.white,
                                ),
                                /* Center(
                                  child: SwipeableButtonView(
                                    buttonText: 'LOGIN',
                                    buttonWidget: const Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: secondary500,
                                    ),
                                    activeColor: secondary500,
                                    isFinished: isFinished,
                                    onWaitingProcess: () {
                                      Future.delayed(const Duration(seconds: 2),
                                          () {
                                        setState(() {
                                          isFinished = true;
                                        });
                                      });
                                    },
                                    onFinish: () async {
                                      Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen(),
                                      ));
                                      //TODO: For reverse ripple effect animation
                                      setState(() {
                                        isFinished = false;
                                      });
                                      setState(() {
                                        loginClickEvent(
                                          context: context,
                                          phoneNo: phoneNoController.text,
                                          vehicleRegNo:
                                              vehicleRegNoController.text,
                                          otp: otpController.text,
                                          provider: loginProvider,
                                        );
                                        isFinished = false;
                                      });
                                    },
                                  ),
                                ), */
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void loginClickEvent({
    required BuildContext context,
    required String phoneNo,
    required String vehicleRegNo,
    required String otp,
    required LoginProvider provider,
  }) async {
    final deviceName = await DeviceInfoPlugin()
        .deviceInfo
        .then((info) => info.data['product'].toString());
    //todo verify otp and add the api key
    provider.userDetails = UserDetails(
        phoneNo: phoneNo,
        vehicleRegNo: vehicleRegNo,
        dateTime: DateTime.now(),
        otp: otp,
        deviceName: deviceName);

    await provider.eitherFailureOrPutOtp().whenComplete(() {
      if (provider.userDetails != null && provider.failure == null) {
        provider.userDetails?.sessionStage = SessionStage.loginDetails;
        provider.changeSessionStage(sessionStage: SessionStage.loginDetails);
        // Navigator.of(context).push(MaterialPageRoute(
        //   builder: (context) => const LoginDetailsScreen(),
        // ));

      debugPrint('step-----${provider.userDetails?.step}');

      //331

      if (provider.userDetails?.step != null) {

          switch (provider.userDetails?.step) {
            case 0: 
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const LoginDetailsScreen(),
              ));
              break;
            case 1:  
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const VehicleChecksScreen(),
              ));
              break;
            case 2: 
              Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const DispenserChecksScreen(),
              ));
              break;
            case 3  : 
             Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => const HomeScreen(),
              )); 
              break;
            default: 
          }
       
        }

      }
    });

  }

  void getOtpClickEvent(
      {required BuildContext context,
      required phoneNo,
      required vehicleRegNo,
      required LoginProvider provider}) async {
    provider.userDetails = UserDetails(
      phoneNo: phoneNo,
      vehicleRegNo: vehicleRegNo,
      dateTime: DateTime.now(),
    );
    await provider.eitherFailureOrGetOtp();
  }
}
