
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../Features/on_boarding/view_model/onboarding_view_model.dart';



List<SingleChildWidget> providers = [
 ChangeNotifierProvider(create: (_) => OnBoardingViewModel()),

];
