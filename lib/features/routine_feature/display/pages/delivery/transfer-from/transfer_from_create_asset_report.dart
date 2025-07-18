import 'dart:async';
import 'dart:io';
import 'package:atd/core/services/image_picker_service.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/routine_feature/data/models/asset.dart';
import 'package:atd/features/routine_feature/data/models/routine.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/utils/widgets/image_full_screen_view.dart';
import 'package:atd/utils/widgets/provider_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../utils/utils_export.dart';

class TransferFromCreateAssetReportScreen extends StatefulWidget {
  final Routine routine;
  final int index;

  const TransferFromCreateAssetReportScreen(
      {Key? key, required this.routine, required this.index})
      : super(key: key);

  @override
  State<TransferFromCreateAssetReportScreen> createState() =>
      _TransferFromCreateAssetReportScreenState();
}

class _TransferFromCreateAssetReportScreenState extends State<TransferFromCreateAssetReportScreen> {
  final ImagePicker picker = ImagePicker();
  final quantityController = TextEditingController();
  final assetOdometerController = TextEditingController();
  XFile? image;
  List<ImageDetails> imageList = [];
  Asset? dropDownAsset;

  String dropDownFrom = "SELECT";
  var duStatus = "Status";
  bool isButtonsDisabled = true;
  int retryCount = 0;
  String mainUrl = "http://192.168.202.155:8001";
  final Dio dio = Dio();
  int totValue = 0;
  bool setPresetenabled = false;
  double? quantity = 0.0;
  double? startTotalizer = 0.0;
  double? endTotalizer = 0.0;
  double? finalQty = 0.0;
  int DuConnectCounter = 0;
  int totCount = 0;
  String formattedVlueQty = "";
  Timer? _timer;
  
  @override
  void initState() {
    if (widget.routine.assetList == null || widget.routine.assetList!.isEmpty) {
      widget.routine.assetList = [
        Asset(id: null, name: 'Select', type: 'NA', qrCode: 'NA', quantity: 0)
      ];
    }
    dropDownAsset = null; // No initial selection to make the field optional
    super.initState();
  }

  Future<void> fetchTran(int flag) async {
    final String finaltrans = '$mainUrl/api/v1/gvr-du-trac-data';
    debugPrint('finaltrans : $finaltrans');

    try {
      final response =
          await dio.get(finaltrans, queryParameters: {'flag': flag});
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {});
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }

  Future<void> checkTOT(int flag) async {
    debugPrint('[trip-test] create asset Check TOT clicked $flag');

    final String checkTOTURL;
    if (flag == 1) {
      checkTOTURL = '$mainUrl/api/v1/du-totalizer-readings';
    } else {
      checkTOTURL = '$mainUrl/api/v1/gvr-du-totalizer-readings';
    }
    debugPrint('Url is $checkTOTURL');
    try {
      String description = '';
      final response =
          await dio.get(checkTOTURL, queryParameters: {'flag': flag});
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final responseData = jsonResponse['response'];
        debugPrint('CheckTOT is $responseData');
        if (flag == 1) {
          description = responseData['description'];
        }
        final double totalizerReading = responseData['totalizerReading'];
        debugPrint('Totalizer Reading: $totalizerReading');
        if (totCount == 0) {
          setState(() {
            startTotalizer = totalizerReading;
          });
          totCount++;
          _timer = Timer.periodic(const Duration(seconds: 5), (timer) {});
          setPreset(flag, quantity);
        } else if (totCount != 0) {
          debugPrint('Totalizer End:$totCount');
          setState(() {
            endTotalizer = totalizerReading;
            finalQty = ((endTotalizer ?? 0.0) - (startTotalizer ?? 0.0));
            formattedVlueQty = (finalQty ?? 0.0).toStringAsFixed(2);
            quantityController.text = formattedVlueQty;
          debugPrint('[api-test] checkTOT quantity : ${quantityController.text}');

          });
          if (flag == 1) {
          stopDispensing(flag);

          }
        }
        setState(() {
          duStatus = description;
        });
        debugPrint('Processed Start Totalizer: $startTotalizer');
      }
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }

