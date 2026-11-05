// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_form_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Scoped controller managing transient form submission state for add, edit, and delete operations.

@ProviderFor(ExampleFormController)
final exampleFormControllerProvider = ExampleFormControllerProvider._();

/// Scoped controller managing transient form submission state for add, edit, and delete operations.
final class ExampleFormControllerProvider
    extends $AsyncNotifierProvider<ExampleFormController, void> {
  /// Scoped controller managing transient form submission state for add, edit, and delete operations.
  ExampleFormControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'exampleFormControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$exampleFormControllerHash();

  @$internal
  @override
  ExampleFormController create() => ExampleFormController();
}

String _$exampleFormControllerHash() =>
    r'd15e71a5f17272f17d03d2062b040d3c5e7ea64d';

/// Scoped controller managing transient form submission state for add, edit, and delete operations.

abstract class _$ExampleFormController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, build);
  }
}
