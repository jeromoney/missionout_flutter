import 'package:flutter/material.dart';
import 'package:missionout/app/response_sheet/response_sheet_view_model.dart';
import 'package:missionout/data_objects/response.dart';

class ResponseSheet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final model = ResponseSheetViewModel(context);
    return Card(
      child: SingleChildScrollView(
        child: StreamBuilder<List<Response>>(
          stream: model.teamResponses(),
          builder: (context, snapshot) {
            // waiting
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const LinearProgressIndicator();
            }
            // error
            if (snapshot.data == null) {
              return const Center(
                widthFactor: 2.0,
                heightFactor: 5.0,
                child: Text('There was an error.'),
              );
            }

            final responses = snapshot.data;
            // no results
            if (responses.isEmpty) {
              return const Center(
                widthFactor: 2.0,
                heightFactor: 5.0,
                child: Text('No responses yet.'),
              );
            }

            // success
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
  final List<Response> responses;

  const _BuildResponsesResult({Key key, @required this.responses})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = ResponseSheetViewModel(context);
    List<DataRow> firstRow = [];
    if (model.userIsInResponseList(responses)) {
      final selfResponse = responses[0];
      responses.removeAt(0);
      firstRow.add(DataRow(cells: <DataCell>[
        DataCell(Text(
          selfResponse.teamMember ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
        DataCell(Text(
          selfResponse.status ?? '',
          style: const TextStyle(fontWeight: FontWeight.bold),
        )),
      ]));
    }
    List<DataRow> otherRows = [];
    otherRows.addAll(responses
        .map((response) => DataRow(cells: <DataCell>[
              DataCell(Text(
                response.teamMember ?? '',
              )),
              DataCell(Text(response.status ?? '')),
            ]))
        .toList());

    return SingleChildScrollView(
        child: DataTable(
      columns: const [
        DataColumn(label: Text('Team Member')),
        DataColumn(label: Text('Status')),
      ],
      rows: firstRow + otherRows,
    ));
  }
}
