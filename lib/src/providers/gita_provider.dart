import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GitaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Get Gita
  Future<Map<String, dynamic>> getGita() async {
    try {
      final response = await _apiService.fetchData('gita');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
