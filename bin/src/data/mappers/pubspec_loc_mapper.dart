import 'package:pubspec_lock/pubspec_lock.dart';

class PubspecLocMapper {
  Map<String, String> pubspecLocToMap(PubspecLock pubspecLock) =>
      Map.fromEntries(
        pubspecLock.packages.map(
          (package) => MapEntry<String, String>(
            package.package(),
            package.version(),
          ),
        ),
      );
}
