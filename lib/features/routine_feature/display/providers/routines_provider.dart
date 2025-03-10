import 'package:atd/core/database/database_helper.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/login_feature/display/provider/login_provider.dart';
import 'package:atd/features/routine_feature/data/datasources/routine_remote_data_source.dart';
import 'package:atd/features/routine_feature/data/models/du_response_data.dart';
import 'package:atd/features/routine_feature/data/models/plan_details.dart';
import 'package:atd/features/routine_feature/data/models/product_details.dart';
import 'package:atd/features/routine_feature/data/models/vehicle_details.dart';
import 'package:atd/features/routine_feature/data/repository/routine_repository_impl.dart';
import 'package:atd/features/routine_feature/domain/usecases/get_routines.dart';
import 'package:atd/features/routine_feature/domain/usecases/post_delivery_report.dart';
import 'package:atd/features/routine_feature/domain/usecases/post_end_routine.dart';
import 'package:atd/features/routine_feature/domain/usecases/post_refill_report.dart';
import 'package:atd/utils/helper.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';
import '../../../../core/connection/network_info.dart';
import '../../../../core/errors/failures.dart';
import '../../../vehicle_readings_feature/data/models/image_details.dart';
import '../../data/datasources/routine_local_data_source.dart';
import '../../data/models/asset.dart';
import '../../data/models/bill.dart';
import '../../data/models/routine.dart';
import '../../domain/usecases/get_bill.dart';
import '../../domain/usecases/post_start_routine.dart';

enum Result {
  quantityFormat,
  quantityGreater,
  image,
  imageUpload,
  success,
}

enum Response {
  nullData,
  imageUploadError,
  apiError,
  success,
}

class DuStatusProvider extends ChangeNotifier {
  List<DuResponseData> duResponse = [];
  Failure? failure;
  String? message;

}

class RoutinesProvider extends ChangeNotifier {
  List<Routine> routines = [];
  ProductDetails? productDetails;
  PlanDetails? planDetails;
  VehicleDetails? vehicleDetails;
  Failure? failure;
  String? message;
  bool _isLoading = false;
  double totalDeliverdQuantity = 0;
  int ordersDelivered = 0;
  int ordersPending = 0;
  bool isRoutineEnd = false;

  bool get isLoading => _isLoading;

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void notifyDataChange() {
    notifyListeners();
  }

  void removeAssetReport({required int routineIndex, required int index}) {
    debugPrint(
        'ASSET REPORT DELETED : ${routines[routineIndex].assetsReport[index].toString()}');
    routines[routineIndex].endQuantity = routines[routineIndex].endQuantity -
        routines[routineIndex].assetsReport[index].endQuantity!;
    routines[routineIndex].assetsReport.removeAt(index);
    notifyListeners();
  }

  void removeBill({required int routineIndex, required int index}) {
    routines[routineIndex].endQuantity = routines[routineIndex].endQuantity -
        routines[routineIndex].bills[index].quantity;
    routines[routineIndex].bills.removeAt(index);
    notifyListeners();
  }

  void calculateDashboardDetails() {
    ordersDelivered = 0;
    totalDeliverdQuantity = 0;
    ordersPending = 0;
    for (Routine routine in routines) {
      if (routine.type == 'delivery') { 
        if (routine.statusCode == 3) {
          if (routine.quantity != null) {
            totalDeliverdQuantity = totalDeliverdQuantity + routine.quantity!;
          }
          ordersDelivered++;
        } else {
          ordersPending++;
        }
      }
    }
    notifyListeners();
  }

