import 'package:yaml/yaml.dart';

abstract class PackagesAdapter {
  YamlMap loadPubspecPackages(String path);
}