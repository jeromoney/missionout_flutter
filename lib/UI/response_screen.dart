import 'package:flutter/material.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/Provider/team.dart';
import 'package:missionout/Provider/user.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';

class ResponseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Responses'),
      body: BuildResponseStream(),
    );
  }
}

@visibleForTesting
class BuildResponseStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final team = Provider.of<Team>(context);

    return StreamBuilder<List<Response>>(
      stream: team.fetchResponses(
        docID: user.currentMission,
      ),
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
        return BuildResponsesResult(
          responses: responses,
        );
      },
    );
  }
}

@visibleForTesting
class BuildResponsesResult extends StatelessWidget {
  final List<Response> responses;

  const BuildResponsesResult({Key key, @required this.responses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DataTable(
        columns: [
          DataColumn(label: Text('Team Member')),
          DataColumn(label: Text('Status')),
        ],
        rows: responses
            .map((response) => DataRow(cells: <DataCell>[
                  DataCell(Text(response.teamMember ?? '')),
                  DataCell(Text(response.status ?? '')),
                ]))
            .toList());
  }
}