  Future<Result> createAssetDelivery({
    required LoginProvider loginProvider,
    required Asset? asset, // Make asset nullable
    required List<ImageDetails> imageList,
    required ImageUploadProvider imageUploadProvider,
    required int index,
    required double? quantity,
    String? selectedDu
  }) async {
    double currentQuantity = routines[index].endQuantity;

    // Check if an image is uploaded
    if (imageList.isEmpty) return Result.image;

    debugPrint('[api-test] createAssetDelivery asset: ${asset?.name}');
    debugPrint('[api-test] createAssetDelivery q: ${asset?.quantity}');
    debugPrint('[api-test] createAssetDelivery subjectType: ${asset?.subjectType}');

    imageList.forEach((element) {
        debugPrint('[api-test] createAssetDelivery image: ${element.imageId}');
    });

    // Check if the quantity is valid
    if (quantity == null) return Result.quantityFormat;

    // Check if the quantity does not exceed the allowed limit
    // if (currentQuantity + quantity > routines[index].quantity!) {
    //   return Result.quantityGreater;
    // }

    // Upload each image and handle failure if any
    for (ImageDetails imageDetails in imageList) {
      int? imageId = await imageUploadProvider.eitherFailureOrUploadImage(
        imagePath: imageDetails.imagePath!,
        apiToken: loginProvider.userDetails!.apiToken!,
      );
      if (imageId != null) {
        imageDetails.imageId = imageId;
      } else {
        return Result.imageUpload;
      }
    }

    // Only update asset-related information if an asset is selected
    // if (asset != null) {
    //   asset.endQuantity = quantity;
    //   asset.images = imageList;
    //   routines[index].assetsReport.add(asset);
    // }

   Asset newAsset = Asset(
    id: generateYYYYMMDDHHMMSSUniqueId(),
    name: asset!.name, // Force unwrap (will throw an error if null)
    type: asset!.type,
    qrCode: asset!.qrCode,
    quantity: asset!.quantity,
    capacity: asset!.capacity,
    endQuantity: quantity,
    odometer: asset!.odometer,
    receiptImage: asset!.receiptImage,
    subjectType: asset!.subjectType
  );


  // Assign a new list reference for images
  newAsset.images = List.from(imageList);

  routines[index].assetsReport.add(newAsset);

    // Update the routine's end quantity
    routines[index].endQuantity += quantity;
    routines[index].selectedDu = selectedDu;

    debugPrint('ASSET REPORT ADDED : $asset');
    notifyListeners();

    return Result.success;
  }


   Future<Result> createAssetDeleveryForTransfer({
    required LoginProvider loginProvider,
    required Asset? asset, // Make asset nullable
    required List<ImageDetails> imageList,
    required ImageUploadProvider imageUploadProvider,
    required int index,
    required double? quantity,
    String? selectedDu
  }) async {
    double currentQuantity = routines[index].endQuantity;

    // Check if an image is uploaded
    if (imageList.isEmpty) return Result.image;

    debugPrint('[api-test] createAssetDelivery asset: ${asset?.name}');
    debugPrint('[api-test] createAssetDelivery q: ${asset?.quantity}');
    debugPrint('[api-test] createAssetDelivery selectedDu: ${selectedDu}');

    imageList.forEach((element) {
        debugPrint('[api-test] createAssetDelivery image: ${element.imageId}');
    });

    // Check if the quantity is valid
    if (quantity == null) return Result.quantityFormat;

    // Check if the quantity does not exceed the allowed limit
    // if (currentQuantity + quantity > routines[index].quantity!) {
    //   return Result.quantityGreater;
    // }

    // Upload each image and handle failure if any
    for (ImageDetails imageDetails in imageList) {
      int? imageId = await imageUploadProvider.eitherFailureOrUploadImage(
        imagePath: imageDetails.imagePath!,
        apiToken: loginProvider.userDetails!.apiToken!,
      );
      if (imageId != null) {
        imageDetails.imageId = imageId;
      } else {
        return Result.imageUpload;
      }
    }

    // Only update asset-related information if an asset is selected
    // if (asset != null) {
    //   asset.endQuantity = quantity;
    //   asset.images = imageList;
    //   routines[index].assetsReport.add(asset);
    // }


  Asset newAsset = Asset(
    id: generateYYYYMMDDHHMMSSUniqueId(),
    name: asset!.name, // Force unwrap (will throw an error if null)
    type: asset!.type,
    qrCode: asset!.qrCode,
    quantity: asset!.quantity,
    capacity: asset!.capacity,
    endQuantity: quantity,
    odometer: asset!.odometer,
    receiptImage: asset!.receiptImage,
    subjectType: asset!.subjectType
  );
    // Update the routine's end quantity
    routines[index].endQuantity += quantity;
    routines[index].selectedDu = selectedDu;

    debugPrint('ASSET REPORT ADDED : $asset');
    notifyListeners();

    return Result.success;
  }

