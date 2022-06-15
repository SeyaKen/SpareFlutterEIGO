import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceHelper {
  static String userNameKey = "USERNAMEKEY";

  //save data
  Future<bool> saveUserName(String? userName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNameKey, userName!);
  }

  //get data
  Future<String?> getUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNameKey);
  }
}