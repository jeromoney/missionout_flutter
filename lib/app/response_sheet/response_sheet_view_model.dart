import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';

class ResponseSheetViewModel {
  final BuildContext context;
  final Team team;
  final String docId;
  final User user;

  ResponseSheetViewModel({@required this.context})
      : this.team = Provider.of<Team>(context),
        this.user = Provider.of<User>(context),
        this.docId = (ModalRoute.of(context).settings.arguments
                as MissionAddressArguments)
            .docId;

  // The user's [Response] is first and the rest are sorted by response type
  Stream<List<Response>> responses() {
    return team.fetchResponses(docID: docId).map((responses) {
      // status that match so sort by name
      responses.sort((response1, response2) {
        if (response1.status == response2.status)
          return response1.teamMember.compareTo(response2.teamMember);

        // statuses that are Responding should be first.
        if (response1.status == 'Responding') return -1;
        if (response2.status == 'Responding') return -1;

        return response1.status.compareTo(response2.status);
      });
      final int index = responses
          .indexWhere((response) => response.selfRef.path.contains(user.uid));
      if (index == -1) return responses;
      final selfResponse = responses.removeAt(index);
      responses.insert(0, selfResponse);
      return responses;
    });
  }
}
