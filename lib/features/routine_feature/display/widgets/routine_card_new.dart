import 'package:flutter/material.dart';
import '../../../../utils/palette.dart';
import '../../../../utils/widgets/custom_button.dart';
import '../../data/models/routine.dart';

enum RoutineType { order, refuel, endTrip }

class RoutineCard extends StatelessWidget {
  final Routine routine;
  final VoidCallback onTapArrived;
  final VoidCallback onTapCancel;
  final VoidCallback onTapNavigate;
  final bool? isRoutineEnd;

  const RoutineCard(
      {Key? key,
      required this.routine,
      required this.onTapArrived,
      required this.onTapCancel,
      this.isRoutineEnd,
      required this.onTapNavigate})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (routine.type) {
      case 'delivery':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: routine.statusCode == 1
                ? Colors.white
                : routine.statusCode == 2
                    ? primary500
                    : const Color(0xff7ACC95),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Order"),
                      Text(
                        "${routine.quantity} L",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          routine.address,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: routine.statusCode == 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  title: "Arrived",
                                  onTap: () => onTapArrived(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: secondary500,
                                  splashColor: primary500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CustomButton(
                                  title: "Cancel",
                                  onTap: () => onTapCancel(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: red500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipOval(
                                child: Material(
                                  color: primary500,
                                  child: InkWell(
                                    onTap: () => onTapNavigate(),
                                    splashColor: secondary500,
                                    child: Ink(
                                      height: 50,
                                      width: 50,
                                      child: const Icon(
                                        Icons.directions,
                                        color: secondary500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      case 'refill':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: routine.statusCode == 1
                ? Colors.white
                : routine.statusCode == 2
                    ? primary500
                    : const Color(0xff7ACC95),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Refuel"),
                      Text(
                        "${routine.quantity} L",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          routine.address,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: routine.statusCode == 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  title: "Arrived",
                                  onTap: () => onTapArrived(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: secondary500,
                                  splashColor: primary500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CustomButton(
                                  title: "Cancel",
                                  onTap: () => onTapCancel(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: red500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipOval(
                                child: Material(
                                  color: primary500,
                                  child: InkWell(
                                    onTap: () => onTapNavigate(),
                                    splashColor: secondary500,
                                    child: Ink(
                                      height: 50,
                                      width: 50,
                                      child: const Icon(
                                        Icons.directions,
                                        color: secondary500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      case 'end':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: routine.statusCode == 1
                ? Colors.white
                : routine.statusCode == 2
                    ? primary500
                    : const Color(0xff7ACC95),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const Padding(
                  padding:  EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children:  [
                      Text("End Trip"),
                      Text(
                        "Great Work !",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          routine.address,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible:
                          //  routine.statusCode == 2 
                          //  && 
                           isRoutineEnd == false,
                          child:
                           Row(
                            children: [
                              // Expanded(
                              //   child: CustomButton(
                              //     title: "Arrived",
                              //     onTap: () => onTapArrived(),
                              //     isSmall: true,
                              //     textColor: Colors.white,
                              //     backgroundColor: secondary500,
                              //     splashColor: primary500,
                              //   ),
                              // ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CustomButton(
                                  title: "End",
                                  onTap: () =>  onTapArrived(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: red500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              // ClipOval(
                              //   child: Material(
                              //     color: primary500,
                              //     child: InkWell(
                              //       onTap: () => onTapNavigate(),
                              //       splashColor: secondary500,
                              //       child: Ink(
                              //         height: 50,
                              //         width: 50,
                              //         child: const Icon(
                              //           Icons.directions,
                              //           color: secondary500,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );


      case 'start':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: routine.statusCode == 1
                ? Colors.white
                : routine.statusCode == 2
                    ? primary500
                    : const Color(0xff7ACC95),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Start Trip"),
                      Text(
                        "Drive Safe",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          routine.address,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: routine.statusCode == 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  // title: "Arrived",
                                  title: "Start trip",
                                  onTap: () => onTapArrived(),
                                  // onTap: () => onTapStart!(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: secondary500,
                                  splashColor: primary500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CustomButton(
                                  title: "Cancel",
                                  onTap: () => onTapCancel(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: red500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipOval(
                                child: Material(
                                  color: primary500,
                                  child: InkWell(
                                    onTap: () => onTapNavigate(),
                                    splashColor: secondary500,
                                    child: Ink(
                                      height: 50,
                                      width: 50,
                                      child: const Icon(
                                        Icons.directions,
                                        color: secondary500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );

      case 'internal_transfer_to':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: routine.statusCode == 1
                ? Colors.white
                : routine.statusCode == 2
                    ? primary500
                    : const Color(0xff7ACC95),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Transfer - to"),
                      Text(
                        "${routine.quantity} L",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          routine.address,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: routine.statusCode == 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  title: "Arrived",
                                  onTap: () => onTapArrived(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: secondary500,
                                  splashColor: primary500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CustomButton(
                                  title: "Cancel",
                                  onTap: () => onTapCancel(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: red500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipOval(
                                child: Material(
                                  color: primary500,
                                  child: InkWell(
                                    onTap: () => onTapNavigate(),
                                    splashColor: secondary500,
                                    child: Ink(
                                      height: 50,
                                      width: 50,
                                      child: const Icon(
                                        Icons.directions,
                                        color: secondary500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );

        case 'internal_transfer_from':
        return Container(
          margin: const EdgeInsets.only(bottom: 8),
          width: double.maxFinite,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: routine.statusCode == 1
                ? Colors.white
                : routine.statusCode == 2
                    ? primary500
                    : const Color(0xff7ACC95),
          ),
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Transfer - from"),
                      Text(
                        "${routine.quantity} L",
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  width: double.maxFinite,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 8, right: 8, top: 5, bottom: 5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          routine.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          routine.address,
                          style: Theme.of(context).textTheme.subtitle2,
                        ),
                        const SizedBox(height: 10),
                        Visibility(
                          visible: routine.statusCode == 2,
                          child: Row(
                            children: [
                              Expanded(
                                child: CustomButton(
                                  title: "Arrived",
                                  onTap: () => onTapArrived(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: secondary500,
                                  splashColor: primary500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: CustomButton(
                                  title: "Cancel",
                                  onTap: () => onTapCancel(),
                                  isSmall: true,
                                  textColor: Colors.white,
                                  backgroundColor: red500,
                                ),
                              ),
                              const SizedBox(width: 5),
                              ClipOval(
                                child: Material(
                                  color: primary500,
                                  child: InkWell(
                                    onTap: () => onTapNavigate(),
                                    splashColor: secondary500,
                                    child: Ink(
                                      height: 50,
                                      width: 50,
                                      child: const Icon(
                                        Icons.directions,
                                        color: secondary500,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
      default:
        return const Text('routine type error');
    }
  }
}
