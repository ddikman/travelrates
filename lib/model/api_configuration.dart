class ApiConfiguration {
  final String apiKey;

  final String apiUrl;

  ApiConfiguration(this.apiKey, this.apiUrl);

  factory ApiConfiguration.fromJson(Map<String, dynamic> json) {
    return new ApiConfiguration(json['apiToken'], json['apiUrl']);
  }
}
