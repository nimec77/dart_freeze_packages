import 'package:yaml/yaml.dart';

import '../../domain/adapters/file_adapter.dart';
import '../../domain/adapters/packages_adapter.dart';

class PackagesRepository implements PackagesAdapter {
  final FileAdapter fileAdapter;

  const PackagesRepository({required this.fileAdapter});

  @override
  YamlMap loadPubspecPackages(String path) {
    final yamlString = fileAdapter.loadFileAsString(path);
    return loadYamlNode(yamlString) as YamlMap;
  }
}
