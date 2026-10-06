// ignore_for_file: avoid_print

import 'dart:io';

/// Cross-platform Dart script for feature scaffolding.
/// Usage: `dart run tool/new_feature.dart <snake_case_name>`
void main(List<String> args) {
  if (args.isEmpty) {
    print('Usage: dart run tool/new_feature.dart <snake_case_name>');
    print('Example: dart run tool/new_feature.dart user_profile');
    exit(1);
  }

  final featureName = args[0].trim();
  final snakeCaseRegex = RegExp(r'^[a-z][a-z0-9_]*$');
  if (!snakeCaseRegex.hasMatch(featureName)) {
    stderr.writeln('Error: Feature name must be in valid snake_case (e.g. user_profile, product_catalog)');
    exit(1);
  }

  final featureDir = Directory('lib/features/$featureName');
  if (featureDir.existsSync()) {
    stderr.writeln('Error: Feature directory already exists at: ${featureDir.path}');
    exit(1);
  }

  // Convert snake_case to PascalCase (e.g. user_profile -> UserProfile)
  final pascalName = featureName
      .split('_')
      .map((part) => part.isEmpty ? '' : '${part[0].toUpperCase()}${part.substring(1)}')
      .join();

  // Convert snake_case to camelCase (e.g. user_profile -> userProfile)
  final camelName = pascalName.isNotEmpty
      ? '${pascalName[0].toLowerCase()}${pascalName.substring(1)}'
      : '';

  print('==> Creating feature directory structure for: $featureName ($pascalName)...');
  Directory('${featureDir.path}/data').createSync(recursive: true);
  Directory('${featureDir.path}/model').createSync(recursive: true);
  Directory('${featureDir.path}/controller').createSync(recursive: true);
  Directory('${featureDir.path}/view/widgets').createSync(recursive: true);

  // 1. Model
  File('${featureDir.path}/model/$featureName.dart').writeAsStringSync('''
import 'package:freezed_annotation/freezed_annotation.dart';

part '$featureName.freezed.dart';
part '$featureName.g.dart';

/// Immutable domain model for [$pascalName].
@freezed
class $pascalName with _\$$pascalName {
  const factory $pascalName({
    required String id,
    required String title,
  }) = _$pascalName;

  factory $pascalName.fromJson(Map<String, dynamic> json) =>
      _\$${pascalName}FromJson(json);
}
''');

  // 2. Repository
  File('${featureDir.path}/data/${featureName}_repository.dart').writeAsStringSync('''
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/features/$featureName/model/$featureName.dart';

/// Exposes the [${pascalName}Repository] instance.
final ${camelName}RepositoryProvider = Provider<${pascalName}Repository>((ref) {
  return ${pascalName}Repository();
});

/// Data repository for [$pascalName].
class ${pascalName}Repository {
  /// Fetches collection of [$pascalName] items.
  Future<List<$pascalName>> fetchAll() async {
    return <$pascalName>[];
  }
}
''');

  // 3. Controller
  File('${featureDir.path}/controller/${featureName}_controller.dart').writeAsStringSync('''
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_template/features/$featureName/data/${featureName}_repository.dart';
import 'package:flutter_template/features/$featureName/model/$featureName.dart';

part '${featureName}_controller.g.dart';

/// Controller managing async state for [$pascalName].
@riverpod
class ${pascalName}Controller extends _\$${pascalName}Controller {
  @override
  FutureOr<List<$pascalName>> build() {
    return ref.watch(${camelName}RepositoryProvider).fetchAll();
  }
}
''');

  // 4. View Screen
  File('${featureDir.path}/view/${featureName}_screen.dart').writeAsStringSync('''
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_template/features/$featureName/controller/${featureName}_controller.dart';
import 'package:flutter_template/shared/widgets/async/async_value_widget.dart';
import 'package:flutter_template/shared/widgets/layout/app_scaffold.dart';

/// Screen presenting [$pascalName] feature.
class ${pascalName}Screen extends ConsumerWidget {
  const ${pascalName}Screen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(${camelName}ControllerProvider);

    return AppScaffold(
      appBar: AppBar(
        title: const Text('$pascalName'),
      ),
      body: AsyncValueWidget(
        value: state,
        data: (items) => ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) => ListTile(
            title: Text(items[index].title),
          ),
        ),
      ),
    );
  }
}
''');

  print('==> Feature scaffolded successfully at: lib/features/$featureName/');
  print('');
  print('Next Steps:');
  print('1. Register the route path and name in: lib/app/router/app_routes.dart');
  print('2. Add the GoRoute entry in: lib/app/router/app_router.dart');
  print('3. Run code generation: dart run tool/codegen.dart');
}
