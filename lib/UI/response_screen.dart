import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class ResponseScreen extends StatelessWidget {
  final db = FirestoreService();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final extendedUser = Provider.of<ExtendedUser>(context);

    return Scaffold(
      appBar: MyAppBar( title: 'Responses'),
      body: _buildResults(extendedUser),
    );
  }

  Widget _buildResults(ExtendedUser extendedUser) {
    return StreamBuilder<List<Response>>(
      stream: db.fetchResponses(
          teamID: extendedUser.teamID, docID: extendedUser.missionID),
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
                  DataCell(Text(response.teamMember ?? '')),
                  DataCell(Text(response.status ?? '')),
                  DataCell(Text(response.drivingTime ?? ''))
                ]))
            .toList());
  }
}
