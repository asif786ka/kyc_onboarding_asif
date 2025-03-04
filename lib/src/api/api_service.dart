import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/kyc_user_model.dart';

class KYCApiService {
  final Dio _dio;
  final String region;

  KYCApiService({required this.region}) : _dio = Dio() {
    _dio.options.baseUrl = _getBaseUrlForRegion(region);
    _dio.interceptors.add(LogInterceptor(
      requestBody: kDebugMode,
      responseBody: kDebugMode,
    ));
  }

  String _getBaseUrlForRegion(String region) {
    switch (region.toUpperCase()) {
      case 'US':
        return 'https://api.us-kyc.com';
      case 'EU':
        return 'https://api.eu-kyc.com';
      case 'UK':
        return 'https://api.uk-kyc.com';
      case 'AE':
        return 'https://api.ae-kyc.com';
      default:
        throw Exception('Unsupported region: $region');
    }
  }

  Future<KYCUser> createKYCUser(KYCUser user) async {
    try {
      final response = await _dio.post('/users', data: user.toJson());
      return KYCUser.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<KYCUser> updateKYCUser(String userId, KYCUser user) async {
    try {
      final response = await _dio.put('/users/$userId', data: user.toJson());
      return KYCUser.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<KYCUser> getKYCUser(String userId) async {
    try {
      final response = await _dio.get('/users/$userId');
      return KYCUser.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<String> uploadDocument(
      String userId, String documentType, List<int> fileBytes) async {
    try {
      final formData = FormData.fromMap({
        'file': MultipartFile.fromBytes(fileBytes,
            filename: 'document.$documentType'),
        'documentType': documentType,
      });

      final response =
          await _dio.post('/users/$userId/documents', data: formData);
      return response.data['documentId'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return Exception(
              'Connection timeout. Please check your internet connection.');
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final message =
              error.response?.data['message'] ?? 'Unknown error occurred';
          return Exception('Server error ($statusCode): $message');
        default:
          return Exception('Network error occurred: ${error.message}');
      }
    }
    return Exception('An unexpected error occurred');
  }
}
