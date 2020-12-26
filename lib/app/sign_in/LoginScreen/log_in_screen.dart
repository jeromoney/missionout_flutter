import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_auth_buttons/flutter_auth_buttons.dart';
import 'package:missionout/constants/constants.dart';
import 'package:missionout/core/platforms.dart';
import 'package:missionout/data_objects/app_setup.dart';
import 'package:missionout/data_objects/is_loading_notifier.dart';
import 'package:provider/provider.dart';

import 'log_in_screen_model.dart';

class LogInScreen extends StatefulWidget {
  static const routeName = '/logInScreen';
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  _LogInScreenState createState() => _LogInScreenState();
}

class _LogInScreenState extends State<LogInScreen> {
  AppSetup _appSetup;
  String get gmailDomain => _appSetup?.gmailDomain;
  bool get showGoogleButton => true;
  bool get showAppleButton => _appSetup?.showAppleButton ?? Platforms.isIOS;
  bool get showEmailLogin => _appSetup?.showEmailLogin ?? false;
  @override
  void initState() {
    super.initState();
    widget._emailController.text = "";
    _setEmailField(context);
  }

  // TODO - refactor this with futurebuilder,
  void _setEmailField(BuildContext context) async {
    widget._emailController.text = await LoginScreenModel.getEmail(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    _appSetup = ModalRoute.of(context).settings.arguments as AppSetup;
    final model = LoginScreenModel(context);
    return Consumer<IsLoadingNotifier>(
      builder: (_, IsLoadingNotifier isLoadingNotifier, __) {
        if (isLoadingNotifier.isLoading)
          return Scaffold(body: LinearProgressIndicator());
        else
          return GestureDetector(
            onHorizontalDragUpdate: (details) {
              if (details.delta.dx > 0) Navigator.of(context).pop();
            },
            child: Scaffold(
              appBar: AppBar(title: Text("MissionOut Log In"),),
              body: Center(
                child: LayoutBuilder(
                  builder: (context, viewportConstraints) =>
                      SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                          maxWidth: Constants.column_width,
                          minHeight: viewportConstraints.maxHeight),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          if (showGoogleButton)
                            GoogleSignInButton(
                              text: 'Log in with Google',
                              onPressed: () => model.signInWithGoogle(
                                  hostedDomain: gmailDomain),
                            ),
                          if (model.isAppleSignInAvailable &&
                              showAppleButton) ...[
                            AppleSignInButton(
                              text: 'Log in with Apple',
                              style: AppleButtonStyle.white,
                              onPressed: model.signInWithApple,
                            )
                          ],
                          if (showEmailLogin &&
                              (showAppleButton ||
                                  showGoogleButton))
                            Divider(),
                          if (showEmailLogin)
                            Form(
                              key: widget._formKey,
                              child: Column(
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: TextFormField(
                                      controller: widget._emailController,
                                      // ignore: missing_return
                                      validator: (email) {
                                        if (!EmailValidator.validate(email))
                                          return 'Enter a valid email';
                                      },
                                      decoration: InputDecoration(
                                        labelText: 'Email',
                                        border: OutlineInputBorder(),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                      width: Constants.column_width,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: RaisedButton(
                                          child: Text('Request email link'),
                                          onPressed: () async {
                                            if (!widget._formKey.currentState
                                                .validate()) return;
                                            model.sendEmailLink(
                                                email: widget
                                                    ._emailController.text);
                                          },
                                        ),
                                      )),
                                ],
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
      },
    );
  }
}
