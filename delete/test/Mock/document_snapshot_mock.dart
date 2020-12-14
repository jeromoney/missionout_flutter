import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

import 'document_reference_mock.dart';

class DocumentSnapshotMock extends Mock implements DocumentSnapshot {
  get data => {
        'description': 'some mission',
        'time': Timestamp.fromMicrosecondsSinceEpoch(0),
        'location': GeoPoint(3, 3),
        'needForAction': 'need people',
        'locationDescription': 'some location',
      };

  DocumentReferenceMock get reference => DocumentReferenceMock();

}
