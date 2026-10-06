// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_list_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exampleSearchQueryHash() =>
    r'4816fd940768bd2a2bffb7c7f7bdd48a45819272';

/// Scoped provider holding the active search filter string for the example list.
///
/// Copied from [ExampleSearchQuery].
@ProviderFor(ExampleSearchQuery)
final exampleSearchQueryProvider =
    AutoDisposeNotifierProvider<ExampleSearchQuery, String>.internal(
  ExampleSearchQuery.new,
  name: r'exampleSearchQueryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exampleSearchQueryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExampleSearchQuery = AutoDisposeNotifier<String>;
String _$exampleListControllerHash() =>
    r'dd46287d310fa1605100f1a96b8db51a0df8a916';

/// Reactive stream controller observing example items filtered by search query.
///
/// Copied from [ExampleListController].
@ProviderFor(ExampleListController)
final exampleListControllerProvider = AutoDisposeStreamNotifierProvider<
    ExampleListController, List<ExampleItem>>.internal(
  ExampleListController.new,
  name: r'exampleListControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exampleListControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ExampleListController = AutoDisposeStreamNotifier<List<ExampleItem>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
