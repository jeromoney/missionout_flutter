import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/user.dart';
import 'package:missionout/DataLayer/user_client.dart';

class UserBloc implements Bloc {
  final UserClient _client = UserClient();

  Stream<User> get userStream => _client.fetchUser();

  @override
  void dispose() {
    // TODO: implement dispose
  }

  handleSignIn() {
    _client.handleSignIn();
  }
}
