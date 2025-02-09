import 'package:badminton/screens/userBookinds.dart';
import 'package:badminton/services/providerSerivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
                onPressed: () async {
                  await bookingProvider.bookSlot(courtName, position, timeSlot);
                  if (context.mounted) Navigator.of(context).pop();
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



class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);

    void showBookingDialog(String courtName, String position, String timeSlot) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            title: const Text("Confirm Booking"),
            content: const Text("Do you want to book this slot?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text("Cancel"),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
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
      backgroundColor: Colors.grey[100], // Light background
      appBar: AppBar(
        centerTitle: true,
        title: const Text("🏸 Badminton Court Booking"),
        backgroundColor: Colors.green[700],
        leading: IconButton(
          icon: const Icon(Icons.person, color: Colors.white),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const UserBookingsScreen()),
          ),
        ),
      ),
      body: bookingProvider.isLoading
          ? const Center(child: CircularProgressIndicator(color: Colors.green))
          : ListView.builder(
        padding: const EdgeInsets.all(10),
        itemCount: bookingProvider.slotsAvailability.length,
        itemBuilder: (context, courtIndex) {
          var court = bookingProvider.slotsAvailability[courtIndex];
          String courtName = "Court ${courtIndex + 1}";

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    tileColor: Colors.green[500],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    title: Text(
                      courtName,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    leading: const Icon(Icons.sports_tennis, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Column(
                    children: court.keys.map<Widget>((position) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 6),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              position,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: court[position]!.keys.map<Widget>((timeSlot) {
                                bool isAvailable =
                                court[position]![timeSlot] is! String;

                                return GestureDetector(
                                  onTap: isAvailable
                                      ? () => showBookingDialog(
                                      courtName, position, timeSlot)
                                      : null,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 12, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: isAvailable
                                          ? Colors.green
                                          : Colors.red,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      timeSlot,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
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
            ),
          );
        },
      ),
    );
  }
}
