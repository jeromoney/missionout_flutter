import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/Provider/database.dart';
import 'package:missionout/Provider/firestore_database.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class ResponseScreen extends StatelessWidget {
  Database _database;

  @override
  Widget build(BuildContext context) {
    final extendedUser = Provider.of<ExtendedUser>(context);
    _database = Provider.of<Database>(context);

    return Scaffold(
      appBar: MyAppBar( title: 'Responses'),
      body: _buildResults(extendedUser),
    );
  }

  Widget _buildResults(ExtendedUser extendedUser) {
    return StreamBuilder<List<Response>>(
      stream: _database.fetchResponses(
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
