import 'package:missionout/DataLayer/user.dart';

class UserClient {
  Stream<User> fetchUser() {
    var userStream =
        Stream<User>.periodic(Duration(seconds: 40), (x) => User(null)).take(2);
    return userStream;
  }
}
