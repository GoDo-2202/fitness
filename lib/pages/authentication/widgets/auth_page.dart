import 'package:fitness/pages/authentication/controllers/auth_controller.dart';
import 'package:fitness/pages/main/main_page.dart';
import 'package:flutter/material.dart';
import 'package:fitness/core/widgets/custom_text_field.dart';
import 'package:fitness/gen/assets.gen.dart';

class AuthPage extends StatefulWidget {
  final bool isLogin; // true = Login, false = Register

  const AuthPage({super.key, this.isLogin = true});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? emailError;
  String? passwordError;
  bool isLoading = false;
  late bool isLogin;

  @override
  void initState() {
    super.initState();
    isLogin = widget.isLogin;
  }

  void _toggleAuthMode() {
    setState(() {
      isLogin = !isLogin;
    });
  }

  Future<void> _onSubmit() async {
    if (mounted) {
      setState(() {
        emailError = AuthController.shared.validateEmail(_emailController.text);
        passwordError =
            AuthController.shared.validatePassword(_passwordController.text);
      });
    }

    if (emailError != null || passwordError != null) return;

    if (mounted) setState(() => isLoading = true);

    try {
      if (isLogin) {
        final user = await AuthController.shared.login(
          _emailController.text,
          _passwordController.text,
        );
        print('✅ Login success: ${user?.email}');

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainPage()),
          );
        }
      } else {
        final user = await AuthController.shared.register(
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          email: _emailController.text,
          password: _passwordController.text,
        );
        print('✅ Register success: ${user?.email}');

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const MainPage()),
          );
        }
      }
    } catch (e) {
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 20),
                      Text(
                        isLogin ? 'Welcome Back,' : 'Hey there,',
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 16),
                      ),
                      Text(
                        isLogin ? 'Login to your Account' : 'Create an Account',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 30),
                      if (!isLogin) ...[
                        CustomTextField(
                          hintText: "First Name",
                          prefixIconPath: Assets.icons.plate,
                          controller: _firstNameController,
                        ),
                        const SizedBox(height: 15),
                        CustomTextField(
                          hintText: "Last Name",
                          prefixIconPath: Assets.icons.plate,
                          controller: _lastNameController,
                        ),
                        const SizedBox(height: 15),
                      ],
                      CustomTextField(
                        hintText: "Email",
                        prefixIconPath: Assets.icons.plate,
                        controller: _emailController,
                      ),
                      if (emailError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            emailError!,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      const SizedBox(height: 15),
                      CustomTextField(
                        hintText: "Password",
                        prefixIconPath: Assets.icons.plate,
                        isPassword: true,
                        controller: _passwordController,
                      ),
                      if (passwordError != null)
                        Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            passwordError!,
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                                fontSize: 14,
                                color: Colors.red,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _onSubmit,
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                        ),
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Colors.blue, Colors.purple],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: Container(
                            height: 60,
                            alignment: Alignment.center,
                            child: Text(
                              isLogin ? 'Login' : 'Register',
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          _toggleAuthMode();
                        },
                        child: Text(
                          isLogin
                              ? "Don't have an account? Register"
                              : "Already have an account? Login",
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
