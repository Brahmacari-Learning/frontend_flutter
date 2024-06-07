import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/services/api_service.dart';

class MissionProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  Future<Map<String, dynamic>> getMission() async {
    try {
      final response = await _apiService.fetchData('missions');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> presensi() async {
    try {
      final response = await _apiService.fetchData('user/presense');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> claimMission(int id) async {
    try {
      final response = await _apiService.fetchData('missions/$id/claim-reward');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
