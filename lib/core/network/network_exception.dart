import 'package:dio/dio.dart';

class NetworkException implements Exception {
  const NetworkException(this.message);

  final String message;

  factory NetworkException.fromDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return const NetworkException('La conexión tardó demasiado. Intenta de nuevo.');
      case DioExceptionType.badResponse:
        return NetworkException(
          'Error del servidor (${exception.response?.statusCode ?? 'desconocido'}).',
        );
      case DioExceptionType.connectionError:
        return const NetworkException('Sin conexión a internet. Revisa tu red.');
      case DioExceptionType.cancel:
        return const NetworkException('La solicitud fue cancelada.');
      case DioExceptionType.badCertificate:
      case DioExceptionType.unknown:
        return const NetworkException('Ocurrió un error inesperado. Intenta de nuevo.');
    }
  }

  @override
  String toString() => message;
}
