import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class XXX extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => Provider<Mango>.value(value: XYZ()),
      child: MaterialApp(
        home: Scaffold(body: Center(child: Builder(builder: (context){
          var myVal = Provider.of<Mango>(context);
          return Text(myVal.hello());
        },))),
      ),
    );
  }
}

abstract class Mango{
  String hello(){
  }
}

class XYZ implements Mango{
  @override
  String hello() {
    return 'dickbutt';
  }

}

void main() => runApp(XXX());