class AppUpdate {
  AppUpdate({
    this.androidVersion,
    this.iOsVersion,
  });

  Version? androidVersion;
  Version? iOsVersion;

  factory AppUpdate.fromJson(Map<String, dynamic> json) => AppUpdate(
        androidVersion: Version.fromJson(json["androidVersion"]),
        iOsVersion: Version.fromJson(json["iOSVersion"]),
      );
}

class Version {
  Version({
    this.version = '',
    this.description = '',
    this.appUrl = '',
    this.isForceUpdate = false,
  });

  String version;
  String description;
  String appUrl;
  bool isForceUpdate;

  factory Version.fromJson(Map<String, dynamic> json) => Version(
        version: json["version"] ?? '',
        description: json["description"] ?? '',
        appUrl: json["appURL"] ?? '',
        isForceUpdate: json["isForceUpdate"] ?? false,
      );
}
