// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example_detail_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Family controller managing the asynchronous state of a single example item by its [id].

@ProviderFor(ExampleDetailController)
final exampleDetailControllerProvider = ExampleDetailControllerFamily._();

/// Family controller managing the asynchronous state of a single example item by its [id].
final class ExampleDetailControllerProvider
    extends $AsyncNotifierProvider<ExampleDetailController, ExampleItem?> {
  /// Family controller managing the asynchronous state of a single example item by its [id].
  ExampleDetailControllerProvider._({
    required ExampleDetailControllerFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'exampleDetailControllerProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$exampleDetailControllerHash();

  @override
  String toString() {
    return r'exampleDetailControllerProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  ExampleDetailController create() => ExampleDetailController();

  @override
  bool operator ==(Object other) {
    return other is ExampleDetailControllerProvider &&
        other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$exampleDetailControllerHash() =>
    r'c12371b1af722a7c2efb16f27bd5c2c38d3fedd5';

/// Family controller managing the asynchronous state of a single example item by its [id].

final class ExampleDetailControllerFamily extends $Family
    with
        $ClassFamilyOverride<
          ExampleDetailController,
          AsyncValue<ExampleItem?>,
          ExampleItem?,
          FutureOr<ExampleItem?>,
          int
        > {
  ExampleDetailControllerFamily._()
    : super(
        retry: null,
        name: r'exampleDetailControllerProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Family controller managing the asynchronous state of a single example item by its [id].

  ExampleDetailControllerProvider call(int id) =>
      ExampleDetailControllerProvider._(argument: id, from: this);

  @override
  String toString() => r'exampleDetailControllerProvider';
}

/// Family controller managing the asynchronous state of a single example item by its [id].

abstract class _$ExampleDetailController extends $AsyncNotifier<ExampleItem?> {
  late final _$args = ref.$arg as int;
  int get id => _$args;

  FutureOr<ExampleItem?> build(int id);
  @$mustCallSuper
  @override
  void runBuild() {
    final ref = this.ref as $Ref<AsyncValue<ExampleItem?>, ExampleItem?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ExampleItem?>, ExampleItem?>,
              AsyncValue<ExampleItem?>,
              Object?,
              Object?
            >;
    element.handleCreate(ref, () => build(_$args));
  }
}
