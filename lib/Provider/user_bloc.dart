import 'dart:async';
import 'dart:collection';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:missionout/Provider/bloc.dart';
import 'package:missionout/DataLayer/user_client.dart';
import 'package:tuple/tuple.dart';

class UserBloc implements Bloc {
  UserBloc() {
    // check if user is already signed in
    _fetchCurrentUser();
  }

  FirebaseUser user;
  HashMap<dynamic, dynamic> _claims;

  final UserClient _client = UserClient();
  final _controller = StreamController<FirebaseUser>.broadcast();

  bool get isEditor => _claims['editor'] ?? false;

  String get teamDocId => _claims['teamDocID'];

  String get teamID {
    if (user == null) {
      return null;
    }
     return user.email.split('@')[1];
  }

  Stream<FirebaseUser> get userStream => _controller.stream;

  @override
  void dispose() {
    _controller.close();
  }

  void _setUserTuple(
      Tuple2<FirebaseUser, HashMap<dynamic, dynamic>> userTuple) {
    this.user = userTuple.item1;
    this._claims = userTuple.item2;
    _controller.sink.add(user);
  }

  Future<bool> _fetchCurrentUser() async {
    Tuple2<FirebaseUser, HashMap<dynamic, dynamic>> userTuple =
        await _client.fetchCurrentUser();
    this.user = userTuple.item1;
    this._claims = userTuple.item2;
    _controller.sink.add(user);
    return (user != null);
  }

  handleSignIn() async {
    final userTuple = await _client.handleSignIn();
    _setUserTuple(userTuple);
  }

  void handleSignOut() async {
    // response should be null if sucessful
    FirebaseUser response = await _client.handleSignOut();
    _controller.sink.add(response);
  }
}
