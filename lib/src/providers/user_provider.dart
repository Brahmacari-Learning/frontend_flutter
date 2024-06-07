import 'package:flutter/material.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  Map<String, dynamic> _user = {};

  Map<String, dynamic> get user => _user;

  // Get user info
  Future<Map<String, dynamic>> getInfo() async {
    try {
      final response = await _apiService.fetchData('user');
      _user = response['user'];
      notifyListeners();
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Get Profile Picture
  Future<Map<String, dynamic>> getProfilePicture() async {
    try {
      final response = await _apiService.fetchData('user/profile-picture');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Update Profile Picture
  Future<Map<String, dynamic>> updateProfilePicture(String image) async {
    try {
      final response = await _apiService.postData('user/profile-picture', {
        'image': image,
      });
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
