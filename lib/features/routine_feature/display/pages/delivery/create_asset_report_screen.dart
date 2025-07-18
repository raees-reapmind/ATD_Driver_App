import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:atd/core/services/image_picker_service.dart';
import 'package:atd/features/image_upload_feature/display/providers/image_upload_provider.dart';
import 'package:atd/features/vehicle_readings_feature/data/models/image_details.dart';
import 'package:atd/utils/widgets/provider_export.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../../../../../utils/utils_export.dart';
import '../../../../../utils/widgets/image_full_screen_view.dart';
import '../../../data/models/asset.dart';
import '../../../data/models/routine.dart';

class CreateAssetReportScreen extends StatefulWidget {
  final Routine routine;
  final int index;

  const CreateAssetReportScreen(
      {Key? key, required this.routine, required this.index})
      : super(key: key);

  @override
  State<CreateAssetReportScreen> createState() =>
      _CreateAssetReportScreenState();
}

class _CreateAssetReportScreenState extends State<CreateAssetReportScreen> {
  final ImagePicker picker = ImagePicker();
  final quantityController = TextEditingController();
  final assetOdometerController = TextEditingController();
  XFile? image;
  List<ImageDetails> imageList = [];
  Asset? dropDownAsset;
  String dropDownFrom = "SELECT";
  List<String> dropdownOptions = ['SELECT', 'du left', 'du right']; // Define the options

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
  bool _isSaving = false; // Add this flag
  @override
  void initState() {
    if (widget.routine.assetList == null || widget.routine.assetList!.isEmpty) {
      widget.routine.assetList = [
        Asset(id: null, name: 'Select', type: 'NA', qrCode: 'NA', quantity: 0),
      ];
    }
    dropDownAsset = null; // No initial selection to make the field optional
    super.initState();
  }

