import 'package:cloud_firestore/cloud_firestore.dart';

/// Multipurpose arguments class that holds the current mission for several screens.
class MissionAddressArguments{
  final DocumentReference reference;
  MissionAddressArguments(this.reference);
}