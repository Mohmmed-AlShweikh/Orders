import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../provider/auth_provider.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();

  final email = TextEditingController();
  final password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    /// 🔥 show error automatically
    ref.listen(authControllerProvider, (prev, next) {
      next.whenOrNull(
        error: (e, _) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString())),
          );
        },
      );
    });

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(20),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff0f172a), Color(0xff1e293b)],
          ),
        ),
        child: Center(
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [

                  const Text(
                    "Welcome Back 👋",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),

                  const SizedBox(height: 30),

                  _field(email, "Email"),
                  const SizedBox(height: 12),
                  _field(password, "Password", true),

                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              await ref
                                  .read(authControllerProvider.notifier)
                                  .login(
                                    email.text.trim(),
                                    password.text.trim(),
                                  );

                              /// ❌ لا تعمل navigation هنا
                              /// router لحاله رح ينقلك
                            },
                      child: authState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Login"),
                    ),
                  ),

                  TextButton(
                    onPressed: () => context.go('/register'),
                    child: const Text(
                      "Don't have account? Register",
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _field(TextEditingController c, String hint,
      [bool obscure = false]) {
    return TextFormField(
      controller: c,
      obscureText: obscure,
      validator: (v) => v!.isEmpty ? "Required" : null,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: hint,
        labelStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}