import 'src/data/mappers/pubspec_loc_mapper.dart';
import 'src/data/mappers/yaml_mapper.dart';
import 'src/data/repositories/file_repository.dart';
import 'src/data/repositories/lock_packages_repository.dart';
import 'src/data/repositories/packages_repository.dart';
import 'src/domain/adapters/file_adapter.dart';
import 'src/domain/adapters/lock_packages_adapter.dart';
import 'src/domain/adapters/packages_adapter.dart';
import 'src/domain/entities/package_entity.dart';

const String pubspecPath = 'pubscpec/pubspec.yaml';
const String lockPath = 'pubscpec/pubspec.lock';

const String dependenciesKey = 'dependencies';
const String devDependenciesKey = 'dev_dependencies';

const String dependenciesFilePath = 'pubscpec/dependencies.txt';
const String devFilePath = 'pubscpec/dev_dependencies.txt';

// void main(List<String> arguments) {
//   print('Start parsing "pubspec" files');
//   final pubspecLock =
//       readFileAsString('pubscpec/pubspec.lock').loadPubspecLockFromYaml();
//   print('Loaded pubspec.look with ${pubspecLock.packages.length} package '
//       'dependencies');
//
//   final packagesLockMap = Map.fromEntries(
//     pubspecLock.packages.map(
//       (package) => MapEntry<String, String>(
//         package.package(),
//         package.version(),
//       ),
//     ),
//   );
//
//   final yamlString = readFileAsString('pubscpec/pubspec.yaml');
//   final pubspecNode = loadYamlNode(yamlString) as YamlMap;
//
//   final dependenciesYamlMap = pubspecNode[dependenciesKey] as YamlMap;
//   final newDependencies = sortPackagesAndLockVersion(
//     yamlMap: dependenciesYamlMap,
//     packages: packagesLockMap,
//   );
//   writeFileAsString('pubscpec/dependencies.txt', newDependencies);
//
//   final devDependenciesYamlMap = pubspecNode[devDependenciesKey] as YamlMap;
//   final newDev = sortPackagesAndLockVersion(
//     yamlMap: devDependenciesYamlMap,
//     packages: packagesLockMap,
//   );
//   writeFileAsString('pubscpec/dev_dependencies.txt', newDev);
// }
//
// String sortPackagesAndLockVersion({
//   required YamlMap yamlMap,
//   required Map<String, String> packages,
// }) {
//   final sortedKeys = sortPackages(yamlMap);
//   final sortedDependenciesMap = {};
//   for (final key in sortedKeys) {
//     final value = yamlMap[key];
//     if (value is String) {
//       final lockVersion = replaceVersion(
//         packageName: key,
//         packages: packages,
//       );
//       sortedDependenciesMap[key] = lockVersion.isNotEmpty ? lockVersion : value;
//     } else {
//       sortedDependenciesMap[key] = value;
//     }
//   }
//   return yamlToString(sortedDependenciesMap);
// }
//
// String readFileAsString(String fileName) {
//   return File(fileName).readAsStringSync();
// }
//
// void writeFileAsString(String fileName, String contents) {
//   File(fileName).writeAsStringSync(contents);
// }
//
// List<dynamic> sortPackages(YamlMap yamlMap) {
//   return yamlMap.keys.toList()..sort();
// }
//
// String yamlToString(dynamic yaml) {
//   final sb = StringBuffer();
//   if (yaml is String) {}
//   for (final mapEntry in yaml.entries) {
//     sb.write('\t${mapEntry.key}:');
//     if (mapEntry.value is YamlMap) {
//       sb.write('\n\t${yamlToString(mapEntry.value)}');
//     } else {
//       sb.write(' ${mapEntry.value}\n');
//     }
//   }
//   return sb.toString();
// }
//
// String replaceVersion({
//   required String packageName,
//   required Map<String, String> packages,
// }) {
//   return packages.containsKey(packageName) ? packages[packageName]! : '';
// }

void main(List<String> arguments) {
  final di = dependencyInjection();
  final packageEntity = PackageEntity(
    lockPackagesAdapter: di[LockPackagesAdapter],
    packagesAdapter: di[PackagesAdapter],
    fileAdapter: di[FileAdapter],
  );
  packageEntity.loadPackages(
    pubspecFile: pubspecPath,
    lockFile: lockPath,
  );
  packageEntity.freezePackagesVersion(
    fieldName: dependenciesKey,
    outputFile: dependenciesFilePath,
  );
  packageEntity.freezePackagesVersion(
    fieldName: devDependenciesKey,
    outputFile: devFilePath,
  );
}

Map<Type, dynamic> dependencyInjection() {
  final di = <Type, dynamic>{};
  di[FileAdapter] = FileRepository(
    yamlMapper: YamlMapper(sortContents: SortContents.asc),
  );
  di[LockPackagesAdapter] = LockPackagesRepository(
    fileAdapter: di[FileAdapter],
    pubspecLocMapper: PubspecLocMapper(),
  );
  di[PackagesAdapter] = PackagesRepository(fileAdapter: di[FileAdapter]);

  return di;
}
