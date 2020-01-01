import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:missionout/BLoC/bloc.dart';
import 'package:missionout/DataLayer/user_client.dart';

class UserBloc implements Bloc {
  FirebaseUser _user;
  FirebaseUser get user => _user;
  final UserClient _client = UserClient();
  final _controller = StreamController<FirebaseUser>.broadcast();

  Stream<FirebaseUser> get userStream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
  }

  void setUser(FirebaseUser user){
    this._user = user;
    _controller.sink.add(user);
  }

  handleSignIn() async {
    final user = await _client.handleSignIn();
    setUser(user);
  }

  void handleSignOut() async {
    // response should be null if sucessful
    FirebaseUser response = await _client.handleSignOut();
    _controller.sink.add(response);
  }
}
