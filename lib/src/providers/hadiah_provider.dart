import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/services/api_service.dart';

class HadiahProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, dynamic> _lencana = {};

  Map<String, dynamic> get lencana => _lencana;

  Map<String, dynamic> _hadiah = {};

  Map<String, dynamic> get hadiah => _hadiah;

  // Fetch gift data
  Future<Map<String, dynamic>> getHadiah() async {
    try {
      final response = await _apiService.fetchData('gift');
      _hadiah = response;
      notifyListeners();
      return response;
    } catch (e) {
      // Log error or handle it specifically if needed
      print("Error fetching gift data: $e");
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Fetch badge data
  Future<Map<String, dynamic>> getLencana() async {
    try {
      final response = await _apiService.fetchData('missions/badges');
      _lencana = response;
      notifyListeners();
      return response;
    } catch (e) {
      // Log error or handle it specifically if needed
      print("Error fetching badge data: $e");
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Claim badge
  Future<Map<String, dynamic>> lencanaClaim(int id) async {
    try {
      final response = await _apiService.fetchData('missions/badges/$id/claim');
      // Refetch the badge data after claiming
      await getLencana();
      return response;
    } catch (e) {
      // Log error or handle it specifically if needed
      print("Error claiming badge: $e");
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> giftClaim(int id) async {
    try {
      final response = await _apiService.fetchData('gift/$id/tukar');
      await getHadiah();
      print(response);
      return response;
    } catch (e) {
      print("Error claiming gift: $e");
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
