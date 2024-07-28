import 'dart:html';
import 'dart:convert';

import 'package:bispick/models/User.dart';

class LocalStorageService {
  // User 정보를 로컬 스토리지에 저장
  static void saveUser(User user) {
    window.localStorage['user'] = jsonEncode(user.toJson());
  }

  // 로컬 스토리지에서 User 정보를 불러옴
  static User? loadUser() {
    String? jsonString = window.localStorage['user'];
    if (jsonString != null) {
      return User.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  // 로컬 스토리지에서 User 정보 삭제
  static void removeUser() {
    window.localStorage.remove('user');
  }
}