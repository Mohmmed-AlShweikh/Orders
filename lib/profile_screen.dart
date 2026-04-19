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
        title: const Text("Profile"),
        backgroundColor: const Color(0xff0f172a),
        actions: [
          IconButton(
            onPressed: () async{
              await ref.read(authControllerProvider.notifier).logout();
              ref.invalidate(authUserProvider);
            },
            icon: const Icon(Icons.logout),
          )
        ],
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

          return Padding(
            padding: const EdgeInsets.all(20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  /// 🖼 Avatar
                  GestureDetector(
                    onTap: pickImage,
                    child: CircleAvatar(
                      radius: 55,
                      backgroundImage:
                          image != null ? FileImage(image) : null,
                      child: image == null
                          ? const Icon(Icons.person, size: 40)
                          : null,
                    ),
                  ),

                  const SizedBox(height: 30),

                  _field("Name", nameController),
                  const SizedBox(height: 12),
                  _field("Phone", phoneController),

                  const SizedBox(height: 25),

                  /// 💾 Save
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: authState.isLoading
                          ? null
                          : () async {
                              final updatedUser = user.copyWith(
                                name: nameController.text.trim(),
                                phone: phoneController.text.trim(),
                                imageUrl: pickedImage?.path ?? user.imageUrl,
                              );

                              await ref
                                  .read(authControllerProvider.notifier)
                                  .updateProfile(updatedUser);

                              ref
                                  .read(pickedImageProvider.notifier)
                                  .state = null;
                            },
                      child: authState.isLoading
                          ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                          : const Text("Save Changes"),
                    ),
                  ),
                ],
              ),
            ),
          );
        },

        loading: () =>
            const Center(child: CircularProgressIndicator()),

        error: (e, _) => Center(child: Text(e.toString())),
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
        filled: true,
        fillColor: Colors.white10,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}