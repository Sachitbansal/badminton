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
        body: LayoutBuilder(
          builder: (context, constraints) {
            bool isDesktop = constraints.maxWidth > 900;
            bool isTablet =
                constraints.maxWidth > 600 && constraints.maxWidth <= 900;
            double titleFontSize = isDesktop ? 22 : (isTablet ? 20 : 18);
            double contentFontSize = isDesktop ? 18 : (isTablet ? 16 : 14);
            double paddingSize = isDesktop ? 30 : (isTablet ? 20 : 10);

            return Consumer<BookingProvider>(
              builder: (context, provider, child) {
                if (provider.bookings.isEmpty) {
                  return const Center(
                    child: Text(
                      "No bookings found",
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                  );
                }
                return SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.all(paddingSize),
                    child: ListView.builder(
                      shrinkWrap: true, // Ensures it doesn’t expand infinitely
                      physics:
                          const NeverScrollableScrollPhysics(), // Prevents nested scrolling issues
                      itemCount: provider.bookings.length,
                      itemBuilder: (context, index) {
                        String date = provider.bookings.keys.elementAt(index);
                        Map<String, dynamic> bookingsForDate =
                            provider.bookings[date];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: ExpansionTile(
                            title: Text(
                              "Date: $date",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: titleFontSize,
                              ),
                            ),
                            children: bookingsForDate.entries.map((booking) {
                              String bookingId = booking.key;
                              Map<String, dynamic> details = booking.value;
                              return ListTile(
                                title: Text(
                                  "Court: ${details['court']}, Position: ${details['position']}",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: contentFontSize),
                                ),
                                subtitle: Text(
                                  "Time: ${details['time']}",
                                  style:
                                      TextStyle(fontSize: contentFontSize - 2),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.cancel,
                                      color: Colors.red),
                                  onPressed: () =>
                                      provider.cancelBooking(date, bookingId),
                                ),
                              );
                            }).toList(),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
