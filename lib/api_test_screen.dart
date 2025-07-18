import 'dart:convert';
import 'dart:io';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/data/models/routine_details.dart';
import 'package:atd/utils/qr_screen.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'features/login_feature/data/models/user_details.dart';
import 'features/vehicle_checks_feature/domain/entities/vehicle_check.dart';

class ApiTestScreen extends StatefulWidget {
  const ApiTestScreen({Key? key}) : super(key: key);

  @override
  State<ApiTestScreen> createState() => _ApiTestScreenState();
}

class _ApiTestScreenState extends State<ApiTestScreen> {
  final loginUrl = 'http://13.127.149.69/api/driver/login';

  final verifyOtpUrl = 'http://13.127.149.69/api/otp';

  final getVehicleChecksUrl = 'http://13.127.149.69/api/app/vehicle-checklists';

  final postVehicleChecksUrl =
      'http://13.127.149.69/api/app/vehicle-checklists';

  final postVehicleLocationUrl =
      'http://13.127.149.69/api/app/vehicle-location';

  final getDispenserChecksUrl =
      'http://13.127.149.69/api/app/vehicle-dispenser-checks';

  final postDispenserChecksUrl =
      'http://13.127.149.69/api/app/vehicle-dispenser-checks';

  final getVehicleReadingsUrl = 'http://13.127.149.69/api/app/vehicle-readings';

  final postVehicleReadingsUrl =
      'http://13.127.149.69/api/app/vehicle-readings';

  final getRoutinesUrl = 'http://13.127.149.69/api/app/routines';

  final postImageUploadUrl = 'http://13.127.149.69/api/app/media';
  XFile? image;

  String apiToken = '';
  String message = '';

  @override
  Widget build(BuildContext context) {
    final loginProvider = Provider.of<LoginProvider>(context);

    return SafeArea(
      child: Scaffold(
          body: Center(
        child: Column(
          children: [
            // ElevatedButton(
            //     onPressed: () => otpClickEvent(), child: const Text('GET OTP')),
            // ElevatedButton(
            //     onPressed: () => loginClickEvent(),
            //     child: const Text('PUT OTP')),
            // ElevatedButton(
            //     onPressed: () => getVehicleCheckClickEvent(),
            //     child: const Text('GET VEHICLE CHECK LIST')),
            // ElevatedButton(
            //     onPressed: () => postVehicleChecksClickEvent(),
            //     child: const Text('POST VEHICLE CHECK LIST')),
            // ElevatedButton(
            //     onPressed: () => getDispenserChecksClickEvent(),
            //     child: const Text('GET DISPENSER CHECK LIST')),
            // ElevatedButton(
            //     onPressed: () => postDispenserChecksClickEvent(),
            //     child: const Text('POST DISPENSER CHECK LIST')),
            // ElevatedButton(
            //     onPressed: () => getVehicleReadingsClickEvent(),
            //     child: const Text('GET VEHICLE READINGS')),
            // ElevatedButton(
            //     onPressed: () => postVehicleReadingsClickEvent(),
            //     child: const Text('POST VEHICLE READINGS')),
            // ElevatedButton(
            //     onPressed: () => getRoutineClickEvent(),
            //     child: const Text('GET ROUTINE')),
            ElevatedButton(
                onPressed: () =>
                    debugPrint(loginProvider.userDetails.toString()),
                child: const Text('DATA')),
            ElevatedButton(
                onPressed: () => getRoutineClickEvent(loginProvider),
                child: const Text('GET')),
            ElevatedButton(
                onPressed: () => postDispenserChecksClickEvent(loginProvider),
                child: const Text('POST')),
            ElevatedButton(
                onPressed: () => Navigator.of(context).push(MaterialPageRoute(
                    builder: ((context) => const QRScanner()))),
                child: const Text('QR')),
            Text(message),
            image != null
                ? Image.file(File(image!.path))
                : const SizedBox.shrink(),
          ],
        ),
      )),
    );
  }

  void otpClickEvent() async {
    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers['Accept'] = 'application/json';

    final response = await dio.post(
      loginUrl,
      data: json.encode({"mobile": "1111111111", "vehicle_no": "MH02GG1234"}),
    );
    if (response.statusCode == 200) {
      debugPrint(response.data.toString());
    }
  }

  void loginClickEvent() async {
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] =
        Headers.formUrlEncodedContentType;
    dio.options.headers['Accept'] = 'application/json';

