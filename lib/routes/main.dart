import 'package:e_library_mobile/pages/main.dart';
import 'package:flutter/material.dart';
import 'package:e_library_mobile/pages/auth/login.dart';
import 'package:e_library_mobile/pages/user/index.dart';
import 'package:e_library_mobile/pages/user/form.dart';
import 'package:e_library_mobile/pages/genre/index.dart';
import 'package:e_library_mobile/pages/genre/form.dart';
import 'package:e_library_mobile/pages/book/index.dart';
import 'package:e_library_mobile/pages/book/form.dart';
import 'package:e_library_mobile/pages/member/index.dart';
import 'package:e_library_mobile/pages/member/form.dart';

Map<String, WidgetBuilder> buildRoute(BuildContext context) {
  return {
    '/': (context) => const LoginPage(),
    '/main': (context) => const MainPage(),
    '/user': (context) => const UserPage(),
    '/user/create': (context) => const FormUserPage(),
    '/user/update': (context) => const FormUserPage(),
    '/genre':(context) => const GenrePage(),
    '/genre/create':(context) => const FormGenrePage(),
    '/genre/update':(context) => const FormGenrePage(),
    '/book':(context) => const BookPage(),
    '/book/create':(context) => const FormBookPage(),
    '/book/update':(context) => const FormBookPage(),
    '/member':(context) => const MemberPage(),
    '/member/create':(context) => const FormMemberPage(),
    '/member/update':(context) => const FormMemberPage(),
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