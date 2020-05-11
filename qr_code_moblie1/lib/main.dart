import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qr_code_scanner/qr_scanner_overlay_shape.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MaterialApp(home: MyApp()));
class MyApp extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => _MyAppState();

}

class _MyAppState extends State<MyApp>{
  GlobalKey globalKey = GlobalKey();
  var qrText = "";
  QRViewController controller;
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(body: Column(children: <Widget>[
      Expanded(
        flex: 5,
        child: QRView(key: globalKey,
            overlay: QrScannerOverlayShape(
              borderRadius: 10,
              borderColor: Colors.red,
              borderLength: 30,
              borderWidth: 10,
              cutOutSize: 300
            ),
            onQRViewCreated: _onQRViewCreate),
      ),
      Expanded(
        flex: 1,
        child: Center(child: Text("Scaner result :$qrText"),),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text('Read'),
          onPressed: () {
            _read();
          },
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: RaisedButton(
          child: Text('Save'),
          onPressed: () {
            _save();
          },
        ))

    ],)

      ,);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }


  void _onQRViewCreate(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData){
      setState(() {
        qrText = scanData;
      });
    });
  }
  _read() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = prefs.getString(key) ?? 0;
    print('read: $value');
  }

  _save() async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'my_int_key';
    final value = qrText;
    prefs.setString(key, value);
    print('saved $value');
  }

}


