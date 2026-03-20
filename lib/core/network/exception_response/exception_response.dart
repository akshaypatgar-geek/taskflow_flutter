import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'exception_response.freezed.dart';
part 'exception_response.g.dart';

@freezed
sealed class ExceptionResponse with _$ExceptionResponse{
  const factory ExceptionResponse({
    required int statusCode,
    @JsonKey(name: 'Message') required String errorMessage
  }) = _ExceptionResponse;
  factory ExceptionResponse.fromJson(Map<String, dynamic> json) => _$ExceptionResponseFromJson(json);
}