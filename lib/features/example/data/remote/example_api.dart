import 'package:dio/dio.dart';
import 'package:flutter_template/core/network/api_unwrap.dart';
import 'package:flutter_template/features/example/model/example_item.dart';

/// Minimal remote REST API client for the example feature.
///
/// NOTE: This remote API is optional and unused by default in this offline-first
/// sample. It demonstrates how a remote REST data source can be wired alongside
/// Drift when migrating to or integrating with a backend server.
class ExampleApi {
  const ExampleApi(this._dio);

  final Dio _dio;

  /// Fetches all items from the remote server endpoint.
  ///
  /// Response shape: `{code, message, data: [ ... ]}`.
  Future<List<ExampleItemDto>> fetchAll() async {
    final response = await _dio.get<Map<String, dynamic>>('/examples');
    return response.unwrap(
      (json) => (json! as List<dynamic>).map((e) => ExampleItemDto.fromJson(e as Map<String, dynamic>)).toList(),
    );
  }
}
