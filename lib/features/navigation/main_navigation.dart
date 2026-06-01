import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/role_provider.dart';
import '../../models/user_model.dart';

// Import features
import '../driver/home/home_dashboard.dart';
import '../driver/map/parking_map_screen.dart';
import '../driver/discovery/discovery_screen.dart';
import '../driver/history/booking_history_screen.dart';
import '../profile/profile_screen.dart';

import '../owner/dashboard/owner_dashboard.dart';
import '../owner/parking_mgmt/parking_list_screen.dart';
import '../owner/booking_mgmt/owner_bookings_screen.dart';
import '../owner/earnings/earnings_screen.dart';

import '../admin/admin_dashboard.dart';

class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({Key? key}) : super(key: key);

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  int _driverIndex = 0;
  int _ownerIndex = 0;

  // Driver Tabs
  final List<Widget> _driverScreens = [
    const HomeDashboard(),
    const DiscoveryScreen(),
    const ParkingMapScreen(),
    const BookingHistoryScreen(),
    const ProfileScreen(),
  ];

  // Owner Tabs
  final List<Widget> _ownerScreens = [
    const OwnerDashboard(),
    const ParkingListScreen(),
    const OwnerBookingsScreen(),
    const EarningsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final currentRole = ref.watch(roleProvider);

    // If Admin, render Admin Dashboard UI directly (responsive layouts built-in)
    if (currentRole == UserRole.admin) {
      return const AdminDashboard();
    }

    final isDriver = currentRole == UserRole.driver;
    final currentIndex = isDriver ? _driverIndex : _ownerIndex;
    final currentScreenList = isDriver ? _driverScreens : _ownerScreens;

    // Driver Items
    final List<BottomNavigationBarItem> driverItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.home_outlined),
        activeIcon: Icon(Icons.home),
        label: 'Home',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.search),
        activeIcon: Icon(Icons.search_rounded),
        label: 'Search',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.map_outlined),
        activeIcon: Icon(Icons.map),
        label: 'Map',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.book_online_outlined),
        activeIcon: Icon(Icons.book_online),
        label: 'Bookings',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    // Owner Items
    final List<BottomNavigationBarItem> ownerItems = const [
      BottomNavigationBarItem(
        icon: Icon(Icons.dashboard_outlined),
        activeIcon: Icon(Icons.dashboard),
        label: 'Dashboard',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.local_parking_rounded),
        activeIcon: Icon(Icons.local_parking_rounded),
        label: 'Parking',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.format_list_bulleted),
        activeIcon: Icon(Icons.format_list_bulleted_rounded),
        label: 'Bookings',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.analytics_outlined),
        activeIcon: Icon(Icons.analytics),
        label: 'Earnings',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.person_outline),
        activeIcon: Icon(Icons.person),
        label: 'Profile',
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: currentIndex,
        children: currentScreenList,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        items: isDriver ? driverItems : ownerItems,
        onTap: (index) {
          setState(() {
            if (isDriver) {
              _driverIndex = index;
            } else {
              _ownerIndex = index;
            }
          });
        },
      ),
    );
  }
}
