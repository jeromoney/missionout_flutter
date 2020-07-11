import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:missionout/data_objects/mission_address_arguments.dart';
import 'package:missionout/data_objects/response.dart';
import 'package:missionout/services/team/team.dart';
import 'package:missionout/services/user/user.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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

  Stream<Tuple2<Response, List<Response>>> responses() {
    return team.fetchResponses(docID: docId).map((responses) {
      final index = responses
          .indexWhere((response) => response.selfRef.path.contains(user.uid));
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
