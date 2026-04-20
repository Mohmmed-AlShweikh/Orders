import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:orders/features/auth/data/user_role.dart';
import '../provider/auth_provider.dart';
import '../data/user_model.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final name = TextEditingController();
  final phone = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
    UserRole selectedRole = UserRole.buyer; // 🔥 جديد


  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    /// 🔥 عرض الأخطاء تلقائي
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
                children: [

                  const Text(
                    "Create Account 🚀",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),

                  const SizedBox(height: 30),

                  _field(name, "Name"),
                  _field(phone, "Phone"),
                  _field(email, "Email"),
                  _field(password, "Password", true),

                  const SizedBox(height: 10),
                   Container(
                    margin: const EdgeInsets.only(bottom: 20),
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white10,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        RadioListTile<UserRole>(
                          value: UserRole.buyer,
                          groupValue: selectedRole,
                          title: const Text("Buyer",
                              style: TextStyle(color: Colors.white)),
                          onChanged: (v) {
                            setState(() => selectedRole = v!);
                          },
                        ),
                        RadioListTile<UserRole>(
                          value: UserRole.seller,
                          groupValue: selectedRole,
                          title: const Text("Seller",
                              style: TextStyle(color: Colors.white)),
                          onChanged: (v) {
                            setState(() => selectedRole = v!);
                          },
                        ),
                      ],
                    ),
                  ),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () async {
                              if (!_formKey.currentState!.validate()) return;

                              final user = AppUser(
                                uid: "",
                                name: name.text.trim(),
                                phone: phone.text.trim(),
                                email: email.text.trim(),
                                role: selectedRole,
                              );

                              await ref
                                  .read(authControllerProvider.notifier)
                                  .register(user, password.text.trim());

                                  

                              /// ❌ لا تعمل context.go
                              /// router لحاله يتصرف حسب الحالة
                            },
                      child: authState.isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text("Register"),
                    ),
                  ),

                  TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text(
                      "Already have account? Login",
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: c,
        obscureText: obscure,
        validator: (v) {
          if (v == null || v.isEmpty) return "Required";

          if (hint == "Email" && !v.contains('@')) {
            return "Invalid email";
          }

          if (hint == "Password" && v.length < 6) {
            return "Min 6 chars";
          }

          return null;
        },
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
      ),
    );
  }
}