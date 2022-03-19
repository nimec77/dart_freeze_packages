import 'package:pubspec_lock/pubspec_lock.dart';

import '../../domain/adapters/file_adapter.dart';
import '../../domain/adapters/lock_packages_adapter.dart';
import '../mappers/pubspec_loc_mapper.dart';

class LockPackagesRepository implements LockPackagesAdapter {
  final FileAdapter fileAdapter;
  final PubspecLocMapper pubspecLocMapper;

  const LockPackagesRepository({
    required this.fileAdapter,
    required this.pubspecLocMapper,
  });

  @override
  Map<String, String> loadLockPackages(String path) {
    final pubspecLock =
        fileAdapter.loadFileAsString(path).loadPubspecLockFromYaml();

    return pubspecLocMapper.pubspecLocToMap(pubspecLock);
  }
}
