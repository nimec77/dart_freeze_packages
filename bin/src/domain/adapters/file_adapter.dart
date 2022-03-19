abstract class FileAdapter {
  String loadFileAsString(String path);

  void saveFileAsString(String path, Map<String, dynamic> contents);
}