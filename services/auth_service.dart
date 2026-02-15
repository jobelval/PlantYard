import 'package:plantyard/services/storage_service.dart';
import 'package:plantyard/models/user_model.dart';

class AuthService {
  // Sa se baz done senp ou te bay la
  static final Map<String, String> _users = {"test@gmail.com": "12345678"};

  static final Map<String, User> _userProfiles = {};

  static Future<bool> login(String email, String password) async {
    // Verifye nan map ou a
    if (_users[email] == password) {
      // Kreye pwofil itilizatè si poko egziste
      if (!_userProfiles.containsKey(email)) {
        _userProfiles[email] = User(
          id: DateTime.now().toString(),
          email: email,
          fullName: email.split('@')[0],
          userType: UserType.buyer,
        );
      }

      // Save session
      final storage = StorageService();
      await storage.init();
      await storage.saveUserSession(_userProfiles[email]!);

      return true;
    }
    return false;
  }

  static Future<bool> signup(
    String email,
    String password,
    String fullName, {
    UserType userType = UserType.buyer,
  }) async {
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
    final storage = StorageService();
    await storage.init();
    await storage.clearUserSession();
  }

  static Future<User?> getCurrentUser() async {
    final storage = StorageService();
    await storage.init();
    return storage.getUserSession();
  }
}
