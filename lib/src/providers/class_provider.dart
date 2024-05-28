import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClassProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Get classes
  Future<Map<String, dynamic>> getClasses() async {
    try {
      final response = await _apiService.fetchData('class');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Join Class
  Future<Map<String, dynamic>> joinClass(String code) async {
    try {
      final response = await _apiService.postData('class/join', {
        'classCode': code,
      });
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Class Member
  Future<Map<String, dynamic>> classMember(int id) async {
    try {
      final response = await _apiService.fetchData('class/$id/members');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
