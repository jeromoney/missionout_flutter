import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class LatLonInput extends StatelessWidget {
  final TextEditingController latController;
  final TextEditingController lonController;
  final String fieldDescription;

  const LatLonInput(
      {Key key, @required this.latController, @required this.lonController, @required this.fieldDescription})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final keyboardType = TextInputType.number;
    final inputFormatters = <TextInputFormatter>[
      WhitelistingTextInputFormatter(RegExp('[0-9\.]'))
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(fieldDescription),
        ),
        Row(
          children: <Widget>[
            Expanded(
              child: TextFormField(
                controller: latController,
                keyboardType: keyboardType,
                decoration: InputDecoration(
                    labelText: 'Latitude', border: OutlineInputBorder()),
                inputFormatters: inputFormatters,
                validator: (value) {
                  return latValidator(value, lonController);
                },
              ),
            ),
            Expanded(
              child: TextFormField(
                  controller: lonController,
                  keyboardType: keyboardType,
                  decoration: InputDecoration(
                      labelText: 'Longitude', border: OutlineInputBorder()),
                  inputFormatters: inputFormatters,
                  validator: (value) {
                    return lonValidator(value, latController);
                  }),
            ),
          ],
        )
      ],
    );
  }
}

@visibleForTesting
String latValidator(String value, TextEditingController companionController) {
  if (value == '' && companionController.text == ''){
    // User left both fields blank
    return null;
  }
  double parsedNumber = double.tryParse(value);
  if (parsedNumber == null) {
    // parser was unable to parse value i.e. not a number
    return 'Enter a valid number';
  } else if (-90 > parsedNumber || parsedNumber > 90) {
    return 'Lat is between -90 and 90';
  }
  return null;
}
@visibleForTesting
String lonValidator(String value, TextEditingController companionController) {
  if (value == '' && companionController.text == ''){
    // User left both fields blank
    return null;
  }
  double parsedNumber = double.tryParse(value);
  if (parsedNumber == null) {
    // parser was unable to parse value i.e. not a number
    return 'Enter a valid number';
  } else if (-180 > parsedNumber || parsedNumber > 180) {
    return 'Lon is between -180 and 180';
  }
}
