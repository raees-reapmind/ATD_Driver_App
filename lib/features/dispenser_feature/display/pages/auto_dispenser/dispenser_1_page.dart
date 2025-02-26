import '../../../../routine_feature/data/models/routine.dart';
import '../manual_dispenser/manual_dispenser_screen.dart';
import 'package:atd/utils/utils_export.dart';
import 'package:flutter/material.dart';

class Dispenser1Page extends StatelessWidget {
  final Routine routine;

  const Dispenser1Page({Key? key, required this.routine}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: [
                const Text("12.4",
                    style:
                        TextStyle(fontWeight: FontWeight.w900, fontSize: 30)),
                Text(" / ${routine.quantity} L",
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 16))
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "LIVE",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "RFID Status",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "Connected",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Connection",
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Text(
                  "LIVE",
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              ],
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                "Asset",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              trailing: DropdownButton<String>(
                alignment: AlignmentDirectional.centerEnd,
                value: "SELECT",
                elevation: 16,
                onChanged: (String? value) {
                  if (value != null) {}
                },
                items: ["SELECT", "Asset 1", "Asset 2", "Asset 3", "Other"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            ListTile(
              contentPadding: const EdgeInsets.all(0),
              title: Text(
                "Quantity",
                style: Theme.of(context).textTheme.subtitle1,
              ),
              trailing: const SizedBox(
                  width: 50,
                  child: TextField(
                    keyboardType: TextInputType.number,
                  )),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                    child: CustomButton(onTap: () {}, title: "Set Preset")),
                const SizedBox(width: 10),
                Expanded(
                    child:
                        CustomButton(onTap: () {}, title: "Start Dispenser")),
              ],
            ),
            const SizedBox(height: 10),
            CustomButton(
              onTap: () {},
              title: "Finish",
              backgroundColor: secondary500,
              textColor: Colors.white,
              splashColor: primary500,
            ),
            const SizedBox(height: 10),
            CustomButton(
                onTap: () => Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const ManualDispenserScreen(),
                    )),
                title: "Manual Mode")
          ],
        ),
      ),
    );
  }
}
