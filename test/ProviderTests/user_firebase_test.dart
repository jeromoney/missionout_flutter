import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/my_firebase_user.dart';

void main() {
  test('FirestoreTeam unit tests', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var myUser = MyFirebaseUser();
    expect(() => myUser.displayName, throwsNoSuchMethodError);
    // TODO - needs to be run in integration test since the google sign in button is interactive
  });
}
