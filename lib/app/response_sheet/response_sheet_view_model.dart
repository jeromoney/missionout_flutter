import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

class ResponseSheetViewModel {
  final BuildContext context;
  final Team _team;
  final DocumentReference _documentReference;
  final User _user;

  ResponseSheetViewModel(this.context)
      : this._team = context.watch<Team>(),
        this._user = context.watch<User>(),
        this._documentReference = (ModalRoute.of(context).settings.arguments
                as MissionAddressArguments)
            .documentReference;

  Stream<Tuple2<Response, List<Response>>> responses() {
    return _team
        .fetchResponses(documentReference: _documentReference)
        .map((responses) {
      final index = responses
          .indexWhere((response) => response.selfRef.path.contains(_user.uid));
      Response selfResponse;
      if (index == -1)
        selfResponse = null;
      else
        selfResponse = responses.removeAt(index);

      // status that match so sort by name
      responses.sort((response1, response2) {
        if (response1.status == response2.status)
          return response1.teamMember.compareTo(response2.teamMember);

        // statuses that are Responding should be first.
        if (response1.status == 'Responding') return -1;
        if (response2.status == 'Responding') return -1;

        return response1.status.compareTo(response2.status);
      });
      return Tuple2<Response, List<Response>>(selfResponse, responses);
    });
  }
}
