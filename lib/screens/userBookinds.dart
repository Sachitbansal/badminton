import 'package:badminton/services/providerSerivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserBookingsScreen extends StatelessWidget {
  const UserBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => BookingProvider()..fetchBookings(),
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("My Bookings"),
          leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Consumer<BookingProvider>(
          builder: (context, provider, child) {
            if (provider.bookings.isEmpty) {
              return const Center(child: Text("No bookings found"));
            }
            return ListView(
              children: provider.bookings.entries.map((entry) {
                String date = entry.key;
                Map<String, dynamic> bookingsForDate = entry.value;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Date: $date",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 18)),
                    ),
                    ...bookingsForDate.entries.map((booking) {
                      String bookingId = booking.key;
                      Map<String, dynamic> details = booking.value;
                      return Card(
                        margin: const EdgeInsets.all(8),
                        child: ListTile(
                          title: Text(
                              "Court: ${details['court']}, Position: ${details['position']}"),
                          subtitle: Text("Time: ${details['time']}"),
                          trailing: IconButton(
                            icon: const Icon(Icons.cancel, color: Colors.red),
                            onPressed: () =>
                                provider.cancelBooking(date, bookingId),
                          ),
                        ),
                      );
                    }),
                  ],
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}
