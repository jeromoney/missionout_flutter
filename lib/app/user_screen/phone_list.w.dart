part of 'user_screen.dart';


class _PhoneNumberList extends StatefulWidget {
  final List<PhoneNumberRecord> phoneNumbers;

  const _PhoneNumberList(this.phoneNumbers);

  @override
  _PhoneNumberListState createState() => _PhoneNumberListState();
}

class _PhoneNumberListState extends State<_PhoneNumberList> {
  @override
  Widget build(BuildContext context) {
    final phoneNumbers = widget.phoneNumbers;
    final model = UserScreenModel(context);
    if (phoneNumbers == null || phoneNumbers.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(8.0),
        child: Text("No phone numbers. Add one now."),
      );
    }
    return ListView.separated(
        physics: const NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemBuilder: (_, index) {
          final phoneNumberRecord = widget.phoneNumbers[index];
          final phoneNumber = phoneNumberRecord.getPhoneNumber();
          return ListTile(
              title: Text(phoneNumber.phoneNumber),
              subtitle: Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.phone,
                      size: 24,
                      color: phoneNumberRecord.allowCalls ? Colors.green : null,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Icon(
                      Icons.sms,
                      size: 24,
                      color: phoneNumberRecord.allowText ? Colors.green : null,
                    ),
                  )
                ],
              ),
              trailing: IconButton(
                key: const Key("Delete Phone Number"),
                icon: const Icon(
                  Icons.remove_circle_outline,
                ),
                onPressed: () {
                  model.removePhoneNumberRecord(phoneNumberRecord);
                },
              ));
        },
        separatorBuilder: (_, __) => const Divider(),
        itemCount: phoneNumbers.length);
  }
}