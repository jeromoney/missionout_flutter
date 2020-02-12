import 'package:flutter/cupertino.dart';
import 'package:intl_phone_number_input/intl_phone_number_input.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  PhoneNumber number =
  await PhoneNumber.getRegionInfoFromPhoneNumber('+15105406718');

}

Future<String> getRegion(String phoneNumberStr) async {
  if (phoneNumberStr == null || phoneNumberStr.isEmpty) {
    return 'US';
  }

  PhoneNumber number =
  await PhoneNumber.getRegionInfoFromPhoneNumber(phoneNumberStr);
  return number.isoCode;
}