import 'package:flutter/material.dart';
import 'package:vedanta_frontend/src/services/api_service.dart';

class StageProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();

  // get all stages
  Future<Map<String, dynamic>> getStages() async {
    try {
      final response = await _apiService.fetchData('stage');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> getStage(int id) async {
    try {
      final response = await _apiService.fetchData('stage/$id');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> getNextEntry(int idQuiz) async {
    try {
      final response = await _apiService.fetchData('quiz/$idQuiz');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> quizEntryInfo(int idQuiz, int idEntry) async {
    try {
      final response = await _apiService.fetchData('quiz/$idQuiz/$idEntry');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> getMateri(int idStage) async {
    try {
      final response = await _apiService.fetchData('stage/$idStage/materi');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> answerEntry(
    int idQuiz,
    int idEntry,
    String answer,
  ) async {
    try {
      final response = await _apiService.postData(
        'quiz/$idQuiz/$idEntry/answer',
        {
          "answer": answer,
        },
      );
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> info(int idQuiz) async {
    try {
      final response = await _apiService.fetchData('quiz/$idQuiz');
      print(response);
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> restartQuiz(int idQuiz) async {
    try {
      final response = await _apiService.fetchData('quiz/$idQuiz/restart');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }

  Future<Map<String, dynamic>> claimReward(int idStage) async {
    try {
      final response =
          await _apiService.fetchData('stage/$idStage/claim-hadiah');
      return response;
    } catch (e) {
      return {'error': true, 'message': 'An error occurred'};
    }
  }
}
