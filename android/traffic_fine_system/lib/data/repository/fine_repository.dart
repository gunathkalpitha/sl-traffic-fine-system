// lib/data/repository/fine_repository.dart
import 'package:dio/dio.dart';
import '../model/fine.dart';
import '../network/api_service.dart';

class FineRepository {
  final ApiService _apiService;

  FineRepository(this._apiService);

  Future<Fine> getFineDetails({
    required String referenceNumber,
    required String categoryId,
  }) async {
    try {
      return await _apiService.getFineDetails(referenceNumber, categoryId);
    } on DioException catch (e) {
      switch (e.response?.statusCode) {
        case 404:
          throw Exception('Fine not found. Check the reference number and category.');
        case 400:
          throw Exception('Invalid fine details provided.');
        default:
          throw Exception('Failed to retrieve fine details. Try again.');
      }
    }
  }
}
