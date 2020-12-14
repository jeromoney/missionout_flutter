part of 'editor_screen.dart';

class TeamSubmitRaisedButton extends StatefulWidget {
  final formKey;
  final chatURIController;

  const TeamSubmitRaisedButton({
    Key key,
    @required this.formKey,
    @required this.chatURIController,
  }) : super(key: key);

  @override
  State createState() => TeamSubmitRaisedButtonState(
      chatURIController: chatURIController, formKey: formKey);
}

class TeamSubmitRaisedButtonState extends State<TeamSubmitRaisedButton> {
  final formKey;
  final TextEditingController chatURIController;
  Icon resultIcon;

  TeamSubmitRaisedButtonState({
    @required this.formKey,
    @required this.chatURIController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      RaisedButton(
        onPressed: () async {
          // close keyboard
          FocusScope.of(context).requestFocus(FocusNode());
          if (formKey.currentState.validate()) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text('Processing Data')));
            try {
              final team = context.read<Team>();
              await team.updateChatURI(chatURIController.text);
              ScaffoldMessenger.of(context).hideCurrentSnackBar();

              team.chatURI = chatURIController.text;
              setState(() {
                resultIcon = Icon(
                  Icons.check,
                  color: Colors.green,
                );
              });
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error uploading information')));
              setState(() {
                resultIcon = Icon(
                  Icons.error_outline,
                  color: Colors.red,
                );
              });
            }
          }
        },
        child: Text('Submit'),
      ),
      resultIcon ?? Container()
    ]);
  }
}
