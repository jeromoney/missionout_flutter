import 'package:flutter/material.dart';
import 'package:missionout/app/response_sheet/response_sheet_view_model.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/app/my_appbar.dart';

class ResponseScreen extends StatelessWidget {
  static const String routeName = "/responseScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: 'Responses'),
      body: BuildResponseStream(),
    );
  }
}

class BuildResponseStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ResponseSheetViewModel(context: context);

    return StreamBuilder<List<Response>>(
      stream: model.responses(),
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
        return _BuildResponsesResult(
          responses: responses,
        );
      },
    );
  }
}

class _BuildResponsesResult extends StatelessWidget {
  final List<Response> responses;

  _BuildResponsesResult({Key key, @required this.responses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: DataTable(
          columns: [
            DataColumn(label: Text('Team Member')),
            DataColumn(label: Text('Status')),
          ],
          rows: responses
              .map((response) => DataRow(cells: <DataCell>[
                    DataCell(Text(response.teamMember ?? '')),
                    DataCell(Text(response.status ?? '')),
                  ]))
              .toList()),
    );
  }
}
