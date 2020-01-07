import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/responses_bloc.dart';
import 'package:missionout/BLoC/user_bloc.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/UI/my_appbar.dart';

class ResponseScreen extends StatelessWidget {
  ResponseScreen({Key key, @required String docID})
      : this._docID = docID,
        super(key: key);
  final String _docID;

  @override
  Widget build(BuildContext context) {
    final userBloc = BlocProvider.of<UserBloc>(context);
    final user = userBloc.user;

    final responsesBloc =
        ResponsesBloc(teamDocID: userBloc.domain, docID: _docID);

    return Scaffold(
      appBar: MyAppBar(
        title: Text('Responses'),
        photoURL: user.photoUrl,
        context: context,
      ),
      body: _buildResults(responsesBloc),
    );
  }

  Widget _buildResults(ResponsesBloc responsesBloc) {
    return StreamBuilder<List<Response>>(
      stream: responsesBloc.stream,
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