  Future<void> fetchTran(int flag) async {
    final String finaltrans = '$mainUrl/api/v1/gvr-du-trac-data';
    print('finaltrans : $finaltrans');

    try {
      final response =
          await dio.get(finaltrans, queryParameters: {'flag': flag});
      _timer = Timer.periodic(const Duration(seconds: 5), (timer) {});
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  Future<void> checkTOT(int flag) async {
    print('[trip-test] create asset Check TOT clicked $flag');

    final String checkTOTURL;
    if (flag == 1) {
      checkTOTURL = '$mainUrl/api/v1/du-totalizer-readings';
    } else {
      checkTOTURL = '$mainUrl/api/v1/gvr-du-totalizer-readings';
    }
    print('Url is $checkTOTURL');
    try {
      String description = '';
      final response =
          await dio.get(checkTOTURL, queryParameters: {'flag': flag});
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = response.data;
        final responseData = jsonResponse['response'];
        print('CheckTOT is $responseData');
        if (flag == 1) {
          description = responseData['description'];
        }
        final double totalizerReading = responseData['totalizerReading'];
        print('Totalizer Reading: $totalizerReading');
        if (totCount == 0) {
          setState(() {
            startTotalizer = totalizerReading;
          });
          totCount++;
          _timer = Timer.periodic(const Duration(seconds: 5), (timer) {});
          setPreset(flag, quantity);
        } else if (totCount != 0) {
          print('Totalizer End:$totCount');
          setState(() {
            endTotalizer = totalizerReading;
            finalQty = ((endTotalizer ?? 0.0) - (startTotalizer ?? 0.0));
            formattedVlueQty = (finalQty ?? 0.0).toStringAsFixed(2);
            quantityController.text = formattedVlueQty;
            print('[api-test] checkTOT quantity : ${quantityController.text}');
          });
          if (flag == 1) {
            stopDispensing(flag);
          }
        }
        setState(() {
          duStatus = description;
        });
        print('Processed Start Totalizer: $startTotalizer');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  Future<void> setPreset(int flag, double? quantity) async {
    print('Set preset called $flag');
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
      // print('Set preset response: $responseData');
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
      print('An error occurred: $error');
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
        print('Du Start response: $responseData');
      } else {
        print('Failed to set preset. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
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
        print('DU Stop response: $responseData');
        setState(() {
          duStatus = description;
        });
      } else {
        print('Failed to set preset. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  void _startDataPulling(int flag) {
    print('Start dispensing btn clicked $flag');
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      fetchData(flag);
    });
  }

  Future<void> fetchData(int flag) async {
    print('fetch data started $flag');
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
        print(
            'State code is $stateCode and DuConnectCounter $DuConnectCounter');
        if (flag == 1) {
          if (description == "No Dispensing in Control Mode" &&
              DuConnectCounter == 0) {
            print('it"s no dispensing in controle mode $flag');
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
            print('OFF/IDL $flag');
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
        print('Failed to fetch data. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('An error occurred: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final routineProvider = Provider.of<RoutinesProvider>(context);

    final loginProvider = Provider.of<LoginProvider>(context);
    final imageUploadProvider = Provider.of<ImageUploadProvider>(context);
    final dispenserChecksProvider =
        Provider.of<DispenserChecksProvider>(context);

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
                            child: Text("Asset Report",
                                style: Theme.of(context).textTheme.titleMedium),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            "Select Asset",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          DropdownButton<Asset>(
                            isExpanded: true,
                            value: dropDownAsset,
                            hint: const Text("SELECT"),
                            items: widget.routine.assetList
                                ?.map<DropdownMenuItem<Asset>>((Asset value) {
                              return DropdownMenuItem<Asset>(
                                value: value,
                                child: Text(value.name),
                              );
                            }).toList(),
                            onChanged: (Asset? asset) {
                              debugPrint(
                                  'SELECTED ASSET : ${asset.toString()}');
                              setState(() {
                                dropDownAsset = asset;
                              });
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(2),
                            child: Center(
                              child: Text(
                                'OR',
                                style: Theme.of(context).textTheme.subtitle2,
                              ),
                            ),
                          ),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              "Scan QR",
                              style: Theme.of(context).textTheme.subtitle1,
                            ),
                            trailing: IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.qr_code_2_rounded)),
                          ),
                          const Divider(),
                          const SizedBox(height: 10),
                          const SizedBox(height: 20),
                          Text(
                            "Select DU",
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          DropdownButton<String>(
                            alignment: AlignmentDirectional.centerEnd,
                            value: dropDownFrom,
                            elevation: 16,
                            isExpanded: true,
                            onChanged: (String? value) {
                              if (value != null) {
                                setState(() {
                                  dropDownFrom = value;
                                  // dropDownAsset?.subjectType = value;
                                });
                              }
                            },
                            // items: ['SELECT', 'Left', 'Right']
                            //     .map<DropdownMenuItem<String>>((String value) {
                            //   return DropdownMenuItem<String>(
                            //     value: value,
                            //     child: Text(value),
                            //   );
                            items: dropdownOptions
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                          // const SizedBox(height: 10),
                          // CustomButton(
                          //   onTap: () {
                          //     print('Dropdown value is $dropDownFrom');
                          //     if (dropDownFrom == 'Left') {
                          //       _startDataPulling(1);
                          //     } else if (dropDownFrom == 'Right') {
                          //       _startDataPulling(2);
                          //     }
                          //     setState(() {
                          //       isButtonsDisabled = false;
                          //       print('Start Dispensing 1: $isButtonsDisabled');
                          //     });
                          //   },
                          //   title: "Start Dispensing",
                          // ),
                          const SizedBox(
                            height: 10,
                          ),
                          // TextField(
                          //   decoration: InputDecoration(
                          //       labelText: duStatus,
                          //       border: OutlineInputBorder()),
                          // ),
                          // const SizedBox(
                          //   height: 10,
                          // ),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Text(
                                  "Quantity",
                                  style: Theme.of(context).textTheme.subtitle1,
                                ),
                              ),
                              Expanded(
                                flex: 3,
                                child: CustomTextField(
                                  controller: quantityController,
                                  hintText: 'Quantity',
                                  isNumber: true,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          dropDownAsset != null &&
                                  dropDownAsset!.type == 'vehicle'
                              ? CustomTextField(
                                  controller: assetOdometerController,
                                  hintText: 'Enter Asset Odometer',
                                  isNumber: true,
                                )
                              : const SizedBox.shrink(),
                          const SizedBox(height: 10),
                          ListTile(
                            contentPadding: const EdgeInsets.all(0),
                            title: Text(
                              "Upload image",
                              style: Theme.of(context).textTheme.subtitle1,
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
                                            tag: 'asset$index',
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
                            onTap: _isSaving
                                ? () {} // No-op function instead of null
                                : () => saveClickEvent(
                                    context: context,
                                    asset: dropDownAsset,
                                    image: image,
                                    quantity: double.tryParse(
                                        quantityController.text.trim()),
                                    imageUploadProvider: imageUploadProvider,
                                    routineProvider: routineProvider,
                                    loginProvider: loginProvider,
                                    index: widget.index,
                                    selctedDu: dropDownFrom),
                            title: _isSaving ? "Saving..." : "Save",
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

  void saveClickEvent(
      {required Asset? asset, // Make asset nullable
      required double? quantity,
      required XFile? image,
      required BuildContext context,
      required ImageUploadProvider imageUploadProvider,
      required RoutinesProvider routineProvider,
      required LoginProvider loginProvider,
      required int index,
      String? selctedDu}) async {
    if (_isSaving) return; // Prevent multiple taps
    setState(() {
      _isSaving = true;
    });

    asset?.quantity = quantity;
    asset?.subjectType = selctedDu!;
    debugPrint('[api-test] saveClickEvent asset!.quantity ${asset?.quantity}');
    debugPrint('[api-test] saveClickEvent asset!.name ${asset?.name}');
    await routineProvider
        .createAssetDelivery(
            loginProvider: loginProvider,
            asset: asset,
            imageUploadProvider: imageUploadProvider,
            imageList: imageList,
            index: index,
            quantity: quantity,
            selectedDu: selctedDu)
        .then((result) {
      setState(() {
        _isSaving = false;
      });
      switch (result) {
        case Result.quantityFormat:
          showSnackBar(
              context: context,
              message: "Please enter a valid quantity format");
          break;
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
