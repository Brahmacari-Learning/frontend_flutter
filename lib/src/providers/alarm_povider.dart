import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/services/api_service.dart';

class AlarmProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getAlarm() async {
    try {
      final response = await _apiService.fetchData('alarms');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> createAlarm(
    int jam,
    int menit,
    int ulangiDoa,
    int doaId,
  ) async {
    try {
      final response = await _apiService.postData(
        'alarms/create',
        {
          'jam': '$jam:$menit',
          'ulangiDoa': ulangiDoa,
          'doaId': doaId,
        },
      );
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