  Future<void> setPreset(int flag, double? quantity) async {
    debugPrint('Set preset called $flag');
    final String setPreset;
    if (flag == 1) {
      setPreset = '$mainUrl/api/v1/du-preset-data-volume';
    } else {
      setPreset = '$mainUrl/api/v1/gvr-du-set-preset-state';
    }
    final String gvrSetpresetData = '$mainUrl/api/v1/gvr-du-preset-data-volume';
    final String gvrauth = '$mainUrl/api/v1/gvr-du-auth';
    try {
      final response;
      // if (flag == 1) {
      //     response = await dio.post(
      //       setPreset,
      //       queryParameters: {'flag': flag},
      //       data: {'value': quantity},
      //       options: Options(
      //         headers: {
      //           'Content-Type': 'application/json',
      //         },
      //       ),
      //     );
      //   } else {
      //     response = await dio.post(
      //       setPreset,
      //       queryParameters: {'flag': flag},
      //     );
      //   }

      // if (response.statusCode == 202) {
      // final Map<String, dynamic> jsonResponse = response.data;
      // final responseData = jsonResponse['response'];
      // debugPrint('Set preset response: $responseData');
      // final String description = responseData['description'];
      // final String stateCode = responseData['stateCode'];
      if (flag == 2) {
        //   if (responseData != null) {
        //     startDispensing(flag);
        //   }
        //   setState(() {
        //     duStatus = description;
        //   });
        // } else {
        // if (stateCode == "D1") {
        await dio.post(
          gvrSetpresetData,
          queryParameters: {'flag': flag},
          data: {'value': quantity},
          options: Options(
            headers: {
              'Content-Type': 'application/json',
            },
          ),
        );
        //  await dio.post(
        //   gvrauth,
        //   queryParameters: {'flag': flag},
        // );
        // }
        // }
        // } else {
        // print('Failed to set preset. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }

  Future<void> startDispensing(int flag) async {
   // final String baseUrl1 = '$mainUrl/api/v1/du-start';
    final String checkTOTURL;
    if (flag == 1) {
      checkTOTURL = '$mainUrl/api/v1/du-start';
    } else {
      checkTOTURL = '$mainUrl/api/v1/du-start';
    }
    try {
      final response = await dio.post(
        checkTOTURL,
        queryParameters: {'flag': flag},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final responseData = jsonResponse['response'];
        final String description = responseData['description'];
        setState(() {
          duStatus = description;
        });
        debugPrint('Du Start response: $responseData');
      } else {
        debugPrint('Failed to set preset. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }

  Future<void> stopDispensing(int flag) async {
    final String baseUrl1 = '$mainUrl/api/v1/du-stop';
    try {
      final response = await dio.post(
        baseUrl1,
        queryParameters: {'flag': flag},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final responseData = jsonResponse['response'];
        final String description = responseData['description'];
        debugPrint('DU Stop response: $responseData');
        setState(() {
          duStatus = description;
        });
      } else {
        debugPrint('Failed to set preset. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }

  void _startDataPulling(int flag) {
    debugPrint('Start dispensing btn clicked $flag');
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchData(flag);
    });
  }

  Future<void> fetchData(int flag) async {
    debugPrint('fetch data started $flag');
    final String baseURL;
    if (flag == 1) {
      baseURL = '$mainUrl/api/v1/du-state';
    } else {
      baseURL = '$mainUrl/api/v1/gvr-du-state';
    }

    try {
      final response = await dio.get(baseURL, queryParameters: {'flag': flag});
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final responseData = jsonResponse['response'];
        final String description = responseData['description'];
        final String stateCode = responseData['stateCode'];
        debugPrint(
            'State code is $stateCode and DuConnectCounter $DuConnectCounter');
        if (flag == 1) {
          if (description == "No Dispensing in Control Mode" &&
              DuConnectCounter == 0) {
            debugPrint('it"s no dispensing in controle mode $flag');
            checkTOT(flag);
            DuConnectCounter++;
          } else if (description == "No Dispensing in Control Mode" &&
              DuConnectCounter != 0) {
            checkTOT(flag);
            DuConnectCounter = 0;
            _timer?.cancel();
          }
          setState(() {
            duStatus = description;
          });
        } else {
          if (stateCode == "61" && DuConnectCounter == 0) {
            debugPrint('OFF/IDL $flag');
            checkTOT(flag);
            DuConnectCounter++;
          } else if (stateCode == "A1" && DuConnectCounter != 0) {
            //  } else if (stateCode == "A1" ) {
            checkTOT(flag);
            fetchTran(flag);
            DuConnectCounter = 0;
            _timer?.cancel();
          }
          setState(() {
            duStatus = stateCode;
          });
        }
      } else {
        debugPrint('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      debugPrint('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);

    final loginProvider = Provider.of<LoginProvider>(context);
    final imageUploadProvider = Provider.of<ImageUploadProvider>(context);

    setState(() {
      quantity = routineProvider.routines[widget.index].quantity;
    });
    return Scaffold(
      body: Stack(
        children: [
          const CustomBackground(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Card(
                    color: white500,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Text("Transfer Details",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          const SizedBox(height: 20),
                         
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Actual Quantity",
                                  style: Theme.of(context).textTheme.titleMedium,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: 
                               
                                TextField(
                                      controller: quantityController,
                                      onChanged: (value) {
                                        if (dropDownAsset == null) {
                                          debugPrint("[test] Creating a new asset instance");
                                          dropDownAsset = Asset(
                                            id: null,
                                            name: "", // Default name
                                            type: "NA",
                                            qrCode: "NA",
                                            quantity: double.tryParse(value),
                                          );
                                        } else {
                                          dropDownAsset = dropDownAsset!.copyWith(
                                            quantity: double.tryParse(value),
                                          );
                                        }
                                        debugPrint('[from-test] dropDownAsset.quantity: ${dropDownAsset?.quantity}');
                                      },
                                      keyboardType: TextInputType.number,
                                      decoration: const InputDecoration(
                                        counterText: "",
                                        filled: true,
                                        fillColor: white300,
                                        hintText: "Quantity",
                                        focusedBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          borderSide: BorderSide(
                                            color: Colors.black12, style: BorderStyle.solid, width: 2),
                                        ),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.all(Radius.circular(20)),
                                          borderSide: BorderSide(style: BorderStyle.none, width: 0),
                                        ),
                                      ),
                                    )


                              ),
                            ],
                          ),
                         
                          const SizedBox(height: 10),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              "Upload image",
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            subtitle: const Text(
                                "Kindly upload the images of DU receipt"),
                            trailing: IconButton(
                                onPressed: () async {

                                  ImagePickerService.pickImage().then((image) {
                                    if (image != null) {
                                      setState(() {
                                        imageList.add(ImageDetails(
                                            image: image,
                                            imagePath: image.path));
                                      });
                                    }
                                  });
                                },
                                icon: const Icon(Icons.camera_alt)),
                          ),
                          const SizedBox(height: 5),
                          SizedBox(
                            height: 50,
                            width: double.maxFinite,
                            child: ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.horizontal,
                                itemCount: imageList.length,
                                itemBuilder: (context, index) => InkWell(
                                      onTap: () => Navigator.of(context)
                                          .push(MaterialPageRoute(
                                        builder: (context) => ImageView(
                                          imagePath:
                                              imageList[index].imagePath!,
                                          hero: 'asset',
                                          index: index,
                                        ),
                                      )),
                                      child: Padding(
                                        padding: const EdgeInsets.all(1),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          child: Hero(
                                            tag: 'asset $index',
                                            child: Image.file(
                                              File(imageList[index].imagePath!),
                                              width: 50,
                                              height: 50,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                          ),
                          const SizedBox(height: 10),
                          CustomButton(
                            onTap: () => saveClickEvent(
                              context: context,
                              asset: dropDownAsset, // Nullable asset
                              image: image,
                              // quantity: double.tryParse(formattedVlueQty),
                              quantity: double.tryParse(quantityController.text.trim()),
                              imageUploadProvider: imageUploadProvider,
                              routineProvider: routineProvider,
                              loginProvider: loginProvider,
                              index: widget.index,
                              selctedDu: dropDownFrom
                            ),
                            title: "Save",
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void saveClickEvent({
    required Asset? asset, // Make asset nullable
    required double? quantity,
    required XFile? image,
    required BuildContext context,
    required ImageUploadProvider imageUploadProvider,
    required RoutinesProvider routineProvider,
    required LoginProvider loginProvider,
    required int index,
    String? selctedDu
  }) async {
    debugPrint('[api-test] saveClickEvent asset $asset');
    asset = asset?.copyWith(name: selctedDu, quantity: quantity);

    // asset?.quantity = quantity;
    // asset?.name = selctedDu!;
    debugPrint('[api-test] saveClickEvent asset!.quantity ${asset?.quantity}');
    debugPrint('[api-test] saveClickEvent asset!.name ${asset?.name}');

     await routineProvider.createAssetDelivery(
      loginProvider: loginProvider,
      asset: asset, // Pass nullable asset
      imageUploadProvider: imageUploadProvider,
      imageList: imageList,
      index: index,
      quantity: quantity,
      selectedDu: selctedDu
    )
        .then((result) {
      switch (result) {
        case Result.quantityFormat:
          showSnackBar(
              context: context,
              message: "Please enter a valid quantity format");
          break;
        // case Result.quantityGreater:
        //   showSnackBar(
        //       context: context,
        //       message: "Quantity is greater than the order quantity");
        //   break;
        case Result.image:
          showSnackBar(
              context: context,
              message: "Please upload the image of the totalizer or receipt");
          break;
        case Result.imageUpload:
          showSnackBar(context: context, message: "Failed to upload image");
          break;
        case Result.success:
          showSnackBar(context: context, message: "Asset Report Added");
          Navigator.of(context).pop();
          break;
      }
    });
  }
}

class AssetImageView extends StatelessWidget {
  final String imagePath;

  const AssetImageView({Key? key, required this.imagePath}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: "asset_image",
      child: Image.file(
        File(imagePath),
        width: 50,
        height: 50,
        fit: BoxFit.cover,
      ),
    );
  }
}
