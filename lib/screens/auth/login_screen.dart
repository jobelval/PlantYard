import 'package:flutter/material.dart';
import 'package:plantyard/screens/auth/signup_screen.dart';
import 'package:plantyard/screens/home/home_screen.dart';
import 'package:plantyard/services/auth_service.dart';
import 'package:plantyard/widgets/custom_keyboard.dart';
import 'package:plantyard/widgets/auth_widgets.dart';

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
          emailController.text, passwordController.text);

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
        emailController.text =
            emailController.text.substring(0, emailController.text.length - 1);
      } else if (activeField == 'password' &&
          passwordController.text.isNotEmpty) {
        passwordController.text = passwordController.text
            .substring(0, passwordController.text.length - 1);
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
                const Icon(Icons.eco, size: 80, color: Color(0xFF2E7D32)),
                const Text(
                  'PlantYard',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2E7D32),
                  ),
                ),
                const SizedBox(height: 40),
                Expanded(
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        AuthField(
                          controller: emailController,
                          label: "Imèl",
                          icon: Icons.email,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Tanpri mete imèl ou";
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
                                () => _obscurePassword = !_obscurePassword);
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
                          text: 'Konekte',
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
                                  color: Color(0xFF2E7D32),
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
