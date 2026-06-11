class LoginModel {
  final String username;
  final String password;
  final String domain;
  final bool rememberMe;

  const LoginModel({
    required this.username,
    required this.password,
    required this.domain,
    this.rememberMe = false,
  });

  LoginModel copyWith({
    String? username,
    String? password,
    String? domain,
    bool? rememberMe,
  }) {
    return LoginModel(
      username: username ?? this.username,
      password: password ?? this.password,
      domain: domain ?? this.domain,
      rememberMe: rememberMe ?? this.rememberMe,
    );
  }
}
