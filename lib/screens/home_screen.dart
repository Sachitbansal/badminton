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
    // Get screen size for responsive design
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0E21),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: size.height * 0.25, // Responsive height
            floating: true,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                "BADMINTON COURTS",
                style: TextStyle(
                    fontSize: isSmallScreen ? 16 : 30,
                    fontWeight: FontWeight.w600),
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
                icon: Icon(
                  Icons.book,
                  size: isSmallScreen ? 20 : 50,
                  color: Colors.black,
                ),
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
                      width: size.width * 0.3,
                      height: size.width * 0.3,
                    ),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, courtIndex) {
                      var court = bookingProvider.slotsAvailability[courtIndex];
                      String courtName = "Court ${courtIndex + 1}";

                      return Padding(
                        padding: EdgeInsets.all(size.width * 0.03),
                        child: PhysicalModel(
                          color: Colors.transparent,
                          elevation: 15,
                          borderRadius: BorderRadius.circular(20),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: LinearGradient(
                                colors: [
                                  Colors.blueGrey.shade900,
                                  Colors.blueGrey.shade800,
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                            ),
                            child: Column(
                              children: [
                                // Court Header with responsive padding and text
                                Container(
                                  padding: EdgeInsets.all(size.width * 0.04),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.3),
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(Icons.sports_tennis,
                                          color: Colors.white70),
                                      SizedBox(width: size.width * 0.02),
                                      Text(
                                        courtName,
                                        style: TextStyle(
                                            fontSize: isSmallScreen ? 18 : 22,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        icon: const Icon(Icons.info_outline),
                                        color: Colors.white70,
                                        onPressed: () =>
                                            _showCourtInfo(context),
                                      ),
                                    ],
                                  ),
                                ),

                                // Time Slots Grid with responsive sizing
                                Padding(
                                  padding: EdgeInsets.all(size.width * 0.04),
                                  child: GridView.builder(
                                    shrinkWrap: true,
                                    physics:
                                        const NeverScrollableScrollPhysics(),
                                    gridDelegate:
                                        SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2,
                                      childAspectRatio:
                                          isSmallScreen ? 1.8 : 2.2,
                                      mainAxisSpacing: size.width * 0.02,
                                      crossAxisSpacing: size.width * 0.02,
                                    ),
                                    itemCount: court.keys.length,
                                    itemBuilder: (context, positionIndex) {
                                      String position =
                                          court.keys.elementAt(positionIndex);
                                      return _buildTimeSlotCard(
                                        context,
                                        position: position,
                                        slots: court[position]!,
                                        courtName: courtName,
                                        isSmallScreen: isSmallScreen,
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
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
    required bool isSmallScreen,
  }) {
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => _handleSlotTap(context, courtName, position, slots),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withOpacity(0.1),
            ),
          ),
          padding: EdgeInsets.all(isSmallScreen ? 8 : 10),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  position,
                  style: TextStyle(
                    color: Colors.white70,
                    fontWeight: FontWeight.bold,
                    fontSize: isSmallScreen ? 14 : 30,
                  ),
                ),
                SizedBox(height: isSmallScreen ? 3 : 16),
                Wrap(
                  spacing: 8,
                  runSpacing: 5,
                  children: slots.entries.map((entry) {
                    bool isAvailable = entry.value is! String;
                    return SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 4 : 6,
                          vertical: isSmallScreen ? 1 : 2,
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
                            color: isAvailable
                                ? Colors.lightGreen
                                : Colors.redAccent,
                            fontSize: isSmallScreen ? 10 : 25,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleSlotTap(BuildContext context, String courtName, String position,
      Map<String, dynamic> slots) {
    final size = MediaQuery.of(context).size;
    final isSmallScreen = size.width < 360;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.all(size.width * 0.05),
        decoration: BoxDecoration(
          color: Colors.blueGrey.shade900,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Available Slots for $position",
              style: TextStyle(
                fontSize: isSmallScreen ? 16 : 18,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: size.height * 0.02),
            Wrap(
              spacing: size.width * 0.02,
              runSpacing: size.width * 0.02,
              direction: Axis.horizontal,
              children: slots.entries.map((entry) {
                bool isAvailable = entry.value is! String;
                return ChoiceChip(
                  label: Text(
                    entry.key.replaceAll("time", ""),
                    style: TextStyle(fontSize: isSmallScreen ? 12 : 14),
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
            SizedBox(height: size.height * 0.02),
          ],
        ),
      ),
    );
  }

  void _confirmBooking(
      BuildContext context, String court, String position, String time) {
    final size = MediaQuery.of(context).size;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade900,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text("Confirm Booking",
            style: TextStyle(color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: size.height * 0.01),
            Text(
              "$court • $position • $time",
              style: const TextStyle(color: Colors.white70),
            ),
          ],
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4)),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 10),
            Text("Booking Successful!"),
          ],
        ),
      ),
    );
  }
  // Add these missing methods inside the HomeScreen class

  void _showCourtInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.blueGrey.shade900,
        title: const Text('Court Information',
            style: TextStyle(color: Colors.white)),
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
            style: ButtonStyle(
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4)))),
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
          borderRadius: const BorderRadius.vertical(top: Radius.circular(25)),
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Filter Courts',
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            _buildFilterOption('Available Only', Icons.event_available),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blueAccent,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15)),
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
      leading: Icon(icon, color: Colors.white70),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: Switch(
        value: false,
        onChanged: (value) {},
        activeColor: Colors.blueAccent,
      ),
    );
  }
}
