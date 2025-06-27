import 'package:flutter/material.dart';
import 'package:memories_entry/model/user_model.dart';
import 'package:memories_entry/shared/firebase/firebase_manager.dart';

import 'home.dart';

class SignUpPage extends StatelessWidget {
  SignUpPage({super.key});

  static final String routeName = 'signup';
  final FirebaseManager firebaseManager = FirebaseManager();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController ageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const SizedBox(height: 40),
          Center(
            child: Container(
              width: 90,
              height: 90,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50),
                color: Colors.pinkAccent,
              ),
              child: Image.asset('assets/image/diary.png'),
            ),
          ),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Sign Up',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Create an account to continue',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ),
          const SizedBox(height: 30),

          Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField(title: 'Name', hint: 'Enter your name', controller: nameController),
                const SizedBox(height: 16),
                _buildField(title: 'Email', hint: 'Enter your email', controller: emailController),
                const SizedBox(height: 16),
                _buildField(title: 'Phone', hint: 'Enter your phone', controller: phoneController),
                const SizedBox(height: 16),
                _buildField(title: 'Age', hint: 'Enter your age', controller: ageController),
                const SizedBox(height: 16),
                _buildField(
                  title: 'Password',
                  hint: 'Enter your password',
                  controller: passwordController,
                  isPassword: true,
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        try {
                          await firebaseManager.createAccount(
                            emailController.text.trim(),
                            passwordController.text.trim(),
                            UserModel(
                              name: nameController.text.trim(),
                              age: ageController.text.trim(),
                              phone: phoneController.text.trim(),
                              email: emailController.text.trim(),
                            ),
                          );
                          // ✅ بعد التسجيل انقله إلى الصفحة الرئيسية أو صفحة تسجيل الدخول
                          Navigator.pushReplacementNamed(context, HomePage.routeName);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('فشل التسجيل: $e')),
                          );
                        }
                      }
                    },
                  child: const Text("Sign Up"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({
    required String title,
    required String hint,
    required TextEditingController controller,
    bool isPassword = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          obscureText: isPassword,
          decoration: InputDecoration(hintText: hint),
          validator: (value) {
            if (value == null || value.trim().isEmpty) {
              return '$title is required';
            }
            return null;
          },
        ),
      ],
    );
  }
}
