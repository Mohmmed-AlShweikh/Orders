import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:orders/features/auth/provider/auth_provider.dart';

final pickedImageProvider = StateProvider<XFile?>((ref) => null);

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final picker = ImagePicker();

  Future<void> pickImage() async {
    final img = await picker.pickImage(source: ImageSource.gallery);
    if (img != null) {
      ref.read(pickedImageProvider.notifier).state = img;
    }
  }

  @override
  Widget build(BuildContext context) {
    final userAsync = ref.watch(authUserProvider);
    final authState = ref.watch(authControllerProvider);
    final pickedImage = ref.watch(pickedImageProvider);

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
      backgroundColor: const Color(0xff0f172a),
      appBar: AppBar(
        elevation: 0,
        title: const Text("Profile",style: TextStyle(color: Colors.white),),
        centerTitle: true,
        backgroundColor: const Color(0xff0f172a),
        
      ),
      body: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Center(child: Text("No user"));
          }

          nameController.text = user.name;
          phoneController.text = user.phone;

          final image = pickedImage != null
              ? File(pickedImage.path)
              : (user.imageUrl != null ? File(user.imageUrl!) : null);

          return SingleChildScrollView(
            child: Column(
              children: [
                /// 🔥 HEADER
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 30),
                  decoration: const BoxDecoration(
                    color: Color(0xff1e293b),
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(30),
                    ),
                  ),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: pickImage,
                            child: CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.white12,
                              backgroundImage:
                                  image != null ? FileImage(image) : null,
                              child: image == null
                                  ? const Icon(Icons.person, size: 40)
                                  : null,
                            ),
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(
                                Icons.edit,
                                size: 16,
                                color: Colors.white,
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user.name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user.phone,
                        style: const TextStyle(
                          color: Colors.white54,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 25),

                /// 🧾 FORM
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _field("Name", nameController),
                      const SizedBox(height: 15),
                      _field("Phone", phoneController),

                      const SizedBox(height: 30),

                      /// 💾 SAVE BUTTON
                      SizedBox(
                        width: double.infinity,
                        height: 55,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          onPressed: authState.isLoading
                              ? null
                              : () async {
                                  final updatedUser = user.copyWith(
                                    name: nameController.text.trim(),
                                    phone: phoneController.text.trim(),
                                    imageUrl: pickedImage?.path ??
                                        user.imageUrl,
                                  );

                                  await ref
                                      .read(authControllerProvider.notifier)
                                      .updateProfile(updatedUser);

                                  ref
                                      .read(pickedImageProvider.notifier)
                                      .state = null;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("Profile updated"),
                                    ),
                                  );
                                },
                          child: Ink(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff3b82f6),
                                  Color(0xff6366f1),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Center(
                              child: authState.isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      "Save Changes",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Text(
            e.toString(),
            style: const TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(
          label == "Name" ? Icons.person : Icons.phone,
          color: Colors.white70,
        ),
        filled: true,
        fillColor: const Color(0xff1e293b),
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}