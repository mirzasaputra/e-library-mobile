import 'dart:convert';
import 'package:e_library_mobile/models/book.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class BookApi {
  static String baseUrl = 'http://192.168.0.11:8000/api/v1/books';

  static Future<List<Book>> findAll() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString('_token').toString();

    final response = await http.get(
      Uri.parse(baseUrl),
      headers: <String, String> {
        'accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_token',
      }
    );

    if(response.statusCode == 200) {
      final parsed = jsonDecode(response.body)
          .cast<Map<String, dynamic>>();

      return parsed
        .map<Book>((json) => Book.fromJson(json))
        .toList();
    } else {
      return [];
    }
  }

  static Future<Book> findOne(String hashid) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString('_token').toString();

    final response = await http.get(
      Uri.parse("$baseUrl/$hashid/find"),
      headers: <String, String> {
        'accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_token'
      }
    );

    if(response.statusCode == 200) {
      return Book.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to upload data user");
    }
  }

  static Future store(String data) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString('_token').toString();

    final response = await http.post(
      Uri.parse("$baseUrl/store"),
      headers: <String, String> {
        'accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_token',
      },
      body: data
    );

    return response;
  }

  static Future update(String hashid, String data) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString('_token').toString();

    final response = await http.post(
      Uri.parse("$baseUrl/$hashid/update"),
      headers: <String, String> {
        'accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_token',
      },
      body: data
    );

    return response;
  }

  static Future delete(String hashid) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    String _token = _prefs.getString('_token').toString();

    final response = await http.delete(
      Uri.parse("$baseUrl/$hashid/delete"),
      headers: <String, String> {
        'accept': 'application/json',
        'Content-Type': 'application/json; charset=utf-8',
        'Authorization': 'Bearer $_token'
      }
    );

    return response;
  }
}