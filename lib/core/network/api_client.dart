import 'package:dio/dio.dart';

class ApiClient {
  ApiClient._();

  static Dio createDio() {
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://catfact.ninja',
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        sendTimeout: const Duration(seconds: 10),
      ),
    );

    return dio;
  }
}
