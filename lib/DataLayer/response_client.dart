import 'package:mission_out/DataLayer/response.dart';

class ResponsesClient{
  Future<List<Response>> fetchResponses() async {
    final response0 = Response('Joe Smith', 'Responding', '12 min');
    final response1 = Response('Bob Dole', 'Unavailable', null);
    final response2 = Response('Jayne Jackson', 'Delayed', null);
    final response3 = Response('Franchesca Tines', 'Responding', '45 min');
    return [response0,response1,response2,response3];
  }
}