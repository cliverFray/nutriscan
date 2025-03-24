// Modelo AppInfo
class AppInfo {
  final int id;
  final String appName;
  final String version;
  final String developer;
  final String description;

  AppInfo({
    required this.id,
    required this.appName,
    required this.version,
    required this.developer,
    required this.description,
  });

  factory AppInfo.fromJson(Map<String, dynamic> json) {
    return AppInfo(
      id: json['id'],
      appName: json['appName'],
      version: json['version'],
      developer: json['developer'],
      description: json['description'],
    );
  }
}
