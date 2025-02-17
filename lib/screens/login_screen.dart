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
      body: LayoutBuilder(
        builder: (context, constraints) {
          bool isDesktop = constraints.maxWidth > 900;
          bool isTablet =
              constraints.maxWidth > 600 && constraints.maxWidth <= 900;
          double titleFontSize = isDesktop ? 32 : (isTablet ? 28 : 24);
          double buttonFontSize = isDesktop ? 26 : (isTablet ? 22 : 18);
          double paddingSize = isDesktop ? 40 : (isTablet ? 30 : 16);
          double buttonWidth =
              isDesktop ? 300 : (isTablet ? 260 : double.infinity);

          return Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blueAccent, Colors.purpleAccent],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight:
                        constraints.maxHeight, // Ensures it adapts dynamically
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Title
                        Text(
                          "Welcome to Badminton App",
                          style: TextStyle(
                            fontSize: titleFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),

                        // Google Sign-in Button
                        SizedBox(
                          width: buttonWidth,
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final user =
                                  await authProvider.signInWithGoogle();
                              if (user != null) {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const HomeScreen()),
                                );
                              }
                            },
                            icon: const Icon(Icons.login, color: Colors.white),
                            label: Text(
                              "Sign in with Google",
                              style: TextStyle(
                                  fontSize: buttonFontSize,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
