import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/core/utils/validators/email_validator.dart';
import 'package:fitness/core/utils/validators/password_validator.dart';
import 'package:fitness/core/utils/validators/validator_context.dart';
import 'package:fitness/models/user_model.dart';
import 'package:fitness/services/auth_service.dart';

class AuthController {
  // Singleton
  AuthController._privateConstructor();
  static final AuthController shared = AuthController._privateConstructor();

  final emailValidator = ValidatorContext(EmailValidator());
  final passwordValidator = ValidatorContext(PasswordValidator());
  final AuthService _authService = AuthService();

  String? validateEmail(String email) => emailValidator.validate(email);
  String? validatePassword(String password) =>
      passwordValidator.validate(password);

  /// Lấy user hiện tại từ FirebaseAuth
  User? get currentUser => _authService.currentUser;

  /// Login email/password
  Future<UserModel?> login(String email, String password) async {
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);
    if (emailError != null || passwordError != null) {
      throw Exception(emailError ?? passwordError);
    }

    try {
      final user = await _authService.loginWithEmailPassword(
        email: email,
        password: password,
      );
      print('✅ Login thành công: ${user?.email}');
      return user;
    } catch (e) {
      print('❌ Login lỗi: $e');
      rethrow;
    }
  }

  /// Register email/password
  Future<UserModel?> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final emailError = validateEmail(email);
    final passwordError = validatePassword(password);
    if (emailError != null || passwordError != null) {
      throw Exception(emailError ?? passwordError);
    }

    try {
      final user = await _authService.registerWithEmailPassword(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      print('✅ Register thành công: ${user?.email}');
      return user;
    } catch (e) {
      print('❌ Register lỗi: $e');
      rethrow;
    }
  }

  /// Sign out Firebase, clear session cũ
  Future<void> signOut() async {
    try {
      await _authService.signOut();

      // Debug user state
      final currentUser = FirebaseAuth.instance.currentUser;
      print('Current user after signOut: $currentUser');
      print('✅ Cache cleared, signed out');
    } catch (e) {
      print('⚠️ Lỗi khi signOut: $e');
    }
  }
}
