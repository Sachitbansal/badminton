import 'package:badminton/screens/home_screen.dart';
import 'package:badminton/screens/login_screen.dart';
import 'package:badminton/services/providerSerivice.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();


  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyACmG_hRGQ2UDnml4dtgT3b2lMkDvjuDdw",
        authDomain: "badminton-app-iitmandi.firebaseapp.com",
        projectId: "badminton-app-iitmandi",
        storageBucket: "badminton-app-iitmandi.firebasestorage.app",
        messagingSenderId: "661698209746",
        appId: "1:661698209746:web:70ef594a69ca2577934a0b"
    )
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProviderr()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

// class MyApp extends StatelessWidget {
//
//   // Check if the user is logged in or not
//   Widget _getInitialScreen() {
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//
//     // If the user is logged in, navigate to the HomeScreen
//     if (_auth.currentUser != null) {
//       return HomeScreen(); // User is logged in
//     } else {
//       return LoginScreen(); // User is not logged in
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Google Auth Flutter Web',
//       theme: ThemeData(primarySwatch: Colors.blue),
//       home: HomeScreen(),
//     );
//   }
// }


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Badminton Booking',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProviderr>(context);

    if (authProvider.user == null) {
      return const LoginScreen();
    } else {
      return const HomeScreen();
    }
  }
}