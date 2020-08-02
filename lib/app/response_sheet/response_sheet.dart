import 'package:flutter/material.dart';
import 'package:missionout/app/response_sheet/response_sheet_view_model.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:tuple/tuple.dart';

class ResponseSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ResponseSheetViewModel(context);
    return Dialog(
      child: SingleChildScrollView(
        child: StreamBuilder<Tuple2<Response, List<Response>>>(
          stream: model.responses(),
          builder: (context, snapshot) {
            // waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return LinearProgressIndicator();
            }

            // error
            if (snapshot.data == null) {
              return Center(
                child: Text('There was an error.'),
                widthFactor: 2.0,
                heightFactor: 5.0,
              );
            }

            final responses = snapshot.data;

            // no results
            if (responses.item1 == null && responses.item2.length == 0) {
              return Center(
                child: Text('No responses yet.'),
                widthFactor: 2.0,
                heightFactor: 5.0,
              );
            }

            // success
            responses.item2.removeWhere((response) => response == null);
            return _BuildResponsesResult(
              responses: responses,
            );
          },
        ),
      ),
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
