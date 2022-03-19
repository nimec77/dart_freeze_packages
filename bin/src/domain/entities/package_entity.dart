import 'package:yaml/yaml.dart';

import '../adapters/file_adapter.dart';
import '../adapters/lock_packages_adapter.dart';
import '../adapters/packages_adapter.dart';

class PackageEntity {
  final LockPackagesAdapter lockPackagesAdapter;
  final PackagesAdapter packagesAdapter;
  final FileAdapter fileAdapter;

  late final YamlMap _pubspecPackages;
  late final Map<String, String> _lockPackages;

  PackageEntity({
    required this.lockPackagesAdapter,
    required this.packagesAdapter,
    required this.fileAdapter,
  });

  void freezePackagesVersion({
    required String fieldName,
    required String outputFile,
  }) {
    final yamlMap = _pubspecPackages[fieldName];
    final freezePackages = _replacePackagesVersion(
      yamlMap: yamlMap,
      packages: _lockPackages,
    );
    _savePackagesToFile(outputFile, freezePackages);
  }

  void loadPackages({
    required String pubspecFile,
    required String lockFile,
  }) {
    _pubspecPackages = _loadPubspecPackages(pubspecFile);
    _lockPackages = _loadLocPackages(lockFile);
  }

  YamlMap _loadPubspecPackages(String path) {
    return packagesAdapter.loadPubspecPackages(path);
  }

  Map<String, String> _loadLocPackages(String path) {
    return lockPackagesAdapter.loadLockPackages(path);
  }

  Map<String, dynamic> _replacePackagesVersion({
    required YamlMap yamlMap,
    required Map<String, String> packages,
  }) {
    final map = <String, dynamic>{};
    for (final packageName in yamlMap.keys) {
      final value = yamlMap[packageName];
      if (value is String) {
        final lockVersion = _replaceVersion(
          packageName: packageName,
          packages: packages,
        );
        map[packageName] = lockVersion.isNotEmpty ? lockVersion : value;
      } else {
        map[packageName] = value;
      }
    }
    return map;
  }

  void _savePackagesToFile(String path, Map<String, dynamic> contents) {
    fileAdapter.saveFileAsString(path, contents);
  }

  String _replaceVersion({
    required String packageName,
    required Map<String, String> packages,
  }) {
    return packages.containsKey(packageName) ? packages[packageName]! : '';
  }
}
