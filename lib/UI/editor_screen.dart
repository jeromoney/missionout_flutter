import 'package:flutter/material.dart';
import 'package:missionout/UI/my_appbar.dart';

class EditorScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
      MyAppBar(title: 'Team Options'),
      body: StreamBuilder<Object>(
        stream: null,
        builder: (context, snapshot) {
          return Center(child: Text('editor options go here'));
        }
      ),
    );
  }

}