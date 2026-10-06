// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleDetailControllerHash() =>
    r'cee4f5d8d85ef97385ea1926f6367c40d87e984b';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$ExampleDetailController
    extends BuildlessAutoDisposeAsyncNotifier<ExampleItem?> {
  late final int id;

  FutureOr<ExampleItem?> build(
    int id,
  );
}

/// Family controller managing the asynchronous state of a single example item by its [id].
///
/// Copied from [ExampleDetailController].
@ProviderFor(ExampleDetailController)
const exampleDetailControllerProvider = ExampleDetailControllerFamily();

/// Family controller managing the asynchronous state of a single example item by its [id].
///
/// Copied from [ExampleDetailController].
class ExampleDetailControllerFamily extends Family<AsyncValue<ExampleItem?>> {
  /// Family controller managing the asynchronous state of a single example item by its [id].
  ///
  /// Copied from [ExampleDetailController].
  const ExampleDetailControllerFamily();

  /// Family controller managing the asynchronous state of a single example item by its [id].
  ///
  /// Copied from [ExampleDetailController].
  ExampleDetailControllerProvider call(
    int id,
  ) {
    return ExampleDetailControllerProvider(
      id,
    );
  }

  @override
  ExampleDetailControllerProvider getProviderOverride(
    covariant ExampleDetailControllerProvider provider,
  ) {
    return call(
      provider.id,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'exampleDetailControllerProvider';
}

/// Family controller managing the asynchronous state of a single example item by its [id].
///
/// Copied from [ExampleDetailController].
class ExampleDetailControllerProvider
    extends AutoDisposeAsyncNotifierProviderImpl<ExampleDetailController,
        ExampleItem?> {
  /// Family controller managing the asynchronous state of a single example item by its [id].
  ///
  /// Copied from [ExampleDetailController].
  ExampleDetailControllerProvider(
    int id,
  ) : this._internal(
          () => ExampleDetailController()..id = id,
          from: exampleDetailControllerProvider,
          name: r'exampleDetailControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$exampleDetailControllerHash,
          dependencies: ExampleDetailControllerFamily._dependencies,
          allTransitiveDependencies:
              ExampleDetailControllerFamily._allTransitiveDependencies,
          id: id,
        );

  ExampleDetailControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.id,
  }) : super.internal();

  final int id;

  @override
  FutureOr<ExampleItem?> runNotifierBuild(
    covariant ExampleDetailController notifier,
  ) {
    return notifier.build(
      id,
    );
  }

  @override
  Override overrideWith(ExampleDetailController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ExampleDetailControllerProvider._internal(
        () => create()..id = id,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        id: id,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<ExampleDetailController, ExampleItem?>
      createElement() {
    return _ExampleDetailControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ExampleDetailControllerProvider && other.id == id;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, id.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin ExampleDetailControllerRef
    on AutoDisposeAsyncNotifierProviderRef<ExampleItem?> {
  /// The parameter `id` of this provider.
  int get id;
}

class _ExampleDetailControllerProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<ExampleDetailController,
        ExampleItem?> with ExampleDetailControllerRef {
  _ExampleDetailControllerProviderElement(super.provider);

  @override
  int get id => (origin as ExampleDetailControllerProvider).id;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
