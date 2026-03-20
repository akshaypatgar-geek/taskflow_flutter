import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskflowapp/core/network/exception_response/exception_response.dart';
import 'package:taskflowapp/core/utils/constants.dart';

import '../auth_interceptor.dart';
import 'exceptions.dart';

class DioClient {
  late final Dio dio;
  final FlutterSecureStorage storage;

   DioClient({
    required this.storage
   }) {
     dio = Dio(BaseOptions(
      baseUrl: dotenv.get('BASE_URL'),
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    dio.interceptors.add(AuthInterceptor(storage: storage, dio: dio));
  }

  // DioClient._internal() {
  //   dio = Dio(BaseOptions(
  //     baseUrl: dotenv.get('BASE_URL'),
  //     connectTimeout: const Duration(seconds: 10),
  //     receiveTimeout: const Duration(seconds: 10),
  //     headers: {
  //       'Content-Type': 'application/json',
  //     },
  //   ));
  //   dio.interceptors.add(AuthInterceptor(storage: storage, dio: dio));
  // }

  dynamic _handleError(DioException e) {
  
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
          
      throw const NetworkException(AppStrings.connectionError);
    }

    int statusCode = e.response?.statusCode??500;
    String errorMessage = AppStrings.somethingWentWrong;
    if (e.response?.data != null) {
      try {
        final errorDTO = ExceptionResponse.fromJson(e.response?.data);
        statusCode = errorDTO.statusCode;
        errorMessage = errorDTO.errorMessage;
      } catch (_) {
        statusCode = 500;
        errorMessage = AppStrings.somethingWrongTryAgainLater;
      }
      
    }
    
    if (statusCode == 404) {
      throw NotFoundException(errorMessage);
    } else

    if (statusCode == 409) {
      throw ExistsException(errorMessage);
    } else if(statusCode == 401) {
      throw UnauthorizedException(errorMessage);
    }

    throw ServerException(errorMessage);
  }

  Future<T?> postRequest<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      final response = await dio.post(endpoint, data: body, options: options);
      return response.data as T?;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T?> getRequest<T>({
    required String endpoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(endpoint, queryParameters: queryParams);
      return response.data as T?;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T?> patchRequest<T>({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    try {
      final response = await dio.patch(endpoint, data: body);
      return response.data as T?;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }

  Future<T?> deleteRequest<T>({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.delete(
        endpoint,
        data: body,
        queryParameters: queryParams,
      );
      return response.data as T?;
    } on DioException catch (e) {
      throw _handleError(e);
    }
  }
}