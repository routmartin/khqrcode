class SourceInfo {
  final String? appIconUrl;
  final String? appName;
  final String? appDeepLinkCallback;

  SourceInfo({
    this.appIconUrl,
    this.appName,
    this.appDeepLinkCallback,
  });

  Map<String, dynamic> toJson() {
    return {
      'appIconUrl': appIconUrl,
      'appName': appName,
      'appDeepLinkCallback': appDeepLinkCallback,
    };
  }
}