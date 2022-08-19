import 'package:e_library_mobile/pages/main.dart';
import 'package:flutter/material.dart';
import 'package:e_library_mobile/pages/auth/login.dart';
import 'package:e_library_mobile/pages/user/index.dart';
import 'package:e_library_mobile/pages/user/form.dart';

// arguments
import 'package:e_library_mobile/arguments/update_user.dart';

Map<String, WidgetBuilder> buildRoute(BuildContext context) {
  return {
    '/': (context) => const LoginPage(),
    '/main': (context) => const MainPage(),
    '/user': (context) => const UserPage(),
    '/user/create': (context) => FormUserPage(),
    '/user/update': (context) => FormUserPage(),
  };
}

// Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//   if(settings.name == '/user/update') {
//     final args = settings.arguments as UpdateUserArgument;

//     return MaterialPageRoute(
//       builder: (context) {
//         return ;
//       }
//     );
//   }

//   print(settings.name);
//   assert(false, 'Need to implement ${settings.name}');
//   return null;
// }