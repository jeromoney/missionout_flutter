import 'package:flutter/material.dart';
import 'package:missionout/app/response_sheet/response_sheet_view_model.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/app/my_appbar.dart';
import 'package:tuple/tuple.dart';

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

    return StreamBuilder<Tuple2<Response, List<Response>>>(
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
        if (responses.item1 == null && responses.item2.length == 0) {
          return Center(child: Text('No responses yet.'));
        }

        // success
        responses.item2.removeWhere((response) => response == null);
        return _BuildResponsesResult(
          responses: responses,
        );
      },
    );
  }
}

class _BuildResponsesResult extends StatelessWidget {
  final Response selfResponse;
  final List<Response> otherResponses;

  _BuildResponsesResult({Key key, @required responses})
      : this.selfResponse = responses.item1,
        this.otherResponses = responses.item2,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    List<DataRow> firstRow = [];
    if (selfResponse != null) {
      firstRow.add(DataRow(cells: <DataCell>[
        DataCell(Text(
          selfResponse.teamMember ?? '',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          selfResponse.status ?? '',
          style: TextStyle(fontWeight: FontWeight.bold),
        )),
      ]));
    }
    List<DataRow> otherRows = [];
    otherRows.addAll(otherResponses
        .map((response) => DataRow(cells: <DataCell>[
              DataCell(Text(
                response.teamMember ?? '',
              )),
              DataCell(Text(response.status ?? '')),
            ]))
        .toList());

    return SingleChildScrollView(
        child: DataTable(
      columns: [
        DataColumn(label: Text('Team Member')),
        DataColumn(label: Text('Status')),
      ],
      rows: firstRow + otherRows,
    ));
  }
}
