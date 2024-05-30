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

  Future<Map<String, dynamic>> getDoaById(int id) async {
    try {
      final response = await _apiService.fetchData('doa/$id');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> getLikedDoas() async {
    try {
      final response = await _apiService.fetchData('doa/doa-liked');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> searchDoa(String query) async {
    try {
      final response = await _apiService.fetchData('doa/search?q=$query');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> likeDoa(int id, bool like) async {
    try {
      final response = await _apiService.postData('doa/$id/like', {
        'like': like,
      });
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