    final response = await dio.put(
      verifyOtpUrl,
      data: {
        "otp": "1234",
        "mobile": "1111111111",
        "device_name": "One Plus X"
      },
      options: Options(followRedirects: false),
    );
    Map<String, dynamic> map = (response.data);
    debugPrint(map.toString());
    final result = map['result'];
    apiToken = result['token'];
  }

  void getVehicleCheckClickEvent(LoginProvider loginProvider) async {
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${loginProvider.userDetails?.apiToken}';
    dio.options.headers['Accept'] = 'application/json';
    final response = await dio.get(
      getVehicleChecksUrl,
      options: Options(validateStatus: (status) => true),
    );

    final responseMap = Map<String, dynamic>.from(response.data);
    if (responseMap['results'] != null) {
      List<VehicleCheck> data = responseMap['results'].map<VehicleCheck>((e) {
        return VehicleCheck.fromMap(e);
      }).fromList();
      debugPrint(data.length.toString());
    } else {
      debugPrint(responseMap['error'].toString());
    }
  }

  void postVehicleChecksClickEvent(LoginProvider loginProvider) async {
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${loginProvider.userDetails?.apiToken}';
    var response = await dio.post(
      postVehicleChecksUrl,
      data: {
        "checks": [
          {"id": 1, "status": 2},
          {"id": 2, "status": 3}
        ]
      },
      options: Options(validateStatus: (status) => true),
    );
    debugPrint(response.data.toString());
  }

  void getDispenserChecksClickEvent(LoginProvider loginProvider) async {
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${loginProvider.userDetails?.apiToken}';
    dio.options.headers['Accept'] = 'application/json';

    var response = await dio.get(
      getDispenserChecksUrl,
      options: Options(validateStatus: (status) => true),
    );
    debugPrint(response.data.toString());
  }

  void postDispenserChecksClickEvent(LoginProvider loginProvider) async {
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${loginProvider.userDetails?.apiToken}';
    dio.options.headers['Accept'] = 'application/json';

    var response = await dio.post(
      postDispenserChecksUrl,
      data: {
        "list": [
          {
            "from_type": "vehicle",
            "to_type": "can",
            "quantity_requested": 10,
            "quantity_dispensed": 15,
            "image": [],
          },
        ]
      },
      options: Options(validateStatus: (status) => true),
    );
    debugPrint(response.data.toString());
    debugPrint(response.statusCode.toString());
  }

  void getVehicleReadingsClickEvent() async {
    final Dio dio = Dio();

    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';

    var response = await dio.get(
      getVehicleReadingsUrl,
      queryParameters: {"vehicle_id": 1},
      options: Options(validateStatus: (status) => true),
    );
    debugPrint(response.data.toString());
  }

  void postVehicleReadingsClickEvent() async {
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] = 'Bearer $apiToken';
    dio.options.headers['Accept'] = 'application/json';
    var response = await dio.post(
      postVehicleReadingsUrl,
      data: {
        "vehicle_id": 1,
        "from_type": "vehicle",
        "to_type": "can",
        "quantity_requested": 10,
        "quantity_dispensed": 15,
      },
      options: Options(validateStatus: (status) => true),
    );
    debugPrint(response.data.toString());
  }

  void getRoutineClickEvent(LoginProvider loginProvider) async {
    debugPrint('[api-test] getRoutineClickEvent called---');
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] = ContentType.json;
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${loginProvider.userDetails?.apiToken}';
    dio.options.headers['Accept'] = ContentType.json;
    var response = await dio.get(
      getRoutinesUrl,
      options: Options(validateStatus: (status) => true),
    );

    final result = Map<String, dynamic>.from(response.data);
    debugPrint('[api-test] getRoutineClickEvent result---$result');

    final RoutineDetails routineDetails =
        RoutineDetails.fromMap(result['result']);
    debugPrint(routineDetails.toString());
    // final routineDetails = result['result']['routines']
    //     .map((json) => RoutineDetails.fromJson(json))
    //     .toList();
    // routineDetails.map((e) => debugPrint("$e \n")).toList();
  }

  void getOtp(LoginProvider loginProvider) {
    loginProvider.userDetails = UserDetails(
        phoneNo: "9878786754",
        vehicleRegNo: "MH02GG1234",
        dateTime: DateTime.now());
    loginProvider.eitherFailureOrGetOtp();
  }

  void putOtp(LoginProvider loginProvider) {
    loginProvider.userDetails = UserDetails(
        phoneNo: "9878786754",
        vehicleRegNo: "MH02GG1234",
        dateTime: DateTime.now(),
        otp: "1234");
    loginProvider.eitherFailureOrPutOtp();
  }

  Future<XFile?> pickImage() async {
    try {
      final pickedImage = await ImagePicker()
          .pickImage(source: ImageSource.camera, imageQuality: 50);
      debugPrint(
          "path : ${pickedImage == null ? pickedImage.toString() : pickedImage.path.toString()}");
      return pickedImage;
    } catch (e) {
      debugPrint("error : ${e.toString()}");
    }
    return null;
  }

  void postUploadImageClickEvent(LoginProvider loginProvider,
      ImageUploadProvider imageUploadProvider) async {
    final Dio dio = Dio();
    dio.options.headers[HttpHeaders.contentTypeHeader] = 'application/json';
    dio.options.headers[HttpHeaders.authorizationHeader] =
        'Bearer ${loginProvider.userDetails?.apiToken}';
    dio.options.headers['Accept'] = 'application/json';

    XFile? image = await pickImage();
    if (image != null) {
      this.image = image;
      final imageForm = FormData.fromMap({
        'media': await MultipartFile.fromFile(image.path, filename: image.name),
      });
      await imageUploadProvider.eitherFailureOrUploadImage(
          apiToken: loginProvider.userDetails!.apiToken!,
          imagePath: image.path);
      if (imageUploadProvider.imageId != null &&
          imageUploadProvider.failure == null) {
        message = imageUploadProvider.imageId.toString();
      } else {
        message = imageUploadProvider.failure!.errorMessage.toString();
      }

      setState(() {});

      /* final response = await dio.post(
        postImageUploadUrl,
        data: imageForm,
        options: Options(validateStatus: (status) => true),
      );
      if (response.statusCode == 200) {
        final responseMap = Map<String, dynamic>.from(response.data);
        String id = responseMap['result']['id'];
        debugPrint('image id : $id');
      }
      debugPrint(response.toString()); */

    }
  }
}
