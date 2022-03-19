/*
 * MIT License
 *
 * Copyright (c) 2019 Alexei Sintotski
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.
 *
 */

import 'dart:convert';

import 'package:functional_data/functional_data.dart';
import 'package:json2yaml/json2yaml.dart';
import 'package:meta/meta.dart';
import 'package:yaml/yaml.dart';

import 'package_dependency/package_dependency.dart';
import 'package_dependency/serializers.dart';
import 'sdk_dependency/sdk_dependency.dart';
import 'sdk_dependency/serializers.dart';

part 'pubspec_lock.g.dart';

// ignore_for_file: annotate_overrides
// ignore_for_file: avoid_as

/// PubspecLock is a data type representing data stored in pubspec.lock files.
@immutable
@FunctionalData()
class PubspecLock extends $PubspecLock {
  /// Default constructor
  const PubspecLock({this.sdks = const {}, this.packages = const {}});

  @override
  final Iterable<SdkDependency> sdks;
  @override
  final Iterable<PackageDependency> packages;

  /// Produces YAML representation of the PubspecLock object
  String toYamlString() => '# Generated by pub'
      '\n# See https://dart.dev/tools/pub/glossary#lockfile'
      '\n${json2yaml(_toJson(this), yamlStyle: YamlStyle.pubspecLock)}';

  Map<String, dynamic> _toJson(PubspecLock pubspecLock) => <String, dynamic>{
        if (pubspecLock.packages.isNotEmpty)
          _Tokens.packages: _packagesToJson(pubspecLock.packages),
        if (pubspecLock.sdks.isNotEmpty)
          _Tokens.sdks: _sdksToJson(pubspecLock.sdks),
      };
}

/// Creates a PubspecLock object from YAML string
extension PubspecLockFromYamlString on String {
  /// Creates a PubspecLock object from a YAML string
  PubspecLock loadPubspecLockFromYaml() {
    final dynamic yaml = loadYaml(this);
    final jsonMap = json.decode(json.encode(yaml)) as Map<String, dynamic>;
    return PubspecLock(
      packages: _loadPackages(jsonMap),
      sdks: _loadSdks(jsonMap),
    );
  }
}

Iterable<PackageDependency> _loadPackages(Map<String, dynamic> jsonMap) =>
    ((jsonMap[_Tokens.packages] as Map<String, dynamic>?) ??
            <String, dynamic>{})
        .entries
        .map(loadPackageDependency);

Iterable<SdkDependency> _loadSdks(Map<String, dynamic> jsonMap) =>
    ((jsonMap[_Tokens.sdks] as Map<String, dynamic>?) ?? <String, dynamic>{})
        .entries
        .map(loadSdkDependency);

Map<String, dynamic> _packagesToJson(Iterable<PackageDependency> packages) =>
    <String, dynamic>{
      for (final package
          in packages.toList()
            ..sort((a, b) => a.package().compareTo(b.package())))
        ...package.toJson()
    };

Map<String, dynamic> _sdksToJson(Iterable<SdkDependency> sdks) =>
    <String, dynamic>{
      for (final entry in sdks.toList()..sort((a, b) => a.sdk.compareTo(b.sdk)))
        ...entry.toJson()
    };

class _Tokens {
  static const sdks = 'sdks';
  static const packages = 'packages';
}