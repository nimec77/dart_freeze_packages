import 'package:yaml/yaml.dart';

enum SortContents {
  none,
  asc,
  desc,
}

class YamlMapper {
  final SortContents sortContents;

  YamlMapper({this.sortContents = SortContents.none});

  String yamlToString(dynamic contents) {
    final sb = StringBuffer();
    if (contents is String) {
      return contents;
    }
    final keys = _sortContents(contents);
    for (final key in keys) {
      sb.write('\t$key:');
      final value = contents[key] ?? '';
      if (value is YamlMap) {
        sb.write('\n\t${yamlToString(value)}');
      } else {
        sb.write(' $value\n');
      }
    }
    return sb.toString();
  }

  List<dynamic> _sortContents(dynamic contents) {
    final keys = contents.keys.toList();
    switch (sortContents) {
      case SortContents.none:
        return keys;
      case SortContents.asc:
        return keys..sort();
      case SortContents.desc:
        return (keys..sort()).reversed.toList();
    }
  }
}
