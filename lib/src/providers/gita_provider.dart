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
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Get Gita bab
  Future<Map<String, dynamic>> getGitaBab(int bab) async {
    try {
      final response = await _apiService.fetchData('gita/bab/$bab');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Get Gita slokas
  Future<Map<String, dynamic>> getGitaSlokas(int bab) async {
    try {
      final response = await _apiService.fetchData('gita/bab/$bab/slokas');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Get Gita sloka
  Future<Map<String, dynamic>> getGitaSloka(int bab, int sloka) async {
    try {
      final response =
          await _apiService.fetchData('gita/bab/$bab/slokas/$sloka');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // pelafalan sloka
  Future<Map<String, dynamic>> getGitaSlokaPelafalan(int bab, int sloka) async {
    try {
      final response =
          await _apiService.fetchData('gita/bab/$bab/slokas/$sloka/pelafalan');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Bacaab terakhir
  Future<Map<String, dynamic>> getBacaanTerakhir() async {
    try {
      final response = await _apiService.fetchData('gita/bacaan-terakhir');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Like sloka
  Future<Map<String, dynamic>> likeSloka(int bab, int sloka) async {
    try {
      final response =
          await _apiService.postData('gita/bab/$bab/slokas/$sloka/like', {
        'like': true,
      });
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Search slokas
  Future<Map<String, dynamic>> searchSlokas(String query) async {
    try {
      final response = await _apiService.fetchData('gita/search?q=$query');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
