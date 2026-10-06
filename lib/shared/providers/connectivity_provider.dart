import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provides a real-time stream of internet connectivity status.
///
/// Yields `true` when at least one active network interface is connected,
/// and `false` when offline.
final connectivityProvider = StreamProvider<bool>((ref) {
  return Connectivity()
      .onConnectivityChanged
      .map((results) => results.any((result) => result != ConnectivityResult.none))
      .distinct();
});
