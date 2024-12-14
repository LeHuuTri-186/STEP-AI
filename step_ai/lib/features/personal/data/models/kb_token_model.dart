class KbTokenModel{
  final String? kbAccessToken;
  final String? kbRefreshToken;

  KbTokenModel({required this.kbAccessToken, required this.kbRefreshToken});
// Phương thức fromJson để ánh xạ từ JSON lồng
  factory KbTokenModel.fromJson(Map<String, dynamic> json) {
    final token = json['token'] as Map<String, dynamic>?; // Lấy phần tử "token"
    return KbTokenModel(
      kbAccessToken: token?['accessToken'] as String?,
      kbRefreshToken: token?['refreshToken'] as String?,
    );
  }
}