  Future<Response> submitEndRoutine({
    required int index,
    required LoginProvider loginProvider,
    required ImageUploadProvider imageUploadProvider,
    required List<ImageDetails> imageList,
    required double? odometerReading,
    required double? totalizerDuLeft,
    required double? totalizerDuRight,
  }) async {
    if (totalizerDuLeft == null &&
        totalizerDuRight == null &&
        odometerReading == null &&
        imageList.isEmpty) return Response.nullData;
    routines[index].endTotalizerDuLeft = totalizerDuLeft;
    routines[index].endTotalizerDuRight = totalizerDuRight;
    routines[index].odometerReading = odometerReading;
    routines[index].endDateTime = DateTime.now();
    for (ImageDetails imageDetails in imageList) {
      int? imageId = await imageUploadProvider.eitherFailureOrUploadImage(
          imagePath: imageDetails.imagePath!,
          apiToken: loginProvider.userDetails!.apiToken!);
      if (imageId != null) {
        imageDetails.imageId = imageId;
      } else {
        return Response.imageUploadError;
      }
    }
    routines[index].imageList = imageList;
    return eitherFailureOrPostEndRoutine(
            apiToken: loginProvider.userDetails!.apiToken!, index: index)
        .then((success) {
      if (success) {
        return Response.success;
      } else {
        return Response.apiError;
      }
    });
  }
 Future<Response> duStatusResponse({
    required int index,
    required LoginProvider loginProvider,
    required ImageUploadProvider imageUploadProvider,
    required List<ImageDetails> imageList,
    required double? odometerReading,
    required double? totalizerDuLeft,
    required double? totalizerDuRight,
  }) async {
    if (totalizerDuLeft == null &&
        totalizerDuRight == null &&
        odometerReading == null &&
        imageList.isEmpty) return Response.nullData;
    routines[index].endTotalizerDuLeft = totalizerDuLeft;
    routines[index].endTotalizerDuRight = totalizerDuRight;
    routines[index].odometerReading = odometerReading;
    routines[index].endDateTime = DateTime.now();
    for (ImageDetails imageDetails in imageList) {
      int? imageId = await imageUploadProvider.eitherFailureOrUploadImage(
          imagePath: imageDetails.imagePath!,
          apiToken: loginProvider.userDetails!.apiToken!);
      if (imageId != null) {
        imageDetails.imageId = imageId;
      } else {
        return Response.imageUploadError;
      }
    }
    routines[index].imageList = imageList;
    return eitherFailureOrPostEndRoutine(
            apiToken: loginProvider.userDetails!.apiToken!, index: index)
        .then((success) {
      if (success) {
        return Response.success;
      } else {
        return Response.apiError;
      }
    });
  }

  Future<Result> createBill({
    required LoginProvider loginProvider,
    required ImageUploadProvider imageUploadProvider,
    required int index,
    required double? quantity,
    required ImageDetails? image,
  }) async {
    double currentQuantity = routines[index].endQuantity;
    if (image == null) return Result.image;
    if (quantity == null) return Result.quantityFormat;
    // if (currentQuantity + quantity > routines[index].quantity!) {
    //   return Result.quantityGreater;
    // }
    int? imageId = await imageUploadProvider.eitherFailureOrUploadImage(
        imagePath: image.imagePath!,
        apiToken: loginProvider.userDetails!.apiToken!);
    if (imageId != null) {
      image.imageId = imageId;
    } else {
      return Result.imageUpload;
    }
    Bill bill = Bill(
        id: routines[index].bills.length + 1, quantity: quantity, image: image);
    routines[index].bills.add(bill);
    routines[index].endQuantity = routines[index].endQuantity + quantity;
    debugPrint('BILL ADDED : $bill');
    notifyListeners();
    return Result.success;
  }

