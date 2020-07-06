import 'package:cloud_firestore/cloud_firestore.dart';

/// Multipurpose arguments class that holds the current mission for several screens.
class MissionAddressArguments {
  final dynamic address;
  // A bit hacky here as an address can be a DocumentReference or a String
  String get docId => (address is DocumentReference) ? address.docId : address;

  MissionAddressArguments(this.address);
}
