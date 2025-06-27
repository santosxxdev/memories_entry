import 'package:flutter/material.dart';
import 'package:memories_entry/shared/firebase/firebase_manager.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});

  static final String routeName = 'login';

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final FirebaseManager firebaseManager = FirebaseManager();
  final TextEditingController emailTextController = TextEditingController();
  final TextEditingController passwordTextController = TextEditingController();

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
          const Text(
            'Login',
            style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          const Text(
            'Login To Continue Using The App',
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          const SizedBox(height: 30),

          Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildField(
                  title: 'Email',
                  hint: 'Enter your email',
                  controller: emailTextController,
                ),
                const SizedBox(height: 20),
                _buildField(
                  title: 'Password',
                  hint: 'Enter your password',
                  controller: passwordTextController,
                  isPassword: true,
                ),
                const SizedBox(height: 20),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Forgot Password ?',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      firebaseManager.loginAccount(
                        emailTextController.text.trim(),
                        passwordTextController.text.trim(),
                      );
                    }
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text("Don't have an account? "),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, 'signup');
                },
                child: const Text(
                  "Sign Up",
                  style: TextStyle(
                    color: Colors.pink,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Row(
            children: const [
              Expanded(child: Divider()),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('Or Login With'),
              ),
              Expanded(child: Divider()),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _socialIcon('assets/image/google.png'),
              const SizedBox(width: 20),
              _socialIcon('assets/image/facebook.png'),
              const SizedBox(width: 20),
              _socialIcon('assets/image/apple.png'),
            ],
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

  Widget _socialIcon(String assetPath) {
    return IconButton(
      onPressed: () {},
      icon: Image.asset(assetPath, width: 30, height: 30),
    );
  }
}
