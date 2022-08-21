import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future login(String username, String password) async {
  final SharedPreferences _prefs = await SharedPreferences.getInstance();

  final response = await http.post(
    Uri.parse('http://192.168.0.11:8000/api/v1/login'),
    headers: <String, String> {
      'accept': 'application/json',
      'Content-Type': 'application/json; charset=utf-8',
    },
    body: jsonEncode(<String, String> {
      'username': username,
      'password': password,
    }),
  );

  if(response.statusCode == 200) {
    Map<String, dynamic> data = jsonDecode(response.body);
    _prefs.setString('_token', data['token'].toString());
  }

  return response;
}