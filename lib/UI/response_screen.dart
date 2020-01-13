

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/firestore_path.dart';
import 'package:missionout/Provider/FirestoreService.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class ResponseScreen extends StatelessWidget {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final firestorePath = Provider.of<FirestorePath>(context);

    return Scaffold(
      appBar: MyAppBar(
        title: Text('Responses'),
        photoURL: user.photoUrl,
        context: context,
      ),
      body: _buildResults(firestorePath),
    );
  }

  Widget _buildResults(FirestorePath firestorePath) {
    return StreamBuilder<List<Response>>(
      stream: db.fetchResponses(
          teamID: firestorePath.teamID,
          docID: firestorePath.missionID),
      builder: (context, snapshot) {
        // waiting
        if (snapshot.connectionState == ConnectionState.waiting) {
          return LinearProgressIndicator();
        }

        // error
        if (snapshot.data == null) {
          return Text('There was an error.');
        }

        final responses = snapshot.data;

        // no results
        if (responses.length == 0) {
          return Center(child: Text('No responses yet.'));
        }

        // success
        responses.removeWhere((response) => response == null);
        return _buildResponsesResults(responses);
      },
    );
  }

  Widget _buildResponsesResults(List<Response> responses) {
    return DataTable(
        columns: [
          DataColumn(label: Text('Team Member')),
          DataColumn(label: Text('Status')),
          DataColumn(label: Text('Driving Time')),
        ],
        rows: responses
            .map((response) => DataRow(cells: <DataCell>[
                  DataCell(Text(response.teamMember??'')),
                  DataCell(Text(response.status??'')),
                  DataCell(Text(response.drivingTime ?? ''))
                ]))
            .toList());
  }
}
