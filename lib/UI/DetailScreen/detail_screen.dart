import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/DetailScreen/actions_detail_screen.dart';
import 'package:missionout/UI/DetailScreen/edit_detail_screen.dart';
import 'package:missionout/UI/DetailScreen/info_detail_screen.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class DetailScreen extends StatelessWidget {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    // Remove route if accessed from create screen
    final user = Provider.of<FirebaseUser>(context);
    return Scaffold(
        appBar: MyAppBar(title: 'Mission Detail',),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                InfoDetailScreen(),
                Padding(
                  padding: const EdgeInsets.only(top: 24.0),
                  child: Divider(
                    thickness: 1,
                  ),
                ),
                ActionsDetailScreen(),
                EditDetailScreen(),
              ],
            ),
          ),
        ));
  }
}
