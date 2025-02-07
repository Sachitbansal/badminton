import 'package:badminton/screens/home_screen.dart';
import 'package:badminton/services/providerSerivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderr>(context, listen: false);
    return Scaffold(
      appBar: AppBar(title: const Text("Login with Google")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final user = await authProvider.signInWithGoogle();
            if (user != null) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreenn()),
              );
            }
          },
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}

