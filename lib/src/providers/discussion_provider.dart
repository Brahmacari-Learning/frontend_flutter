import 'package:flutter/material.dart';
import '../services/api_service.dart';

class DiscussionProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Get discussions
  Future<Map<String, dynamic>> getDiscussions(page) async {
    try {
      final response = await _apiService.fetchData('discussion?page=$page');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Get discussion
  Future<Map<String, dynamic>> getDiscussion(int id) async {
    try {
      final response = await _apiService.fetchData('discussion/$id');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Create discussion
  Future<Map<String, dynamic>> createDiscussion(
      String title, String body) async {
    try {
      final response = await _apiService.postData('discussion/create', {
        'title': title,
        'body': body,
      });
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Update discussion
  Future<Map<String, dynamic>> updateDiscussion(
      int id, Map<String, dynamic> data) async {
    try {
      final response = await _apiService.postData('discussion/$id/edit', data);
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Create reply
  Future<Map<String, dynamic>> createReply(int discussionId, reply) async {
    try {
      final response =
          await _apiService.postData('discussion/$discussionId/reply', {
        'reply': reply,
      });
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Create reply to reply
  Future<Map<String, dynamic>> createReplyToReply(
      int discussionId, int replyId, reply) async {
    try {
      final response = await _apiService
          .postData('discussion/$discussionId/reply/$replyId/reply', {
        'reply': reply,
      });
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Delete discussion
  Future<Map<String, dynamic>> deleteDiscussion(int id) async {
    try {
      final response = await _apiService.deleteData('discussion/$id/delete');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Search discussion
  Future<Map<String, dynamic>> searchDiscussion(String query) async {
    try {
      final response =
          await _apiService.fetchData('discussion/search?q=$query');
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Like discussion
  Future<Map<String, dynamic>> likeDiscussion(int id, bool like) async {
    try {
      final response = await _apiService.postData('discussion/$id/like', {
        'like': like,
      });
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // like reply
  Future<Map<String, dynamic>> likeReply(int disscusionId, int replayId) async {
    try {
      final response = await _apiService
          .postData('discussion/$disscusionId/reply/$replayId/like', {
        'like': true,
      });
      return response;
    } catch (e) {
      print(e);
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
