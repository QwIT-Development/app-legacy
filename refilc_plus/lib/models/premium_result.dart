class PremiumResult {
  final String sessionId;
  final List<String> scopes;
  final String login;

  PremiumResult({
    required this.sessionId,
    required this.scopes,
    required this.login,
  });

  factory PremiumResult.fromJson(Map json) {
    return PremiumResult(
      sessionId: json["session_id"] ?? "",
      scopes: (json["scopes"] ?? []).cast<String>(),
      login: json["customer_id"] ?? "",
    );
  }
}
