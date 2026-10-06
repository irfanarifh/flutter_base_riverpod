import 'package:flutter/foundation.dart' show kReleaseMode;

enum Flavor {
  dev,
  staging,
  prod;

  /// Resolves the active [Flavor] from Flutter's native `appFlavor` value.
  ///
  /// - When [value] is null and [isRelease] is false: defaults to [Flavor.dev].
  /// - When [value] is null and [isRelease] is true: throws a [StateError].
  /// - When [value] matches a [Flavor] name: returns the corresponding [Flavor].
  /// - When [value] does not match any [Flavor] name: throws a [StateError].
  static Flavor fromAppFlavor(
    String? value, {
    bool isRelease = kReleaseMode,
  }) {
    if (value == null) {
      if (isRelease) {
        throw StateError(
          'Release build without --flavor. Use: flutter build <target> --flavor prod',
        );
      }
      return Flavor.dev;
    }

    final normalized = value.trim().toLowerCase();
    for (final flavor in Flavor.values) {
      if (flavor.name == normalized) {
        return flavor;
      }
    }

    final validNames = Flavor.values.map((f) => f.name).join(', ');
    throw StateError(
      'Invalid flavor: "$value". Valid flavor names are: $validNames.',
    );
  }

  String get envFileName => switch (this) {
        Flavor.dev => '.env.dev',
        Flavor.staging => '.env.staging',
        Flavor.prod => '.env.prod',
      };

  bool get isDev => this == Flavor.dev;
  bool get isStaging => this == Flavor.staging;
  bool get isProd => this == Flavor.prod;
}
