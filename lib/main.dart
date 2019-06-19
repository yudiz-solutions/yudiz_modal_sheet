import 'package:flutter/material.dart';
import 'package:yudiz_modal_sheet/yudiz_modal_sheet.dart';

void main() => runApp(ExampleApp());

class ExampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: YudizModalSheetDemo(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class YudizModalSheetDemo extends StatefulWidget {
  @override
  _YudizModalSheetDemoState createState() => _YudizModalSheetDemoState();
}

class _YudizModalSheetDemoState extends State<YudizModalSheetDemo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: RaisedButton(
            child: Text("Click Me"),
            onPressed: () {
              YudizModalSheet.show(
                  context: context,
                  child: Container(
                    color: Colors.white,
                    height: 250,
                    child: Center(
                      child: Text("Hello from top"),
                    ),
                  ),
                  direction: YudizModalSheetDirection.TOP);
            },
          ),
        ),
      ),
    );
  }
}
