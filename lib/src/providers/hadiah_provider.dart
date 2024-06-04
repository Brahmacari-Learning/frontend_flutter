import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/services/api_service.dart';

class HadiahProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getHadiah() async {
    try {
      final response = await _apiService.fetchData('gift');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> getLencana() async {
    try {
      final response = await _apiService.fetchData('missions/badges');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