  Future<bool> eitherFailureOrGetRoutines({required String apiToken}) async {
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: Hive.box('routines_box_key')),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = false;
    final failureOrGetRoutines =
        await GetRoutines(repository: repository).call(apiToken: apiToken);
    failureOrGetRoutines?.fold((newFailure) {
      routines = [];
      failure = newFailure;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      if (data != null) {
        routines = data.routineList;
        planDetails = data.planDetails;
        // print('[api-test] planDetails: ${planDetails}');
        productDetails = data.productDetails;
        vehicleDetails = data.vehicleDetails;
        failure = null;
        calculateDashboardDetails();
        notifyListeners();
        isSuccess = true;
      }
    });
    return isSuccess;
  }

  Future<bool> eitherFailureOrPostStartRoutine(
      {required String apiToken, required Routine routine}) async {
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: DatabaseHelper().routinesBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = true;
    final result = await PostStartRoutine(repository: repository)
        .call(apiToken: apiToken, routine: routine);

    result?.fold((newFailure) {
      message = newFailure.errorMessage;
      debugPrint(message.toString());
      failure = newFailure;
      isSuccess = false;
      notifyListeners();
    }, (data) {
      failure = null;
      message = data;
      debugPrint(message.toString());
      isSuccess = true;
      notifyListeners();
    });
    return isSuccess;
  }

  Future<bool> eitherFailureOrPostEndRoutine(
      {required String apiToken, required int index}) async {
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: DatabaseHelper().routinesBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = true;
    final result = await PostEndRoutine(repository: repository)
        .call(apiToken: apiToken, routine: routines[index]);
    result?.fold((newFailure) {
      message = newFailure.errorMessage;
      debugPrint(message.toString());
      failure = newFailure;
      isSuccess = false;
      notifyListeners();
    }, (data) {
      failure = null;
      message = data;
      debugPrint(message.toString());
      isSuccess = true;
      notifyListeners();
    });
    return isSuccess;
  }

  Future<bool> eitherFailureOrPostRefillReport(
      {required String apiToken, required Routine routine}) async {
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: DatabaseHelper().routinesBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = true;
    isLoading = true;
    final result = await PostRefillReport(repository: repository)
        .call(apiToken: apiToken, routine: routine);
    result?.fold((newFailure) {
      message = newFailure.errorMessage;
      debugPrint(message.toString());
      failure = newFailure;
      isSuccess = false;
      notifyListeners();
    }, (data) {
      failure = null;
      message = data;
      debugPrint(message.toString());
      isSuccess = true;
      notifyListeners();
    });
    isLoading = false;
    return isSuccess;
  }

  Future<bool> eitherFailureOrPostDeliveryReport(
      {required String apiToken, required Routine routine}) async {
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: DatabaseHelper().routinesBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = true;
    final result = await PostDeliveryReport(repository: repository)
        .call(apiToken: apiToken, routine: routine);
    result?.fold((newFailure) {
      message = newFailure.errorMessage;
      debugPrint(newFailure.errorMessage);
      failure = newFailure;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      failure = null;
      message = data;
      debugPrint(message.toString());
      notifyListeners();
      isSuccess = true;
    });
    return isSuccess;
  }

  Future<bool> eitherFailureOrGetBill(
      {required String apiToken, required int index}) async {
        print('[api-test] eitherFailureOrGetBill called---');
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: Hive.box('routines_box_key')),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = false;
    final failureOrGetBill = await GetBill(repository: repository)
        .call(apiToken: apiToken, routine: routines[index]);
    failureOrGetBill?.fold((newFailure) {
      routines = [];
      failure = newFailure;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      if (data != null) {
        routines[index].additionalChargesList = data;
        failure = null;
        notifyListeners();
        isSuccess = true;
      }
    });
    return isSuccess;
  }


  Future<bool> eitherFailureOrPostTransferReport(
      {required String apiToken, required Routine routine}) async {
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: DatabaseHelper().routinesBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = true;
    final result = await PostTransferReport(repository: repository)
        .call(apiToken: apiToken, routine: routine);
    result?.fold((newFailure) {
      message = newFailure.errorMessage;
      debugPrint(newFailure.errorMessage);
      failure = newFailure;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      failure = null;
      message = data;
      debugPrint(message.toString());
      notifyListeners();
      isSuccess = true;
    });
    return isSuccess;
  }


  Future<bool> eitherFailureOrPostTransferFromReport(
      {required String apiToken, required Routine routine}) async {
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: DatabaseHelper().routinesBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = true;
    final result = await PostTransferFromReport(repository: repository)
        .call(apiToken: apiToken, routine: routine);
    result?.fold((newFailure) {
      message = newFailure.errorMessage;
      debugPrint(newFailure.errorMessage);
      failure = newFailure;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      failure = null;
      message = data;
      debugPrint(message.toString());
      notifyListeners();
      isSuccess = true;
    });
    return isSuccess;
  }


  Future<bool> updateReachedAt(
      {required String apiToken, required Routine routine}) async {
    RoutineRepositoryImpl repository = RoutineRepositoryImpl(
      remoteDataSource: RoutineRemoteDataSourceImpl(dio: Dio()),
      localDataSource:
          RoutineLocalDataSourceImpl(routinesBox: DatabaseHelper().routinesBox),
      networkInfo: NetworkInfoImpl(connectionChecker: DataConnectionChecker()),
    );
    bool isSuccess = true;
    final result = await UpdateReacheadAt(repository: repository)
        .call(apiToken: apiToken, routine: routine);
    result?.fold((newFailure) {
      message = newFailure.errorMessage;
      debugPrint(newFailure.errorMessage);
      failure = newFailure;
      notifyListeners();
      isSuccess = false;
    }, (data) {
      failure = null;
      message = data;
      debugPrint(message.toString());
      notifyListeners();
      isSuccess = true;
    });
    return isSuccess;
  }


}






