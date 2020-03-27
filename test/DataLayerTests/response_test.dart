
import 'package:missionout/DataLayer/response.dart';
import 'package:test/test.dart';

import '../Mock/document_reference_mock.dart';
import '../Mock/response_document_snapshot_mock.dart';

void main() {
  test('Create response test', () {
    final teamMember = 'Joe Smith';
    final status = 'his response';
    var response = Response(teamMember: teamMember, status: status);
    response.reference = DocumentReferenceMock();

    expect(response.teamMember, teamMember);
    expect(response.status, status);
  });

  test('Create response from Map', () {
    final response = Response.fromMap({
      'teamMember': 'Joe Smith',
      'status': 'on time',
      'drivingTime': null,
    });
    expect(response.teamMember, 'Joe Smith');
    expect(response.status, 'on time');

    final map = response.toJson();
    expect(map['teamMember'], 'Joe Smith');
    expect(map['status'], 'on time');
  });

  test('Create response from snapshot', (){
    final response = Response.fromSnapshot(ResponseDocumentSnapshotMock());
  });
}
