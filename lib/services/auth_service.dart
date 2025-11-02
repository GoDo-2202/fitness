import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness/models/user_model.dart';

class AuthService {
  static final AuthService instance = AuthService._internal();
  factory AuthService() => instance;
  AuthService._internal();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  User? get currentUser => _auth.currentUser;

  Future<UserModel?> registerWithEmailPassword(
      {required String firstName,
      required String lastName,
      required String email,
      required String password}) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Không thể tạo tài khoản. Vui lòng thử lại.');
      }

      final userModel = UserModel(
        id: user.uid,
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      await _firebaseFirestore
          .collection('users')
          .doc(user.uid)
          .set(userModel.toJson());

      return userModel;
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMsg(e));
    }
  }

  Future<UserModel?> loginWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('User không tồn tại');
      }

      final uid = user.uid;

      final doc = await _firebaseFirestore.collection('users').doc(uid).get();
      if (!doc.exists || doc.data() == null) {
        throw Exception('Không tìm thấy dữ liệu người dùng trong Firestore');
      }

      return UserModel.fromJson(doc.data()!);
    } on FirebaseAuthException catch (e) {
      throw Exception(_getErrorMsg(e));
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      final user = _auth.currentUser;
      if (user == null) {
        print('⚠️ No user logged in');
        return null;
      }

      // forceRefresh = true sẽ buộc Firebase lấy token mới
      final idToken = await user.getIdToken(forceRefresh);
      print('🔄 Refreshed ID Token: $idToken');
      return idToken;
    } catch (e) {
      print('❌ Error refreshing token: $e');
      return null;
    }
  }

  String _getErrorMsg(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'Tài khoản không tồn tại.';
      case 'wrong-password':
        return 'Sai mật khẩu.';
      case 'email-already-in-use':
        return 'Email đã được đăng ký.';
      case 'invalid-email':
        return 'Email không hợp lệ.';
      case 'weak-password':
        return 'Mật khẩu quá yếu.';
      default:
        return 'Lỗi không xác định: ${e.message}';
    }
  }
}
