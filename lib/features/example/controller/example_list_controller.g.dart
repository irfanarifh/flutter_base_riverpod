// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Scoped provider holding the active search filter string for the example list.

@ProviderFor(ExampleSearchQuery)
final exampleSearchQueryProvider = ExampleSearchQueryProvider._();

/// Scoped provider holding the active search filter string for the example list.
final class ExampleSearchQueryProvider
    extends $NotifierProvider<ExampleSearchQuery, String> {
  /// Scoped provider holding the active search filter string for the example list.
  ExampleSearchQueryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleSearchQueryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleSearchQueryHash();

  @$internal
  @override
  ExampleSearchQuery create() => ExampleSearchQuery();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(String value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<String>(value),
    );
  }
}

String _$exampleSearchQueryHash() =>
    r'4816fd940768bd2a2bffb7c7f7bdd48a45819272';

/// Scoped provider holding the active search filter string for the example list.

abstract class _$ExampleSearchQuery extends $Notifier<String> {
  String build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<String, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<String, String>,
              String,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}

/// Reactive stream controller observing example items filtered by search query.

@ProviderFor(ExampleListController)
final exampleListControllerProvider = ExampleListControllerProvider._();

/// Reactive stream controller observing example items filtered by search query.
final class ExampleListControllerProvider
    extends $StreamNotifierProvider<ExampleListController, List<ExampleItem>> {
  /// Reactive stream controller observing example items filtered by search query.
  ExampleListControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleListControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleListControllerHash();

  @$internal
  @override
  ExampleListController create() => ExampleListController();
}

String _$exampleListControllerHash() =>
    r'dd46287d310fa1605100f1a96b8db51a0df8a916';

/// Reactive stream controller observing example items filtered by search query.

abstract class _$ExampleListController
    extends $StreamNotifier<List<ExampleItem>> {
  Stream<List<ExampleItem>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<ExampleItem>>, List<ExampleItem>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ExampleItem>>, List<ExampleItem>>,
              AsyncValue<List<ExampleItem>>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
