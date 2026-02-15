import 'package:plantyard/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static final Map<String, String> _users = {"test@gmail.com": "12345678"};

  static final Map<String, User> _userProfiles = {};

  static Future<bool> login(String email, String password) async {
    if (_users[email] == password) {
      if (!_userProfiles.containsKey(email)) {
        _userProfiles[email] = User(
          id: DateTime.now().toString(),
          email: email,
          fullName: email.split('@')[0],
          userType: UserType.buyer,
        );
      }

      // Sove session
      await _saveUserSession(_userProfiles[email]!);

      return true;
    }
    return false;
  }

  static Future<bool> signup(String email, String password, String fullName,
      {UserType userType = UserType.buyer}) async {
    if (_users.containsKey(email)) return false;

    _users[email] = password;
    _userProfiles[email] = User(
      id: DateTime.now().toString(),
      email: email,
      fullName: fullName,
      userType: userType,
    );

    return true;
  }

  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    await prefs.setBool('isLoggedIn', false);
  }

  static Future<User?> getCurrentUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? userJson = prefs.getString('user');

      if (userJson != null) {
        return User.fromJson(json.decode(userJson));
      }
    } catch (e) {
      print('Error getting user: $e');
    }
    return null;
  }

  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  static Future<void> _saveUserSession(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('user', json.encode(user.toJson()));
    await prefs.setBool('isLoggedIn', true);
  }
}
