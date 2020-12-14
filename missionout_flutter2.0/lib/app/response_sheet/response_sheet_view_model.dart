import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/widgets.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

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


  Stream<List<Response>> teamResponses(){
    return _team.fetchResponses(documentReference: _documentReference).map((responseList) {
      // status that match so sort by name
      responseList.sort((response1, response2) {
        if (response1.status == response2.status)
          return response1.teamMember.compareTo(response2.teamMember);

        // statuses that are Responding should be first.
        if (response1.status == 'Responding') return -1;
        if (response2.status == 'Responding') return -1;

        return response1.status.compareTo(response2.status);
      });

      // Find the users own response and reorder to the front
      final selfIndex = responseList.indexWhere((response) => response.teamMember == _user.displayName);
      if (selfIndex != -1){
        final selfResponse = responseList[selfIndex];
        responseList.removeAt(selfIndex);
        responseList.insert(0, selfResponse);
      }
      return responseList;
    });
  }

  bool userIsInResponseList(List<Response> responses) => responses[0].teamMember == _user.displayName;
}
