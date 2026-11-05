import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

/// Immutable user entity representing an authenticated session.
@freezed
abstract class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? name,
  }) = _User;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}
