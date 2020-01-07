import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/BLoC/bloc_provider.dart';
import 'package:missionout/BLoC/user_bloc.dart';

class SigninScreen extends StatelessWidget {
  SigninScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<UserBloc>(context);
    return Scaffold(
        body: Center(
      child: GoogleSignInButton(
        darkMode: true,
        onPressed: bloc.handleSignIn,
      ),
    ));
  }
}
