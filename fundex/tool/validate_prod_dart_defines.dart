import 'dart:convert';
import 'dart:io';

void main(List<String> args) {
  final targetPath = args.isNotEmpty
      ? args.first
      : '.vscode/dart_define.prod.local.json';
  final file = File(targetPath);

  if (!file.existsSync()) {
    stderr.writeln('Prod dart-define file not found: $targetPath');
    exitCode = 1;
    return;
  }

  final raw = file.readAsStringSync().trim();
  if (raw.isEmpty) {
    stderr.writeln('Prod dart-define file is empty: $targetPath');
    exitCode = 1;
    return;
  }

  final decoded = jsonDecode(raw);
  if (decoded is! Map) {
    stderr.writeln('Prod dart-define file must be a JSON object: $targetPath');
    exitCode = 1;
    return;
  }

  final values = decoded.map(
    (key, value) => MapEntry(key.toString(), value?.toString().trim() ?? ''),
  );

  _requireEnabled(values, key: 'ENABLE_IDENTITY_AUTH');
}

void _requireEnabled(Map<String, String> values, {required String key}) {
  final value = values[key]?.toLowerCase();
  if (value == 'true') {
    stdout.writeln('$key=true');
    return;
  }

  stderr.writeln(
    'Production build requires "$key" to be explicitly set to "true".',
  );
  exitCode = 1;
}
