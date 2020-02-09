import 'package:missionout/DataLayer/extended_user.dart';
import 'package:mockito/mockito.dart';

class ExtendedUserMock extends Mock implements ExtendedUser{
  final String chatURI;

  ExtendedUserMock({this.chatURI});

}