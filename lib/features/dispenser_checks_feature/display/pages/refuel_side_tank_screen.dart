import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';

class RefuelSideTankScreen extends StatefulWidget {
  const RefuelSideTankScreen({Key? key}) : super(key: key);

  @override
  State<RefuelSideTankScreen> createState() => _RefuelSideTankScreenState();
}

class _RefuelSideTankScreenState extends State<RefuelSideTankScreen> {
  final TextEditingController duLeftQuantityController =
      TextEditingController();
  final TextEditingController duRightQuantityController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Refuel Side Tank"),
      ),
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
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const SizedBox(height: 10),
                          Center(
                            child: Text("Refuel Side Tank",
                                style: Theme.of(context).textTheme.titleLarge),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text("Vehicle Reg No"),
                              Text(
                                "MH02GG1234",
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          const Text("DU Left"),
                          CustomTextField(
                            controller: duLeftQuantityController,
                            hintText: "Enter Quantity",
                          ),
                          const SizedBox(height: 10),
                          const Text("DU Right"),
                          CustomTextField(
                            controller: duRightQuantityController,
                            hintText: "Enter Quantity",
                          ),
                          const SizedBox(height: 10),
                          Row(
                            children: [
                              Expanded(
                                flex: 3,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text("Upload image"),
                                    Text("Kindly upload the images of receipt",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall),
                                  ],
                                ),
                              ),
                              Expanded(
                                  child: IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.camera_alt))),
                            ],
                          ),
                          const SizedBox(height: 20),
                          CustomButton(onTap: () {}, title: "Confirm"),
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
}
