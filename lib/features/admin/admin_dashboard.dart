import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/role_provider.dart';
import '../../models/user_model.dart';
import '../../providers/parking_provider.dart';
import '../../providers/booking_provider.dart';
import '../../core/widgets/status_badge.dart';

class AdminDashboard extends ConsumerStatefulWidget {
  const AdminDashboard({Key? key}) : super(key: key);

  @override
  ConsumerState<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends ConsumerState<AdminDashboard> {
  int _selectedTab = 0;

  final List<String> _tabs = [
    'Analytics Overview',
    'User Management',
    'Parking Plazas',
    'Booking Monitor',
    'Dispute Resolutions',
    'System Configuration'
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final spots = ref.watch(parkingProvider);
    final bookings = ref.watch(bookingProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.local_parking_rounded, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 10),
            Text(
              'CitySpot Admin Portal',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18),
            ),
          ],
        ),
        actions: [
          // Switch back role shortcut
          TextButton.icon(
            icon: const Icon(Icons.swap_horiz, size: 18),
            label: Text(
              'Exit Admin',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              ref.read(roleProvider.notifier).setRole(UserRole.driver);
            },
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 800;

          if (isWide) {
            // Desktop/Web Sidebar Layout
            return Row(
              children: [
                // Sidebar panel
                Container(
                  width: 250,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    border: Border(
                      right: BorderSide(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                      ),
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: _tabs.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedTab == index;
                      return ListTile(
                        selected: isSelected,
                        selectedColor: AppColors.primary,
                        title: Text(
                          _tabs[index],
                          style: GoogleFonts.outfit(
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          setState(() {
                            _selectedTab = index;
                          });
                        },
                      );
                    },
                  ),
                ),
                // Main Panel Content
                Expanded(
                  child: Container(
                    color: isDark ? AppColors.bgDark : AppColors.bgLight,
                    padding: const EdgeInsets.all(32),
                    child: _buildTabContent(_selectedTab, spots, bookings, isDark),
                  ),
                ),
              ],
            );
          } else {
            // Mobile screen scrollable layout
            return Column(
              children: [
                // Horizontal scrollable tabs selector
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    children: List.generate(_tabs.length, (index) {
                      final isSelected = _selectedTab == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: ChoiceChip(
                          label: Text(_tabs[index]),
                          selected: isSelected,
                          onSelected: (selected) {
                            if (selected) {
                              setState(() {
                                _selectedTab = index;
                              });
                            }
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: _buildTabContent(_selectedTab, spots, bookings, isDark),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildTabContent(int index, List spots, List bookings, bool isDark) {
    switch (index) {
      case 0:
        return _buildAnalyticsTab(spots, bookings, isDark);
      case 1:
        return _buildUserManagementTab(isDark);
      case 2:
        return _buildParkingManagementTab(spots, isDark);
      case 3:
        return _buildBookingMonitorTab(bookings, isDark);
      case 4:
        return _buildDisputeResolutionTab(isDark);
      case 5:
        return _buildSystemConfigTab(isDark);
      default:
        return const Center(child: Text('Content Loading...'));
    }
  }

  Widget _buildAnalyticsTab(List spots, List bookings, bool isDark) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('System Analytics', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(child: _buildStatsCard('Total Registered Drivers', '14,802', Icons.people_outline, AppColors.secondary, isDark)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatsCard('Total Listed Plazas', spots.length.toString(), Icons.local_parking_rounded, AppColors.primary, isDark)),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(child: _buildStatsCard('Active Hourly Bookings', bookings.length.toString(), Icons.bolt, AppColors.iotAvailable, isDark)),
              const SizedBox(width: 16),
              Expanded(child: _buildStatsCard('Total System Payouts', '\$148,930', Icons.account_balance, AppColors.iotReserved, isDark)),
            ],
          ),
          const SizedBox(height: 32),
          Text('Active Spot Telemetry Chart', style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Container(
            height: 180,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? AppColors.cardDark : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
            ),
            child: Center(
              child: Text(
                '[ Real-Time IoT Occupancy Graph Display ]',
                style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildUserManagementTab(bool isDark) {
    final mockDrivers = [
      {'name': ' Sarah Jenkins', 'email': 'sarah.j@gmail.com', 'role': 'Driver / Owner'},
      {'name': 'Nishant Patel', 'email': 'nishant.patel@outlook.com', 'role': 'Driver'},
      {'name': 'Alex Rivera', 'email': 'rivera.alex@yahoo.com', 'role': 'Driver'},
      {'name': 'Emma Watson', 'email': 'emma@smartcity.org', 'role': 'Driver / Owner'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('User Accounts', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: mockDrivers.length,
            itemBuilder: (context, index) {
              final user = mockDrivers[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(user['name']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(user['email']!),
                  trailing: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(user['role']!, style: const TextStyle(fontSize: 11, color: AppColors.secondary, fontWeight: FontWeight.bold)),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildParkingManagementTab(List spots, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Listed Parking Plazas', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: spots.length,
            itemBuilder: (context, index) {
              final spot = spots[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Image.network(spot.imageUrl, width: 50, height: 50, fit: BoxFit.cover, errorBuilder: (c, e, s) => const Icon(Icons.image)),
                  title: Text(spot.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(spot.address, maxLines: 1, overflow: TextOverflow.ellipsis),
                  trailing: StatusBadge(
                    status: spot.availableSlotsCount > 0 ? ParkingSpotStatus.available : ParkingSpotStatus.occupied,
                    showDot: false,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildBookingMonitorTab(List bookings, bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Booking Transactions Monitor', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              final bk = bookings[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(bk.spot.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Vehicle: ${bk.vehicle.plateNumber} • Passcode: ${bk.passcode}'),
                  trailing: Text('\$${bk.totalAmount.toStringAsFixed(2)}', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDisputeResolutionTab(bool isDark) {
    final mockDisputes = [
      {'title': 'Overcharge claim: Slot A2 Sensor Error', 'status': 'Pending Resolution', 'user': 'Sarah Jenkins'},
      {'title': 'Access blocked: Gate barcode did not print', 'status': 'Resolved', 'user': 'Alex Rivera'},
      {'title': 'Incorrect occupancy feed at Rincon Plaza', 'status': 'Investigating', 'user': 'Emma Watson'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Disputes Log', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.builder(
            itemCount: mockDisputes.length,
            itemBuilder: (context, index) {
              final dispute = mockDisputes[index];
              final isPending = dispute['status'] == 'Pending Resolution';

              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(dispute['title']!, style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('Reported by: ${dispute['user']!}'),
                  trailing: Chip(
                    label: Text(dispute['status']!, style: const TextStyle(fontSize: 11)),
                    backgroundColor: isPending ? Colors.redAccent.withOpacity(0.12) : AppColors.iotAvailable.withOpacity(0.12),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSystemConfigTab(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('System Config', style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold)),
        const SizedBox(height: 24),
        SwitchListTile(
          title: const Text('Enable IoT automatic pricing multipliers'),
          subtitle: const Text('Increase hourly rate during peak congestion automatically.'),
          value: true,
          onChanged: (v) {},
        ),
        const Divider(),
        SwitchListTile(
          title: const Text('Maintenance Mode (Global)'),
          subtitle: const Text('Pause all booking checks globally for API updates.'),
          value: false,
          onChanged: (v) {},
        ),
        const Divider(),
        ListTile(
          title: const Text('Webhook Gateway URL'),
          subtitle: const Text('https://api.cityspot-iot.com/v1/telemetry'),
          trailing: const Icon(Icons.edit_outlined),
          onTap: () {},
        ),
      ],
    );
  }

  Widget _buildStatsCard(String title, String value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.cardDark : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary, fontSize: 12)),
              const SizedBox(height: 6),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            ],
          ),
          Icon(icon, color: color, size: 24),
        ],
      ),
    );
  }
}
