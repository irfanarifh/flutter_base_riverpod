import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/core/config/env.dart';
import 'package:flutter_template/core/network/interceptors/auth_interceptor.dart';
import 'package:flutter_template/core/network/interceptors/error_interceptor.dart';
import 'package:flutter_template/core/network/interceptors/logging_interceptor.dart';
import 'package:flutter_template/core/services/logger_service.dart';
import 'package:flutter_template/core/services/storage_service.dart';

class SessionExpiredNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void increment() => state++;
}

final sessionExpiredProvider =
    NotifierProvider<SessionExpiredNotifier, int>(SessionExpiredNotifier.new);

final dioProvider = Provider<Dio>((ref) {
  final options = BaseOptions(
    baseUrl: Env.baseUrl,
    connectTimeout: Env.connectTimeout,
    receiveTimeout: Env.connectTimeout,
    sendTimeout: Env.connectTimeout,
    headers: const <String, dynamic>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  final dio = Dio(options);
  final storageService = ref.watch(storageServiceProvider);
  final loggerService = ref.watch(loggerServiceProvider);

  dio.interceptors.addAll([
    AuthInterceptor(
      storageService: storageService,
      ref: ref,
    ),
    LoggingInterceptor(loggerService),
    ErrorInterceptor(),
  ]);

  return dio;
});
