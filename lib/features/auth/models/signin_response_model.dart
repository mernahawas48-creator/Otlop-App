class SignInResponseModel {
  const SignInResponseModel({
    this.accessToken,
    this.expiresAtUtc,
    this.refreshToken,
  });

  final String? accessToken;
  final String? expiresAtUtc;
  final String? refreshToken;

  factory SignInResponseModel.fromJson(Map<String, dynamic> json) {
    return SignInResponseModel(
      accessToken: json['accessToken'] as String?,
      expiresAtUtc: json['expiresAtUtc'] as String?,
      refreshToken: json['refreshToken'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresAtUtc': expiresAtUtc,
      'refreshToken': refreshToken,
    };
  }
}
