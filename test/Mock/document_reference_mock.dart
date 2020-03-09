import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mockito/mockito.dart';

class DocumentReferenceMock extends Mock implements DocumentReference{
  String get documentID => 'some id string';
}