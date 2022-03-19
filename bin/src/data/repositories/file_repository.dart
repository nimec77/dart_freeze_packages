import 'dart:io';

import '../../domain/adapters/file_adapter.dart';
import '../mappers/yaml_mapper.dart';

class FileRepository implements FileAdapter {
  final YamlMapper yamlMapper;

  const FileRepository({required this.yamlMapper});

  @override
  String loadFileAsString(String path) {
    return File(path).readAsStringSync();
  }

  @override
  void saveFileAsString(String path, Map<String, dynamic> contents) {
    File(path).writeAsStringSync(yamlMapper.yamlToString(contents));
  }
}
