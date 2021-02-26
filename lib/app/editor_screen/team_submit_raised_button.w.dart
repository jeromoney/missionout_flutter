part of 'editor_screen.dart';

class TeamSubmitRaisedButton extends StatefulWidget {
  final GlobalKey<FormState> formKey;
  final TextEditingController chatURIController;

  const TeamSubmitRaisedButton({
    Key key,
    @required this.formKey,
    @required this.chatURIController,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State createState() => TeamSubmitRaisedButtonState(
      chatURIController: chatURIController, formKey: formKey);
}

class TeamSubmitRaisedButtonState extends State<TeamSubmitRaisedButton> {
  final GlobalKey<FormState> formKey;
  final TextEditingController chatURIController;
  Icon resultIcon;

  TeamSubmitRaisedButtonState({
    @required this.formKey,
    @required this.chatURIController,
  });

  @override
  Widget build(BuildContext context) {
    return Row(children: <Widget>[
      ElevatedButton(
        onPressed: () async {
          // close keyboard
          FocusScope.of(context).requestFocus(FocusNode());
          if (formKey.currentState.validate()) {
            Scaffold.of(context)
                .showSnackBar(const SnackBar(content: Text('Processing Data')));
            try {
              final team = context.read<Team>();
              await team.updateChatURI(chatURIController.text);
              Scaffold.of(context).hideCurrentSnackBar();

              team.chatURI = chatURIController.text;
              setState(() {
                resultIcon = const Icon(
                  Icons.check,
                  color: Colors.green,
                );
              });
            } catch (e) {
              Scaffold.of(context).showSnackBar(
                  const SnackBar(content: Text('Error uploading information')));
              setState(() {
                resultIcon = const Icon(
                  Icons.error_outline,
                  color: Colors.red,
                );
              });
            }
          }
        },
        child: const Text('Submit'),
      ),
      resultIcon ?? Container()
    ]);
  }
}
