import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'http://192.168.2.3:3000/api';
  // final String _baseUrl = 'https://vedanta-pro.vercel.app/api';

  // Example of a GET request
  Future<Map<String, dynamic>> fetchData(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.get(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer $token', // Use the token in the Authorization header
      },
    );

    if (response.statusCode == 200) {
      final decodedResponse = utf8.decode(response.bodyBytes);
      final jsonResponse = jsonDecode(decodedResponse);
      return jsonResponse;
    } else if (response.statusCode == 401) {
      // Remove the token from shared preferences if it's unauthorized
      prefs.remove('token');

      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to load data');
    }
  }

  // Example of a POST request
  Future<Map<String, dynamic>> postData(
    String endpoint,
    Map<String, dynamic> data,
  ) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.post(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      // Remove the token from shared preferences if it's unauthorized
      prefs.remove('token');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to post data');
    }
  }

  // Add other methods for PUT, DELETE, etc. as needed
  // Delete request
  Future<Map<String, dynamic>> deleteData(String endpoint) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    final response = await http.delete(
      Uri.parse('$_baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else if (response.statusCode == 401) {
      prefs.remove('token');
      throw Exception('Unauthorized');
    } else {
      throw Exception('Failed to delete data');
    }
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/login'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to login ${response.body}');
    }
  }

  Future<Map<String, dynamic>> register(
      String email, String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/user/register'),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'email': email,
        'name': username,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to register ${response.body}');
    }
  }
}
