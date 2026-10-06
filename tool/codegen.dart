// ignore_for_file: avoid_print

import 'dart:io';

/// Cross-platform Dart script for code generation.
/// Usage: `dart run tool/codegen.dart`
Future<void> main() async {
  print('==> [1/3] Resolving Flutter dependencies...');
  await _runCommand('flutter', ['pub', 'get']);

  print('\n==> [2/3] Running build_runner code generation...');
  await _runCommand('dart', ['run', 'build_runner', 'build', '-d']);

  print('\n==> [3/3] Generating application localizations...');
  await _runCommand('flutter', ['gen-l10n']);

  print('\n==> Code generation completed successfully!');
}

Future<void> _runCommand(String executable, List<String> arguments) async {
  final process = await Process.start(
    executable,
    arguments,
    mode: ProcessStartMode.inheritStdio,
    runInShell: true,
  );

  final exitCode = await process.exitCode;
  if (exitCode != 0) {
    stderr.writeln('Error: Command "$executable ${arguments.join(' ')}" failed with exit code $exitCode');
    exit(exitCode);
  }
}
