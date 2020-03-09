import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:test/test.dart';

import '../Mock/document_reference_mock.dart';
import '../Mock/document_snapshot_mock.dart';

void main() {
  test('Create mission from Map ', () {
    final myDescription = 'some mission';
    final myTime = Timestamp.fromMicrosecondsSinceEpoch(0);
    final myLocation = GeoPoint(3, 3);
    final myNeedForAction = 'need people';
    final myLocationDescription = 'some place';

    var testMap = {
      'description': myDescription,
      'time': myTime,
      'location': myLocation,
      'needForAction': myNeedForAction,
      'locationDescription': myLocationDescription,
    };
    var testMission = Mission.fromMap(testMap);
    expect(testMission.description, myDescription);
    expect(testMission.isStoodDown, false);

    testMap['isStoodDown'] = true;
    testMission = Mission.fromMap(testMap);
    expect(testMission.isStoodDown, true);
    expect(() => testMission.address, throwsNoSuchMethodError);

    var exportMission = testMission.toDatabase();
    expect(exportMission['time'], isA<Timestamp>() );
    exportMission['time'] = myTime;

    expect(exportMission, testMap);



  });

  test('Create mission from snapshot', (){
    var mission = Mission.fromSnapshot(DocumentSnapshotMock());
    expect( mission.address, 'some id string');

    mission = Mission.fromSnapshot(DocumentSnapshotMock());

  });
}
