import 'dart:io';

import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ClassProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // Get classes
  Future<Map<String, dynamic>> getClasses() async {
    try {
      final response = await _apiService.fetchData('class');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Join Class
  Future<Map<String, dynamic>> joinClass(String code) async {
    try {
      final response = await _apiService.postData('class/join', {
        'classCode': code,
      });
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  // Class Member
  Future<Map<String, dynamic>> classMember(int id) async {
    try {
      final response = await _apiService.fetchData('class/$id/members');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> allTugas(int kelasId) async {
    try {
      final response = await _apiService.fetchData('class/$kelasId/tasks');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> quizResult(int classId, int idQuiz) async {
    try {
      final response =
          await _apiService.fetchData('class/$classId/tasks/quiz/$idQuiz');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> detailTugasDoa(int classId, int idTugas) async {
    try {
      final response = await _apiService.fetchData(
        'class/$classId/tasks/doa/$idTugas',
      );
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> uploadTugasDoa(
      int classId, int idTugas, String pathAudio, String pathImage) async {
    try {
      final response = await _apiService.postData(
        'class/$classId/tasks/doa/$idTugas/send',
        {
          'audioPath': pathAudio,
          'imagePath': pathImage,
        },
      );
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
