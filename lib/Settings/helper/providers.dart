import 'package:fresh_fold/Features/shedule_plan/view_model.dart/schedule_view_model.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../Features/auth/view_model.dart/auth_view_model.dart';
import '../../Features/on_boarding/view_model/onboarding_view_model.dart';
import '../../Features/pick_up_screen/view_model/location_view_model.dart';
import '../../Features/wrapper/view_model/navigation_provider.dart';

List<SingleChildWidget> providers = [
  ChangeNotifierProvider(create: (_) => OnBoardingViewModel()),
  ChangeNotifierProvider(create: (_) => NavigationProvider()),
  ChangeNotifierProvider(create: (_) => AuthViewModel()),
  ChangeNotifierProvider(create: (_) => LocationViewModel()),
  ChangeNotifierProvider(create: (_) => ScheduleViewModel()),
];
