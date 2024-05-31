import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/services/api_service.dart';

class StageProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // get all stages
  Future<Map<String, dynamic>> getStages() async {
    try {
      final response = await _apiService.fetchData('stage');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
