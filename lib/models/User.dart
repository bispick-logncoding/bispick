class User {
  String email;
  String id;
  String? displayName;
  String? photoUrl;
  String? idToken;
  String? accessToken;
  String? serverAuthCode;

  User({
    required this.email,
    required this.id,
    this.displayName,
    this.photoUrl,
    required this.idToken,
    this.accessToken,
    this.serverAuthCode,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'],
      id: json['id'],
      displayName: json['displayName'],
      photoUrl: json['photoUrl'],
      idToken: json['idToken'],
      serverAuthCode: json['serverAuthCode'],
      accessToken: json['accessToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'id': id,
      'displayName': displayName ?? '',
      'photoUrl': photoUrl ?? '',
      'idToken': idToken ?? '',
      'serverAuthCode': serverAuthCode ?? '',
      'accessToken': accessToken ?? '',
    };
  }
}