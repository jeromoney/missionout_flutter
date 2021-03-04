import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:json_annotation/json_annotation.dart';

part 'app_setup.g.dart';

@immutable
@JsonSerializable()
class AppSetup {
  final String gmailDomain;
  final bool showAppleButton;
  final bool showEmailLogin;
  final String team;

  const AppSetup(
      {@required this.gmailDomain,
      @required this.showAppleButton,
      @required this.showEmailLogin,
      @required this.team});

  static fromSnapshot(DocumentSnapshot snapshot) => _$AppSetupFromJson(snapshot.data());
}
