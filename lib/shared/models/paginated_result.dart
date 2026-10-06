import 'package:freezed_annotation/freezed_annotation.dart';

part 'paginated_result.freezed.dart';

/// Generic immutable model representing a paginated collection of items.
@Freezed(genericArgumentFactories: true)
class PaginatedResult<T> with _$PaginatedResult<T> {
  const factory PaginatedResult({
    required List<T> items,
    required int totalCount,
    required int page,
    required bool hasMore,
  }) = _PaginatedResult<T>;
}
