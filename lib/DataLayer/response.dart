import 'package:flutter/cupertino.dart';

class Response {
  final String team_member;
  final String status;
  final String driving_time;

  Response(@required team_member, status, driving_time)
      : this.team_member = team_member,
        this.status = status,
        this.driving_time = driving_time;
}
