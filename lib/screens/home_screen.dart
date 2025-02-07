import 'package:badminton/screens/userBookinds.dart';
import 'package:badminton/services/providerSerivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// class HomeScreen extends StatefulWidget {
//   const HomeScreen({super.key});
//
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
//   String todayDate = DateFormat.yMMMd().format(DateTime.now());
//   List<Map<String, dynamic>> slotsAvailability = [];
//   bool isLoading = true;
//
//   @override
//   void initState() {
//     super.initState();
//     // fetchAvailableSlots();
//     fetchSlots();
//   }
//
//   Future<void> fetchSlots() async {
//     List<Map<String, dynamic>> data = [];
//     List<String> courts = ['Court1', 'Court2', 'Court3', 'Court4'];
//     Map<String, Map<String, dynamic>> biggerMap = {
//       'position1': {
//         'time1': false,
//         'time2': false,
//         'time3': false,
//         'time4': false,
//       },
//       'position2': {
//         'time1': false,
//         'time2': false,
//         'time3': false,
//         'time4': false,
//       },
//       'position3': {
//         'time1': false,
//         'time2': false,
//         'time3': false,
//         'time4': false,
//       },
//       'position4': {
//         'time1': false,
//         'time2': false,
//         'time3': false,
//         'time4': false,
//       }
//     };
//
//     for (String court in courts) {
//       DocumentReference slotRef = _firestore.collection(court).doc(todayDate);
//
//       DocumentSnapshot slotDoc = await slotRef.get();
//       if (slotDoc.exists) {
//         Map<String, dynamic> map = slotDoc.data() as Map<String, dynamic>;
//         Map<String, Map<String, dynamic>> updatedMap = {};
//         // Copy biggerMap structure into updatedMap
//         biggerMap.forEach((position, times) {
//           updatedMap[position] = Map.from(times);
//         });
//
//         map.forEach((position, times) {
//           if (updatedMap.containsKey(position)) {
//             times.forEach((time, value) {
//               if (updatedMap[position]!.containsKey(time)) {
//                 updatedMap[position]![time] = value; // Update value
//               }
//             });
//           }
//         });
//         data.add(updatedMap);
//       } else {
//         data.add(biggerMap);
//       }
//     }
//     print(data);
//
//     setState(() {
//       slotsAvailability = data;
//       isLoading = false;
//     });
//   }
//
//   void showBookingDialog(String courtName, String position, String timeSlot) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Confirm Booking"),
//           content: const Text("Do you want to book this slot?"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () {
//                 bookSlot(courtName, position, timeSlot);
//                 Navigator.pop(context);
//               },
//               child: const Text("Confirm"),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   Future<void> bookSlot(
//       String courtName, String position, String timeSlot) async {
//     String userId = "guest";
//     DocumentReference slotRef = _firestore.collection(courtName).doc(todayDate);
//     await slotRef.set(
//       {
//         position: {timeSlot: userId},
//       },
//       SetOptions(merge: true),
//     ).whenComplete(() {
//       fetchSlots();
//       ScaffoldMessenger.of(context).showSnackBar(
//         const SnackBar(
//           content: Text("Slot Booked"),
//           duration: Duration(milliseconds: 300),
//         ),
//       );
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Badminton Court Booking")),
//       body: isLoading
//           ? const Center(child: CircularProgressIndicator())
//           : ListView.builder(
//               itemCount: slotsAvailability.length,
//               itemBuilder: (context, courtIndex) {
//                 var court = slotsAvailability[courtIndex];
//                 String courtName = "Court${courtIndex + 1}";
//                 return Card(
//                   margin: const EdgeInsets.all(8),
//                   child: Column(
//                     children: [
//                       ListTile(
//                         title: Text("Court ${courtIndex + 1}"),
//                         tileColor: Colors.blueAccent,
//                         textColor: Colors.white,
//                       ),
//                       Column(
//                         children: court.keys.map<Widget>((position) {
//                           return Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   position,
//                                   style: const TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 Wrap(
//                                   spacing: 8,
//                                   children: court[position]!
//                                       .keys
//                                       .map<Widget>((timeSlot) {
//                                     bool isAvailable;
//                                     if (court[position]![timeSlot] is String) {
//                                       isAvailable = true;
//                                     } else {
//                                       isAvailable = false;
//                                     }
//                                     return ElevatedButton(
//                                       style: ButtonStyle(
//                                         backgroundColor: isAvailable
//                                             ? const WidgetStatePropertyAll(
//                                                 Colors.red)
//                                             : const WidgetStatePropertyAll(
//                                                 Colors.green),
//                                       ),
//                                       onPressed: !isAvailable
//                                           ? () => showBookingDialog(
//                                               courtName, position, timeSlot)
//                                           : null,
//                                       child: Text(
//                                         "$timeSlot",
//                                         style: const TextStyle(
//                                           color: Colors.white,
//                                         ),
//                                       ),
//                                     );
//                                   }).toList(),
//                                 ),
//                               ],
//                             ),
//                           );
//                         }).toList(),
//                       )
//                     ],
//                   ),
//                 );
//               },
//             ),
//     );
//   }
// }

class HomeScreenn extends StatelessWidget {
  const HomeScreenn({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    void showBookingDialog(String courtName, String position, String timeSlot) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Confirm Booking"),
            content: const Text("Do you want to book this slot?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              TextButton(
                onPressed: () {
                  bookingProvider.bookSlot(courtName, position, timeSlot);
                  Navigator.pop(context);
                },
                child: const Text("Confirm"),
              ),
            ],
          );
        },
      );
    }

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Badminton Court Booking"),
        leading: IconButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const UserBookingsScreen(),
            ),
          ),
          icon: const Icon(Icons.person),
        ),
      ),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: bookingProvider.slotsAvailability.length,
              itemBuilder: (context, courtIndex) {
                var court = bookingProvider.slotsAvailability[courtIndex];
                String courtName = "Court${courtIndex + 1}";

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(courtName),
                        tileColor: Colors.blueAccent,
                        textColor: Colors.white,
                      ),
                      Column(
                        children: court.keys.map<Widget>((position) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  position,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Wrap(
                                  spacing: 8,
                                  children: court[position]!
                                      .keys
                                      .map<Widget>((timeSlot) {
                                    bool isAvailable;
                                    if (court[position]![timeSlot] is String) {
                                      isAvailable = false;
                                    } else {
                                      isAvailable = true;
                                    }
                                    return GestureDetector(
                                      onTap: isAvailable
                                          ? () => showBookingDialog(
                                              courtName, position, timeSlot)
                                          : null,
                                      child: Chip(
                                        label: Text(timeSlot),
                                        backgroundColor: isAvailable
                                            ? Colors.green
                                            : Colors.red,
                                        labelStyle: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
