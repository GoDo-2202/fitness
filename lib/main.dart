import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
import 'services/init_app_service.dart';
import 'providers/locale_provider.dart';
import 'pages/main/main_page.dart';
import 'pages/authentication/widgets/auth_page.dart';
import 'pages/authentication/controllers/auth_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Khởi tạo các service chung
  await InitAppService.instance.init();

  runApp(
    ChangeNotifierProvider(
      create: (_) => LocaleProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Fitness App',
      locale: localeProvider.locale,
      supportedLocales: InitAppService.instance.supportedLocales,
      localizationsDelegates: InitAppService.instance.localizationsDelegates,
      home: const RootPage(),
    );
  }
}

class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _checkAuth();
  }

  Future<void> _checkAuth() async {
    try {
      final user = AuthController.shared.currentUser;

      if (user == null) {
        // Nếu chưa có user, clear session cũ
        await AuthController.shared.signOut();
        print('✅ Cache cleared, signed out');
      } else {
        print('✅ User đang đăng nhập: ${user.email}');
      }
    } catch (e) {
      print('⚠️ Lỗi khi kiểm tra auth: $e');
    } finally {
      // Chỉ setState nếu widget còn mounted
      if (!mounted) return;
      setState(() => _initialized = true);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Nếu đã đăng nhập → MainPage
        if (snapshot.hasData && snapshot.data != null) {
          return const MainPage();
        }

        // Nếu chưa đăng nhập → AuthPage
        return const AuthPage();
      },
    );
  }
}
