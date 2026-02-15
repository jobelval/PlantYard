import 'package:flutter/material.dart';
import 'package:plantyard/screens/auth/signup_screen.dart';
import 'package:plantyard/screens/home/home_screen.dart';
import 'package:plantyard/services/auth_service.dart';
import 'package:plantyard/widgets/custom_keyboard.dart';
import 'package:plantyard/widgets/auth_widgets.dart';
import 'package:plantyard/utils/constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool showKeyboard = false;
  bool upper = false;
  bool symbol = false;
  String activeField = '';

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      bool success = await AuthService.login(
        emailController.text,
        passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => HomeScreen(email: emailController.text),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("Imèl oswa modpas pa kòrèk"),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onKeyPress(String key) {
    setState(() {
      if (activeField == 'email') {
        emailController.text += key;
      } else if (activeField == 'password') {
        passwordController.text += key;
      }
    });
  }

  void _onBackspace() {
    setState(() {
      if (activeField == 'email' && emailController.text.isNotEmpty) {
        emailController.text = emailController.text.substring(
          0,
          emailController.text.length - 1,
        );
      } else if (activeField == 'password' &&
          passwordController.text.isNotEmpty) {
        passwordController.text = passwordController.text.substring(
          0,
          passwordController.text.length - 1,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () => setState(() => showKeyboard = false),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header
                const Icon(Icons.eco, size: 80, color: AppColors.primaryGreen),
                const Text(
                  AppStrings.appName,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const Text(
                  "Konekte pou w ka achte plant",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 40),

                // Fòm
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthField(
                          controller: emailController,
                          label: AppStrings.email,
                          icon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Tanpri mete imèl ou";
                            }
                            if (!RegExp(
                              r'^[\w-\.]+@([\w-]+\.)+[\w]{2,4}',
                            ).hasMatch(value)) {
                              return "Imèl pa kòrèk";
                            }
                            return null;
                          },
                          onTap: () {
                            setState(() {
                              showKeyboard = true;
                              activeField = 'email';
                              symbol = false;
                            });
                          },
                        ),
                        const SizedBox(height: 16),
                        AuthPasswordField(
                          controller: passwordController,
                          obscureText: _obscurePassword,
                          onToggleVisibility: () {
                            setState(
                              () => _obscurePassword = !_obscurePassword,
                            );
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Tanpri mete modpas ou";
                            }
                            if (value.length < 8) {
                              return "Modpas dwe gen 8 karaktè minimòm";
                            }
                            return null;
                          },
                          onTap: () {
                            setState(() {
                              showKeyboard = true;
                              activeField = 'password';
                              symbol = false;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        AuthButton(
                          text: AppStrings.login,
                          onPressed: _handleLogin,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Ou poko gen kont? ",
                              style: TextStyle(color: Colors.grey),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const SignupScreen(),
                                  ),
                                );
                              },
                              child: const Text(
                                "Enskri",
                                style: TextStyle(
                                  color: AppColors.primaryGreen,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Klavye custom
                if (showKeyboard)
                  CustomKeyboard(
                    upper: upper,
                    symbol: symbol,
                    email: activeField == 'email',
                    onKey: _onKeyPress,
                    onBack: _onBackspace,
                    onShift: () => setState(() => upper = !upper),
                    onSymbol: () => setState(() => symbol = !symbol),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
