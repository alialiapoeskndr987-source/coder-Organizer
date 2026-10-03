import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';

import '../../core/constants/app_constants.dart';
import '../../core/models/enums.dart';
import '../db/app_database.dart';

/// JSON export/import via SAF (FR-02) — gzipped JSON; import shows a preview
/// with per-type counts and applies the chosen strategy (replace/merge).
class ImportExportService {
  final AppDatabase _db;
  ImportExportService(this._db);

  /// Returns null when the user cancels the save dialog.
  Future<bool> exportToFile() async {
    final data = await _db.backupDao.exportJson();
    final jsonStr = const JsonEncoder.withIndent('  ').convert(data);
    final gzBytes = Uint8List.fromList(gzip.encode(utf8.encode(jsonStr)));
    final stamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final path = await FilePicker.platform.saveFile(
      fileName:
          '${AppConstants.exportFilePrefix}-$stamp.json.gz',
      bytes: gzBytes,
      type: FileType.custom,
      allowedExtensions: ['gz'],
    );
    return path != null; // on Android SAF the bytes are written directly
  }

  Future<({Map<String, dynamic> data, Map<String, int> counts})?>
      pickAndDecode() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['gz', 'json'],
      withData: true,
    );
    final bytes = result?.files.single.bytes;
    if (bytes == null) return null;

    String jsonStr;
    try {
      jsonStr = utf8.decode(gzip.decode(bytes));
    } catch (_) {
      jsonStr = utf8.decode(bytes, allowMalformed: false);
    }
    final data = jsonDecode(jsonStr) as Map<String, dynamic>;
    final counts = <String, int>{
      for (final k in const [
        'nodes', 'links', 'notes', 'emails',
        'subscriptions', 'platforms', 'variables', 'alerts',
      ])
        k: (data[k] as List?)?.length ?? 0,
    };
    return (data: data, counts: counts);
  }

  Future<void> applyImport(
    Map<String, dynamic> data,
    ImportStrategy strategy,
  ) =>
      _db.backupDao.importJson(data, strategy);
}
