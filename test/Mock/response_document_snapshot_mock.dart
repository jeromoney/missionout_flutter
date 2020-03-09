import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

import 'document_reference_mock.dart';

class ResponseDocumentSnapshotMock extends Mock implements DocumentSnapshot {
  get data => {
    'teamMember': 'Joe Smith',
    'status': 'on time',
    'drivingTime': '12 minutes',
  };

  DocumentReferenceMock get reference => DocumentReferenceMock();

}
