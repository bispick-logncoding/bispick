import 'dart:html';

class UserInfoStorage {
  // 사용자 정보를 로컬 스토리지에 저장
  void saveUserInfo({
    required String email,
    required String id,
    String? displayName,
    String? photoUrl,
    String? idToken,
    String? serverAuthCode,
  }) {
    window.localStorage['email'] = email;
    window.localStorage['id'] = id;
    window.localStorage['displayName'] = displayName ?? '';
    window.localStorage['photoUrl'] = photoUrl ?? '';
    window.localStorage['idToken'] = idToken ?? '';
    window.localStorage['serverAuthCode'] = serverAuthCode ?? '';
  }

  // 로컬 스토리지에서 사용자 정보를 불러옴
  Map<String, String> loadUserInfo() {
    return {
      'email': window.localStorage['email'] ?? 'Unknown',
      'id': window.localStorage['id'] ?? 'Unknown',
      'displayName': window.localStorage['displayName'] ?? 'Unknown',
      'photoUrl': window.localStorage['photoUrl'] ?? 'Unknown',
      'idToken': window.localStorage['idToken'] ?? 'Unknown',
      'serverAuthCode': window.localStorage['serverAuthCode'] ?? 'Unknown',
    };
  }

  // 모든 사용자 정보를 삭제
  void clearUserInfo() {
    window.localStorage.remove('email');
    window.localStorage.remove('id');
    window.localStorage.remove('displayName');
    window.localStorage.remove('photoUrl');
    window.localStorage.remove('idToken');
    window.localStorage.remove('serverAuthCode');
  }
}

void main() {
  UserInfoStorage storage = UserInfoStorage();

  // 예제 데이터로 사용자 정보 저장
  storage.saveUserInfo(
    email: 'example@example.com',
    id: '123456',
    displayName: 'John Doe',
    photoUrl: 'https://example.com/photo.jpg',
    idToken: 'token123456',
    serverAuthCode: 'authCode123456',
  );

  // 저장된 정보 불러오기
  Map<String, String> userInfo = storage.loadUserInfo();
  userInfo.forEach((key, value) {
    print('$key: $value');
  });

  // 필요시 정보 삭제
  // storage.clearUserInfo();
}