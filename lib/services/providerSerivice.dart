import 'package:badminton/services/emailService.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';

class BookingProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String todayDate = DateFormat.yMMMd().format(DateTime.now());
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String userEmail = FirebaseAuth.instance.currentUser?.email ?? "guest";

  List<Map<String, dynamic>> slotsAvailability = [];
  bool isLoading = true;

  BookingProvider() {
    fetchSlots();
  }

  Future<void> fetchSlots() async {
    List<Map<String, dynamic>> data = [];
    List<String> courts = ['Court1', 'Court2', 'Court3', 'Court4'];
    Map<String, Map<String, dynamic>> biggerMap = {
      'position1': {
        'time1': false,
        'time2': false,
        'time3': false,
        'time4': false,
      },
      'position2': {
        'time1': false,
        'time2': false,
        'time3': false,
        'time4': false,
      },
      'position3': {
        'time1': false,
        'time2': false,
        'time3': false,
        'time4': false,
      },
      'position4': {
        'time1': false,
        'time2': false,
        'time3': false,
        'time4': false,
      }
    };

    for (String court in courts) {
      DocumentReference slotRef = _firestore.collection(court).doc(todayDate);

      DocumentSnapshot slotDoc = await slotRef.get();
      if (slotDoc.exists) {
        Map<String, dynamic> map = slotDoc.data() as Map<String, dynamic>;
        Map<String, Map<String, dynamic>> updatedMap = {};
        // Copy biggerMap structure into updatedMap
        biggerMap.forEach((position, times) {
          updatedMap[position] = Map.from(times);
        });

        map.forEach((position, times) {
          if (updatedMap.containsKey(position)) {
            times.forEach((time, value) {
              if (updatedMap[position]!.containsKey(time)) {
                updatedMap[position]![time] = value; // Update value
              }
            });
          }
        });
        data.add(updatedMap);
      } else {
        data.add(biggerMap);
      }
    }
    slotsAvailability = data;
    isLoading = false;
    notifyListeners();
  }

  Future<void> bookSlot(String courtName, String position, String time) async {
    String userId = FirebaseAuth.instance.currentUser?.displayName ?? "guest";
    DocumentReference slotRef = _firestore.collection(courtName).doc(todayDate);

    await slotRef.set({
      position: {time: userId},
    }, SetOptions(merge: true));

    DocumentReference userSlots =
        _firestore.collection("userData").doc(userEmail);

    await userSlots.set({
      todayDate: {
        DateTime.now().millisecondsSinceEpoch.toString(): {
          'court': courtName[courtName.length - 1],
          'position': position[position.length - 1],
          'time': time[time.length - 1],
        }
      },
    }, SetOptions(merge: true)).whenComplete(
      () {
        print('sending email');
        sendEmail(userEmail, 'Booking Confirmation', 'Slot booked');
      },
    );

    // Refresh slots after booking
    fetchSlots();
  }

  Map<String, dynamic> _bookings = {};

  Map<String, dynamic> get bookings => _bookings;

  void fetchBookings() {
    _firestore
        .collection("userData")
        .doc(userEmail)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        _bookings = snapshot.data() ?? {};
        print(_bookings);
        notifyListeners();
      }
    });
  }

  Future<void> cancelBooking(String date, bookingId) async {
    String userEmail = _auth.currentUser?.email ?? "guest";
    await _firestore
        .collection("userData")
        .doc(userEmail)
        .update({"$date.$bookingId": FieldValue.delete()});

    // _bookings.remove(booking);
    notifyListeners();
  }
}

class AuthProviderr with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;

  AuthProviderr() {
    _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners(); // Update UI when auth state changes
    });
  }

  User? get user => _user;

  // Configure Google Sign-In to only allow IIT Mandi students
  GoogleSignIn _configuredGoogleSignIn() {
    return GoogleSignIn(
      hostedDomain: "students.iitmandi.ac.in", // Restrict to IIT Mandi
      clientId:
          "661698209746-jugkbk56grotumn6frpf84iv8hb6h7qi.apps.googleusercontent.com",
    );
  }

  // Sign in with Google
  Future<User?> signInWithGoogle() async {
    try {
      final GoogleSignIn googleSignIn = _configuredGoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      if (googleUser == null) return null; // User canceled login

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      UserCredential userCredential =
          await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Error signing in with Google: $e");
      return null;
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }
}

