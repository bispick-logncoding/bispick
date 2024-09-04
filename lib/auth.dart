import 'package:bispick/models/User.dart';
import 'package:bispick/services/LocalStorageService.dart';
import 'package:http/http.dart' as http;

class Auth {
  static Future<bool> isUserSignedIn() async {
    User? user = LocalStorageService.loadUser();
    if (user != null) {
      String token = user.accessToken as String;
      try {
        var url = Uri.https('www.googleapis.com', '/oauth2/v3/tokeninfo',
            {'access_token': token});
        var response = await http.get(url);
        if (response.statusCode == 200) {
          return true;
        }
      } catch(e) {
        LocalStorageService.removeUser();
      }
    }
    return false;
  }
}
