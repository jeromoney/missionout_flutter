
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:missionout/DataLayer/mission.dart';
import 'package:missionout/DataLayer/page.dart';
import 'package:test/test.dart';

import '../Mock/document_reference_mock.dart';

void main(){
  test('Create page test', (){
    final creator = 'Joe Smith';
    final description = 'Someone got hurt';
    final needForAction = 'need people to help';
    var mission = Mission(description,needForAction,null,null);
    mission.reference = DocumentReferenceMock();

    var page = Page(creator:creator,mission:mission);
    expect(page.creator, creator);
    expect(page.mission,mission);

    final map = page.toJson();
    map['time'] = Timestamp.fromMicrosecondsSinceEpoch(0);
    page = Page.fromMap(map);
    expect(page.creator,creator);
    expect(page.description,description);
    expect(page.needForAction,needForAction);
    expect(page.address, 'some id string');
    expect(page.time, Timestamp.fromMicrosecondsSinceEpoch(0));


  });
}