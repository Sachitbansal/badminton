import 'package:badminton/screens/userBookinds.dart';
import 'package:badminton/services/providerSerivice.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookingProvider = Provider.of<BookingProvider>(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: const Text(
                "BADMINTON COURTS",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.deepPurple.shade800,
                      Colors.blueAccent.shade700,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.book, size: 24, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const UserBookingsScreen()),
                ),
              ),
            ],
          ),
          bookingProvider.isLoading
              ? SliverFillRemaining(
                  child: Center(
                    child: Lottie.network(
                      'https://assets10.lottiefiles.com/packages/lf20_x62chJ.json',
                      width: 100,
                      height: 100,
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, courtIndex) {
                      var court = bookingProvider.slotsAvailability[courtIndex];
                      String courtName = "Court ${courtIndex + 1}";

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        child: Card(
                          elevation: 4,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          color: Colors.blueGrey.shade900,
                          child: Column(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.sports_tennis,
                                    color: Colors.white70),
                                title: Text(
                                  courtName,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                trailing: IconButton(
                                  icon: const Icon(Icons.info_outline,
                                      color: Colors.white70),
                                  onPressed: () => _showCourtInfo(context),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(12),
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: court.keys.length,
                                  itemBuilder: (context, positionIndex) {
                                    String position =
                                        court.keys.elementAt(positionIndex);
                                    return _buildTimeSlotCard(
                                      context,
                                      position: position,
                                      slots: court[position]!,
                                      courtName: courtName,
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: bookingProvider.slotsAvailability.length,
                  ),
                ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showFilterDialog(context),
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.filter_list),
      ),
    );
  }

  Widget _buildTimeSlotCard(
    BuildContext context, {
    required String position,
    required Map<String, dynamic> slots,
    required String courtName,
  }) {
    return Card(
      color: Colors.black.withOpacity(0.2),
      margin: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => _handleSlotTap(context, courtName, position, slots),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                position,
                style: const TextStyle(
                  color: Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: slots.entries.map((entry) {
                  bool isAvailable = entry.value is! String;
                  return Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isAvailable
                          ? Colors.green.withOpacity(0.2)
                          : Colors.red.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      entry.key.replaceAll("Time", ""),
                      style: TextStyle(
                        color:
                            isAvailable ? Colors.lightGreen : Colors.redAccent,
                        fontSize: 14,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _handleSlotTap(
    BuildContext context,
    String courtName,
    String position,
    Map<String, dynamic> slots,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Available Slots for $position",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: slots.entries.map((entry) {
                bool isAvailable = entry.value is! String;
                return ChoiceChip(
                  label: Text(
                    entry.key.replaceAll("time", ""),
                    style: const TextStyle(fontSize: 14),
                  ),
                  selected: false,
                  onSelected: isAvailable
                      ? (selected) => _confirmBooking(
                          context, courtName, position, entry.key)
                      : null,
                  backgroundColor: Colors.blueGrey.shade800,
                  selectedColor: Colors.blueAccent,
                  labelStyle: TextStyle(
                    color: isAvailable ? Colors.white : Colors.grey,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(
    BuildContext context,
    String court,
    String position,
    String time,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Text(
          "Confirm Booking",
          style: TextStyle(color: Colors.white),
        ),
        content: Text(
          "$court • $position • $time",
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            onPressed: () {
              Provider.of<BookingProvider>(context, listen: false)
                  .bookSlot(court, position, time);
              Navigator.pop(context);
              _showSuccess(context);
            },
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _showSuccess(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        margin: const EdgeInsets.all(8),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Text("Booking Successful!"),
          ],
        ),
      ),
    );
  }

  void _showCourtInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade900,
        title: const Text(
          'Court Information',
          style: TextStyle(color: Colors.white),
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• 44 ft long by 17 ft',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('• Synthetic flooring',
                style: TextStyle(color: Colors.white70)),
            SizedBox(height: 8),
            Text('• Professional-grade lighting',
                style: TextStyle(color: Colors.white70)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Filter Courts',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _buildFilterOption('Available Only', Icons.event_available),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                minimumSize: const Size(double.infinity, 48),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.white70, size: 24),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white, fontSize: 16),
      ),
      trailing: Switch(
        value: false,
        onChanged: (value) {},
        activeColor: Colors.blueAccent,
      ),
    );
  }
}
