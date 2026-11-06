import 'package:flutter_template/core/network/api_manager.dart';
import 'package:flutter_template/features/example/model/example_item.dart';

/// Optional remote REST API client for the example feature.
class ExampleApi {
  const ExampleApi(this._apiManager);

  final ApiManager _apiManager;

  /// Fetches all items from the remote server endpoint (`/examples`).
  Future<List<ExampleItemDto>> fetchAll() {
    return _apiManager.get<List<ExampleItemDto>>(
      '/examples',
      fromJson: (json) => (json! as List<dynamic>)
          .map((e) => ExampleItemDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }
}
