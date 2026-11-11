import 'package:dio/dio.dart';

import '../../core/constants/app_constants.dart';

class ApiService {
  ApiService._();

  static final ApiService instance = ApiService._();

  late final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConstants.baseUrl,
      connectTimeout: const Duration(seconds: 15),
      receiveTimeout: const Duration(seconds: 15),
      sendTimeout: const Duration(seconds: 15),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ),
  );

  Future<dynamic> get(
    String endpoint, {
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await _dio.get(
        endpoint,
        queryParameters: queryParameters,
      );

      return response.data;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<dynamic> post(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.post(endpoint, data: data);
      return response.data;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<dynamic> put(String endpoint, {dynamic data}) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return response.data;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  Future<dynamic> delete(String endpoint) async {
    try {
      final response = await _dio.delete(endpoint);
      return response.data;
    } on DioException catch (error) {
      throw _handleError(error);
    }
  }

  String _handleError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return 'Connection timed out. Please try again.';

      case DioExceptionType.connectionError:
        return 'No internet connection. Please check your network.';

      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;

        if (statusCode == 400) {
          return 'Invalid request. Please try again.';
        }

        if (statusCode == 401 || statusCode == 403) {
          return 'You are not authorized to access this information.';
        }

        if (statusCode == 404) {
          return 'The requested information was not found.';
        }

        if (statusCode == 429) {
          return 'Too many requests. Please try again later.';
        }

        if (statusCode != null && statusCode >= 500) {
          return 'Server error. Please try again later.';
        }

        return 'Unable to process your request.';

      case DioExceptionType.cancel:
        return 'The request was cancelled.';

      case DioExceptionType.badCertificate:
        return 'A secure connection could not be established.';

      case DioExceptionType.unknown:
        return 'Something went wrong. Please try again.';
    }
  }
}
