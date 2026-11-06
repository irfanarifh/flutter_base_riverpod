// ignore_for_file: avoid_print

import 'dart:io';

/// Cross-platform Dart script for full project synchronization and validation.
/// Runs clean, pub get, codegen, analyze, and test in sequence.
/// Usage: `dart run tool/sync.dart [--skip-tests]`
Future<void> main(List<String> args) async {
  final skipTests = args.contains('--skip-tests');

  print('=================================================================');
  print('               Project Synchronization & Validation              ');
  print('=================================================================');

  final steps = <(String title, String executable, List<String> arguments)>[
    ('[1/5] Cleaning build artifacts and cache...', 'flutter', ['clean']),
    ('[2/5] Fetching package dependencies...', 'flutter', ['pub', 'get']),
    ('[3/5] Running code generation (Drift, Freezed, L10n)...', 'dart', ['run', 'tool/codegen.dart']),
    ('[4/5] Analyzing project code for issues...', 'flutter', ['analyze']),
    if (!skipTests)
      ('[5/5] Running unit and widget test suite...', 'flutter', ['test']),
  ];

  final stopwatch = Stopwatch()..start();

  for (var i = 0; i < steps.length; i++) {
    final (title, exe, cmdArgs) = steps[i];
    print('\n==> $title');
    print('\$ $exe ${cmdArgs.join(' ')}');
    await _runCommand(exe, cmdArgs);
  }

  stopwatch.stop();
  final elapsed = (stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1);

  print('\n=================================================================');
  print('Project synchronization completed successfully in ${elapsed}s!');
  print('=================================================================');
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
    stderr.writeln('\nError: Step failed with exit code $exitCode ($executable ${arguments.join(' ')})');
    exit(exitCode);
  }
}

