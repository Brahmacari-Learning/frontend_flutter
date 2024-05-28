import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/services/api_service.dart';

class DoaProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getDoa() async {
    try {
      final response = await _apiService.fetchData('doa');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
