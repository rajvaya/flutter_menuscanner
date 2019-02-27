
import 'package:demo/videopage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:simple_permissions/simple_permissions.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        color: Colors.pinkAccent,
        debugShowCheckedModeBanner: false,
        home: new Screen()
    );

  }
}

class Screen extends StatefulWidget {
  @override
  _ScreenState createState() => _ScreenState();
}

class _ScreenState extends State<Screen> {
  String _reader='';
  Permission permission= Permission.Camera;
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Scanner APP"),backgroundColor: Colors.blueAccent,),
      body: new Column(
      children: <Widget>[
        new Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
        ),
        new Text('CLICK BELOW BUTTON FOR SCAN', softWrap: true,
          style: new TextStyle(fontSize: 30.0, color: Colors.blue),),
        new RaisedButton(
          splashColor: Colors.lightBlue,
          color: Colors.lightBlueAccent,
          child: new Text(
            "Scan", style: new TextStyle(fontSize: 20.0, color: Colors.white, ),),
          onPressed: scan,
        ),
        new Padding(padding: const EdgeInsets.symmetric(vertical: 10.0),),
        new Text('$_reader',textAlign: TextAlign.center, softWrap: true,
          style: new TextStyle(fontSize: 30.0, color: Colors.blue),),

      ],
    ),
    );
  }

  requestPermission() async {
    bool result = (await SimplePermissions.requestPermission(permission)) as bool;
    setState(()=> new SnackBar
      (backgroundColor: Colors.red,content: new Text(" $result"),),

    );
  }
  scan() async {
    try {
      String reader= await BarcodeScanner.scan();
      if (!mounted)
      return;
      else{
        var route = new MaterialPageRoute(
            builder:(BuildContext context) =>
            new VideoApp(url: _reader),);
            Navigator.of(context).push(route);
      }

      setState(() => this._reader=reader);
    } on PlatformException catch(e) {
      if(e.code==BarcodeScanner.CameraAccessDenied) {requestPermission();}
      else{setState(()=> _reader = "unknown exception $e");}
    }on FormatException{
      setState(() => _reader = '(User returned using the "back"-button before scanning anything. Result)');
    } catch (e) {
      setState(() => _reader = 'Unknown error: $e');
    }

  }

}




