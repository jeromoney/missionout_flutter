import 'dart:math';

import 'package:missionout/DataLayer/response.dart';

class ResponsesClient {
  List<Response> fetchResponses() {
    final responses = ['Responding', 'Unavailable', 'Delayed', 'Standby'];
    final names = [
      'Daren Deberry',
      'Ione Ivey',
      'Debora Demille',
      'Tiffanie Tolar',
      'Isidro Ives',
      'Janis Jaramillo',
      'Walker Waid',
      'Deonna Devault',
      'Leighann Lindbloom',
      'Anthony Anthony',
      'Penney Pereyra',
      'Elden Ethier',
      'Lillie Longoria',
      'Talitha Teachout',
      'Franchesca Fouse',
      'Caren Choiniere',
      'Daine Delaughter',
      'Sharolyn Strauss',
      'Galen Gregory',
      'Yukiko Yarnall',
      'Jennifer Jim',
      'Diana Diemer',
      'Lakeesha Levell',
      'Catina Cantu',
      'Rheba Renna',
      'Shirely Shetler',
      'Dominick Dunstan',
      'Joey Jonason',
      'Emilio Eades',
      'Malorie Martindale',
      'Torie Tindell',
      'Jone Jordan',
      'Devora Diener',
      'Marlin Mcbay',
      'Salvatore Styer',
      'Illa Isaacson',
      'Mignon Mellin',
      'Eulalia Entwistle',
      'Wilmer Winship',
      'Kristi Kilkenny',
      'Jonell Jandreau',
      'Virgen Victorino',
      'Hobert Hillenbrand',
      'Christene Connell',
      'Ileana Ignacio',
      'Sherron Suman',
      'Arron Atchley',
      'Verline Vien',
      'Elina Emmert',
      'Christoper Conger'
    ];

    List<Response> responseList = [];
    var numGenerator = Random.secure();
    for (var i = 0; i < 40; i++) {
      final nameIndex = numGenerator.nextInt(names.length);
      final name = names[nameIndex];

      final responseIndex = numGenerator.nextInt(responses.length);
      final responseValue = responses[responseIndex];

      var drivingTime;
      if (responseValue == 'Responding') {
        final randomTime = numGenerator.nextInt(60);
        drivingTime = '$randomTime mins';
      }

      responseList.add(Response(name, responseValue, drivingTime));
    }

    return responseList;



//    final TEAM_ID = 'raux5KIhuIL84bBmPSPs';
//    final DOCUMENT_REFERENCE = 'VD2vVykiifgoypT76ifA';
//
//    return Firestore.instance
//        .collection('teams/$TEAM_ID/missions')
//        .document(DOCUMENT_REFERENCE)
//        .collection('responses')
//        .snapshots();
  }
}
