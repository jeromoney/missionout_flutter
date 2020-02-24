import 'package:flutter_test/flutter_test.dart';
import 'package:missionout/Provider/my_firebase_user.dart';

void main() {
  test('FirestoreTeam unit tests', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    final user = MyFirebaseUser();
  });
}
