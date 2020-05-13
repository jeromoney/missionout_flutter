import 'package:missionout/DataLayer/app_mode.dart';
import 'package:missionout/Provider/AuthService/auth_service.dart';
import 'package:missionout/Provider/Team/team.dart';
import 'package:missionout/Provider/User/user.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import 'auth_service_fake.dart';
import 'team_fake.dart';
import 'user_fake.dart';

List<SingleChildStatelessWidget> PROVIDERS_FAKE = [
  ChangeNotifierProvider<AppMode>(
    create: (_) => AppMode(),
  ),
  ChangeNotifierProvider<AuthService>(
    create: (_) => AuthServiceFake(),
  ),
  ChangeNotifierProvider<User>(create: (_) => UserFake()),
  Provider<Team>(create: (_) => TeamFake()),
];
