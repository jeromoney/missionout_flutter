part of 'editor_screen.dart';

class URITextFormField extends StatefulWidget {
  final TextEditingController controller;

  const URITextFormField({Key key, @required this.controller})
      : super(key: key);

  @override
  URITextFormFieldState createState() =>
      URITextFormFieldState(controller: controller);
}

class URITextFormFieldState extends State<URITextFormField> {
  bool _uriIsValidated = false;
  String _errorMessage;
  final TextEditingController controller;

  URITextFormFieldState({@required this.controller});

  @override
  Column build(BuildContext context) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          TextFormField(
            controller: controller,
            decoration: InputDecoration(
                suffixIcon: Icon(_uriIsValidated ? Icons.check : null),
                errorText: _errorMessage,
                border: OutlineInputBorder(),
                labelText: 'Chat URI',
                hintText: 'URI address of chat app'),
          ),
          FlatButton(
            child: Text('Try URI'),
            onPressed: () async {
              try {
                await launch(controller
                    .text); // Exception is thrown async so we wait to catch it.
                setState(() {
                  _uriIsValidated = true;
                  _errorMessage = null;
                });
              } catch (exception) {
                setState(() {
                  _uriIsValidated = false;
                  _errorMessage = 'error loading URI';
                });
                final snackBar = SnackBar(
                    content: Text(
                        'Error launching URI. Try something like slack://channel?team={TEAM_ID}&id={CHANNEL_ID}'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
              } finally {
                // close keyboard
                FocusScope.of(context).requestFocus(FocusNode());
              }
            },
          ),
        ]);
  }
}
