import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:missionout/DataLayer/response.dart';

class ResponsesClient {
  // return type was Future<List<Response>>
  Future<Stream<DocumentSnapshot>> fetchResponses() async {
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
    for (var i = 0; i < 10; i++) {
      final nameIndex = numGenerator.nextInt(names.length);
      final name = names[nameIndex];

      final responseIndex = numGenerator.nextInt(responses.length);
      final responseValue = responses[responseIndex];

      var driving_time = null;
      if (responseValue == 'Responding') {
        final random_time = numGenerator.nextInt(60);
        driving_time = '$random_time mins';
      }

      responseList.add(Response(name, responseValue, driving_time));
    }

    var i = Firestore.instance.document('/teams/raux5KIhuIL84bBmPSPs/missions/VD2vVykiifgoypT76ifA/responses/bVQoM6M5F0UjoFizUAUmYZkp9nH2')
    .get().asStream();
    return i;
    
    Firestore.instance
        .collection('teams')
        .snapshots()
        .listen((data) => print(data.documents.getRange(0, 1).toList()[0].data));

    return responseList;
  }
}
