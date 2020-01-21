import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:missionout/DataLayer/extended_user.dart';
import 'package:missionout/Provider/firestore_service.dart';
import 'package:missionout/UI/my_appbar.dart';
import 'package:provider/provider.dart';
import 'package:phone_number/phone_number.dart';

class UserScreen extends StatelessWidget {
  final _db = FirestoreService();
  final _formKey = GlobalKey<FormState>();
  final mobileController = TextEditingController();
  final phoneController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<FirebaseUser>(context);
    final extendedUser = Provider.of<ExtendedUser>(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TextEditingController(),
        )
      ],
      child: Scaffold(
          appBar: MyAppBar(title: 'User Options'),
          body: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text(user.displayName),
                  Text(user.email),
                  Text(extendedUser.textPhoneNumber),
                  Text(extendedUser.voicePhoneNumber),
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    onChanged: (value) async {
                      var formattedNumber = await PhoneNumber().format(value, 'US');
                      final oldSelection = mobileController.value.selection;
                      mobileController.value =
                          TextEditingValue(text: formattedNumber['formatted'], selection: oldSelection);
                    },
                    controller: mobileController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.perm_phone_msg),
                        hintText: 'Mobile phone number for SMS pages',
                        labelText: 'Mobile number'),
                    validator: (String phoneNumber) {
                      return phoneNumber.contains('A') ? 'Numbers only' : null;
                    },
                  ),
                  TextFormField(
                    inputFormatters: <TextInputFormatter>[
                      WhitelistingTextInputFormatter.digitsOnly,
                    ],
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    decoration: InputDecoration(
                        icon: Icon(Icons.phone),
                        hintText: 'Phone number for voice pages',
                        labelText: 'Phone number'),
                    validator: (String phoneNumber) {
                      return phoneNumber.contains('[A-Z]')
                          ? 'Numbers only'
                          : null;
                    },
                  ),
                  RegionsDropDownButton(),
                  RaisedButton(
                      child: Text('Submit'),
                      onPressed: () {
                        _submitForm();
                      }),
                ],
              ))),
    );
  }

  void _submitForm() {
    _formKey.currentState.validate();
  }

  Future<void> someMethod() async {}
}

class RegionsDropDownButton extends StatefulWidget {
  @override
  State createState() => _RegionsDropDownButtonState();
}

class _RegionsDropDownButtonState extends State<RegionsDropDownButton> {
  List<String> _regionList;
  String _defaultRegion = 'US';

  _RegionsDropDownButtonState() {
    allSupportedRegions().then((regions) => setState(() {
          _regionList = regions;
        }));
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      value: _defaultRegion,
      icon: Icon(Icons.arrow_downward),
      iconSize: 24,
      elevation: 16,
      underline: Container(
        height: 2,
        color: Colors.deepPurpleAccent,
      ),
      onChanged: (region) {
        setState(() {
          _defaultRegion = region;
        });
      },
      items: _regionList.map<DropdownMenuItem<String>>(((value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      })).toList(),
    );
  }

  Future<List<String>> allSupportedRegions() async {
    var regions = await PhoneNumber().allSupportedRegions();
    return regions.keys.toList()..sort();
  }
}

class PhoneNumberFormatter with ChangeNotifier {
  int _numberString;
  String _region;
}
