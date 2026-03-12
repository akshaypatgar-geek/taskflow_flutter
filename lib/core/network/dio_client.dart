import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:taskflowapp/core/network/exception_response/exception_response.dart';

import '../auth_interceptor.dart';
import 'exceptions.dart';

class DioClient {
  static const baseUrl = 
  // "http://10.153.0.98:3000"; 
  "http://192.168.29.140:3000";//"http://localhost:3000";
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;
  final FlutterSecureStorage storage = const FlutterSecureStorage();

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      headers: {
        'Content-Type': 'application/json',
      },
    ));
    dio.interceptors.add(AuthInterceptor(storage: storage, dio: dio));
    // dio.interceptors.add(LogInterceptor(
    //   request: true,
    //   requestBody: true,
    //   responseBody: true,
    //   responseHeader: false,
    //   requestHeader: false,
    // ));
  }

  dynamic _handleError(DioException e) {
  
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.connectionError) {
          
      throw NetworkException("Connection error. Please try again.");
    }

    int statusCode = e.response?.statusCode??500;
    String errorMessage="Something Went wrong";
    if(e.response?.data !=null) {
      try {
        final errorDTO = ExceptionResponse.fromJson(e.response?.data);
      statusCode = errorDTO.statusCode;
      errorMessage = errorDTO.errorMessage;
      } catch(e) {
        statusCode = 500;
        errorMessage = "Something wrong. Please try again later";
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

  Future<dynamic> postRequest({
    required String endpoint,
    Map<String, dynamic>? body,
    Options? options,
  }) async {
    try {
      
      var response = await dio.post(endpoint, data: jsonEncode(body),options: options);
      return response.data;
    } on DioException catch (e) {
      // _handleError throws specific exceptions. This exception will propagate out of postRequest.
      throw _handleError(e);
    }
  }

  // GET
  Future<dynamic> getRequest({
    required String endpoint,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.get(endpoint, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // PATCH
  Future<dynamic> patchRequest({
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    
    try {
      final response = await dio.patch(endpoint, data: body);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }

  // DELETE
  Future<dynamic> deleteRequest({
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParams,
  }) async {
    try {
      final response = await dio.delete(endpoint,
      
       data: body, queryParameters: queryParams);
      return response.data;
    } on DioException catch (e) {
      _handleError(e);
    }
  }
}