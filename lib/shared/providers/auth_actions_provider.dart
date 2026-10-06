import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Contract providing a router-free logout action to decoupled features (e.g., settings).
final logoutActionProvider = Provider<Future<void> Function()>((ref) {
  throw UnimplementedError('logoutActionProvider must be overridden or wired.');
});
