import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_swipe_button/flutter_swipe_button.dart';
import 'package:slidable_button/slidable_button.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({Key? key}) : super(key: key);

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  String msg = "Logs\n";
  bool isFinished = false;
  String result = "";

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(msg),
              ElevatedButton(
                  onPressed: () {
                    final service = FlutterBackgroundService();
                    service.startService();
                  },
                  child: const Text("START")),
              ElevatedButton(
                  onPressed: () {
                    final service = FlutterBackgroundService();
                    service.invoke('stop', {});
                  },
                  child: const Text("STOP")),
              ElevatedButton(
                  onPressed: () {
                    final service = FlutterBackgroundService();
                    service.invoke('data', {
                      "dateTime": DateTime.now().toString(),
                    });
                  },
                  child: const Text("DATA")),
              SwipeButton(
                trackPadding: const EdgeInsets.all(0),
                elevationThumb: 2,
                thumb: const Icon(Icons.arrow_forward_ios),
                height: 70,
                child: const Text(
                  "Swipe to ...",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                onSwipe: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Swipped"),
                      backgroundColor: Colors.green,
                    ),
                  );
                },
              ),
              HorizontalSlidableButton(
                width: MediaQuery.of(context).size.width,
                buttonWidth: 70,
                height: 70,
                color: Colors.red,
                buttonColor: Theme.of(context).primaryColor,
                dismissible: false,
                isRestart: true,
                label: const Center(child: Icon(Icons.arrow_forward_ios)),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: Text('Login')),
                ),
                onChanged: (position) {
                  setState(() {
                    if (position == SlidableButtonPosition.end) {
                      position = SlidableButtonPosition.start;
                    } else {
                      result = 'Button is on the left';
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
