import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum GPS { latitude, longitude }

class GPSTextFormFieldX extends StatelessWidget {
  // Implementation of both lat/lon textform fields
  final TextEditingController controller;
  final GPS gpsType;
  final TextEditingController companionController;

  const GPSTextFormFieldX({
    Key key,
    this.gpsType,
    this.controller,
    this.companionController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String label;
    double low;
    double high;

    gpsType == GPS.latitude ? label = 'Lat' : label = 'Lon';
    if (gpsType == GPS.latitude) {
      low = -90.0;
      high = 90.0;
    } else {
      // GPS type is then longitude
      low = -180.0;
      high = 180.0;
    }

    return TextFormField(
      controller: controller,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(labelText: label),
      inputFormatters: <TextInputFormatter>[
        WhitelistingTextInputFormatter(RegExp('[0-9\.]')),
        // match digits and period only
      ],
      validator: (value) {
        final valueAsDouble = double.tryParse(value);
        if (companionController.text.isEmpty && valueAsDouble == null) {
          // allow null values if both lat and lon are blank
          return null;
        }
        if (valueAsDouble == null) {
          return 'Enter a valid number';
        }
        if (low > valueAsDouble || valueAsDouble > high) {
          return 'Enter a valid $label';
        }
        return null;
      },
    );
  }
}
