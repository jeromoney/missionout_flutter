import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/responses_bloc.dart';
import 'package:missionout/DataLayer/response.dart';

class ResponseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = ResponsesBloc();

    return BlocProvider<ResponsesBloc>(
      bloc: bloc,
      child: Material(
        child: _buildResults(bloc),
      ),
    );
  }

  Widget _buildResults(ResponsesBloc bloc) {
    return StreamBuilder<QuerySnapshot>(
      stream: bloc.responsesStream,
      builder: (context, snapshot) {
        final responses = snapshot.data;
        if (responses == null) {
          return Center(
            child: Text('There was an error.'),
          );
        }
        if (false) {
          return Center(
            child: Text('No results.'),
          );
        }
        return Center();
        return _buildResponsesResults(null);
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
                  DataCell(Text(response.team_member)),
                  DataCell(Text(response.status)),
                  DataCell(Text(response.driving_time ?? '' ))
                ]))
            .toList());
  }
}
