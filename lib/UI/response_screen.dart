import 'package:flutter/material.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/responses_bloc.dart';
import 'package:missionout/DataLayer/response.dart';
import 'package:missionout/UI/my_appbar.dart';

class ResponseScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = ResponsesBloc();

    return BlocProvider<ResponsesBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: MyAppBar(
          title: Text('Responses'),
          context: context,
        ),
        body: _buildResults(bloc),
      ),
    );
  }

  Widget _buildResults(ResponsesBloc bloc) {
    return StreamBuilder<List<Response>>(
      stream: bloc.responsesStream,
      builder: (context, snapshot) {
        final responses = ResponsesBloc().getResponses();

        if (responses == null) {
          return Center(
            child: Text('There was an error.'),
          );
        }
        if (responses.length == 0) {
          return Center(
            child: Text('No results.'),
          );
        }
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
                  DataCell(Text(response.teamMember)),
                  DataCell(Text(response.status)),
                  DataCell(Text(response.drivingTime ?? ''))
                ]))
            .toList());
  }
}
