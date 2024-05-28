import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ChatProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Quick Chat
  Future<Map<String, dynamic>> quickChat(String message) async {
    try {
      final response = await _apiService.postData('chat', {'message': message});
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Get Chat Sessions
  Future<Map<String, dynamic>> getChatSession(id) async {
    try {
      final response = await _apiService.fetchData('chat/session/$id');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Send Message in Chat Session
  Future<Map<String, dynamic>> sendMessage(
      String message, String sessionId) async {
    try {
      final response = await _apiService
          .postData('chat/session/$sessionId/schat', {'message': message});
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Get Chat Session Title
  Future<Map<String, dynamic>> getChatSessionTitle(String sessionId) async {
    try {
      final response =
          await _apiService.fetchData('chat/session/$sessionId/get-title');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Get Chat Sessions
  Future<Map<String, dynamic>> getChatSessions() async {
    try {
      final response = await _apiService.fetchData('chat/sessions');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Session Create
  Future<Map<String, dynamic>> createSession(String title) async {
    try {
      final response =
          await _apiService.postData('chat/session/create', {'title': title});
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
