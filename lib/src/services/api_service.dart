import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final String _baseUrl = 'http://10.23.2.242:3000/api';
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

  static const String _baseUrlCDN = 'https://cdn.hmjtiundiksha.com';
  static const String _authorizationToken =
      'Bearer jfdjglkfjglkfjdl234kgjldsfkj24glsdfkjglkdfjglkdfjlgkjdlfkgj24dfkjg';
  static Future<String> uploadFilePath(
    String filePath,
    String destination,
  ) async {
    final file = File(filePath);

    final request = http.MultipartRequest('POST', Uri.parse(_baseUrlCDN));

    request.files
        .add(await http.MultipartFile.fromPath('fileToUpload', file.path));

    request.fields.addAll({'destination': destination});

    request.headers.addAll({'Authorization': _authorizationToken});

    final response = await request.send();

    print('File length before upload: ${await file.length()}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(await response.stream.bytesToString());
      print('Response received: $jsonResponse');
      if (jsonResponse['path'] == null) {
        throw Exception('Failed to upload file');
      }
      return jsonResponse['path'];
    } else {
      print('Failed to upload file. Status code: ${response.statusCode}');
      print('Response: ${await response.stream.bytesToString()}');
      throw Exception('Failed to upload file');
    }
  }

  static Future<String> uploadFile(File file, String destination) async {
    print('Starting uploadFile');
    print('File: ${file.path}');
    print('File length before upload: ${await file.length()}');
    print('Destination: $destination');

    final request = http.MultipartRequest('POST', Uri.parse(_baseUrlCDN));

    request.files
        .add(await http.MultipartFile.fromPath('fileToUpload', file.path));

    request.fields.addAll({'destination': destination});

    request.headers.addAll({'Authorization': _authorizationToken});

    final response = await request.send();

    print('File length before upload: ${await file.length()}');

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(await response.stream.bytesToString());
      print('Response received: $jsonResponse');
      if (jsonResponse['path'] == null) {
        throw Exception('Failed to upload file');
      }
      return jsonResponse['path'];
    } else {
      print('Failed to upload file. Status code: ${response.statusCode}');
      print('Response: ${await response.stream.bytesToString()}');
      throw Exception('Failed to upload file');
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
