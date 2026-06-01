import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/parking_provider.dart';
import '../../../models/parking_spot.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/widgets/vehicle_icon.dart';
import '../details/spot_details_screen.dart';

class DiscoveryScreen extends ConsumerStatefulWidget {
  const DiscoveryScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends ConsumerState<DiscoveryScreen> {
  bool _isGridView = false;
  String _searchQuery = '';
  VehicleType _selectedVehicleFilter = VehicleType.car;
  String _sortBy = 'distance'; // 'distance', 'price', 'rating'
  List<ParkingType> _selectedTypes = [];

  void _toggleParkingTypeFilter(ParkingType type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final spots = ref.watch(parkingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Filter spots based on selection
    List<ParkingSpot> filteredSpots = spots.where((spot) {
      // 1. Search Query
      if (_searchQuery.isNotEmpty &&
          !spot.name.toLowerCase().contains(_searchQuery.toLowerCase()) &&
          !spot.address.toLowerCase().contains(_searchQuery.toLowerCase())) {
        return false;
      }

      // 2. Vehicle Type support check (spot must have at least one slot supporting the selected vehicle type)
      final supportsVehicle = spot.slots.any((slot) => slot.supportedVehicle == _selectedVehicleFilter);
      if (!supportsVehicle) return false;

      // 3. Parking Types
      if (_selectedTypes.isNotEmpty && !_selectedTypes.contains(spot.type)) {
        return false;
      }

      return true;
    }).toList();

    // Sort spots
    if (_sortBy == 'distance') {
      filteredSpots.sort((a, b) => a.distanceKm.compareTo(b.distanceKm));
    } else if (_sortBy == 'price') {
      filteredSpots.sort((a, b) => a.pricePerHour.compareTo(b.pricePerHour));
    } else if (_sortBy == 'rating') {
      filteredSpots.sort((a, b) => b.rating.compareTo(a.rating)); // highest rating first
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Discover Parking'),
        actions: [
          IconButton(
            icon: Icon(_isGridView ? Icons.view_list_rounded : Icons.grid_view_rounded),
            onPressed: () {
              setState(() {
                _isGridView = !_isGridView;
              });
            },
          )
        ],
      ),
      body: Column(
        children: [
          // Search & Filter header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                    decoration: InputDecoration(
                      hintText: 'Search by location or plaza...',
                      prefixIcon: const Icon(Icons.search, size: 20),
                      contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Vehicle Filter Horizontal Selector Tabs
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: VehicleType.values.map((type) {
                final isSelected = _selectedVehicleFilter == type;
                String label = 'Car';
                if (type == VehicleType.bike) label = 'Bike';
                if (type == VehicleType.ev) label = 'EV';
                if (type == VehicleType.rickshaw) label = 'Rickshaw';

                return ChoiceChip(
                  avatar: VehicleIcon(
                    type: type,
                    size: 16,
                    color: isSelected ? Colors.white : (isDark ? Colors.grey : Colors.black87),
                  ),
                  label: Text(label),
                  selected: isSelected,
                  onSelected: (selected) {
                    if (selected) {
                      setState(() {
                        _selectedVehicleFilter = type;
                      });
                    }
                  },
                );
              }).toList(),
            ),
          ),

          // Sort & Category Pills
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
            child: Row(
              children: [
                // Sort Dropdown button mockup style
                PopupMenuButton<String>(
                  initialValue: _sortBy,
                  onSelected: (value) {
                    setState(() {
                      _sortBy = value;
                    });
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 'distance', child: Text('Sort by Distance')),
                    const PopupMenuItem(value: 'price', child: Text('Sort by Price')),
                    const PopupMenuItem(value: 'rating', child: Text('Sort by Rating')),
                  ],
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.secondary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.secondary.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.sort_rounded, size: 16, color: AppColors.secondary),
                        const SizedBox(width: 6),
                        Text(
                          _sortBy == 'distance' ? 'Distance' : (_sortBy == 'price' ? 'Price' : 'Rating'),
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.secondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Parking Types Horizontal List
                ...ParkingType.values.map((type) {
                  final isSelected = _selectedTypes.contains(type);
                  String label = 'Residential';
                  if (type == ParkingType.society) label = 'Society';
                  if (type == ParkingType.apartment) label = 'Apartment';
                  if (type == ParkingType.commercial) label = 'Commercial';
                  if (type == ParkingType.mall) label = 'Mall';
                  if (type == ParkingType.public) label = 'Public';
                  if (type == ParkingType.event) label = 'Event';

                  return Padding(
                    padding: const EdgeInsets.only(right: 6.0),
                    child: FilterChip(
                      label: Text(label, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      onSelected: (selected) => _toggleParkingTypeFilter(type),
                    ),
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Main List / Grid Content
          Expanded(
            child: filteredSpots.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.search_off_rounded, size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        Text(
                          'No parking spots found',
                          style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : _isGridView
                    ? GridView.builder(
                        padding: const EdgeInsets.all(16),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.78,
                          crossAxisSpacing: 16,
                          mainAxisSpacing: 16,
                        ),
                        itemCount: filteredSpots.length,
                        itemBuilder: (context, index) {
                          final spot = filteredSpots[index];
                          return _buildGridCard(spot, isDark);
                        },
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: filteredSpots.length,
                        itemBuilder: (context, index) {
                          final spot = filteredSpots[index];
                          return _buildListCard(spot, isDark);
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildListCard(ParkingSpot spot, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SpotDetailsScreen(spot: spot)),
        );
      },
      child: Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                bottomLeft: Radius.circular(16),
              ),
              child: Image.network(
                spot.imageUrl,
                width: 120,
                height: 120,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          spot.typeLabel,
                          style: GoogleFonts.outfit(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              spot.rating.toString(),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      spot.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${spot.distanceKm} km away • ${spot.address}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontSize: 12,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StatusBadge(
                          status: spot.availableSlotsCount > 0
                              ? ParkingSpotStatus.available
                              : ParkingSpotStatus.occupied,
                          showDot: false,
                        ),
                        Text(
                          '\$${spot.pricePerHour.toStringAsFixed(2)}/hr',
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridCard(ParkingSpot spot, bool isDark) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => SpotDetailsScreen(spot: spot)),
        );
      },
      child: Card(
        margin: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
              child: Image.network(
                spot.imageUrl,
                height: 100,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => const Center(child: Icon(Icons.image)),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          spot.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${spot.distanceKm} km away',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '\$${spot.pricePerHour.toStringAsFixed(2)}/hr',
                          style: GoogleFonts.outfit(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star, color: Colors.amber, size: 12),
                            const SizedBox(width: 2),
                            Text(
                              spot.rating.toString(),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ],
                    ),
                    StatusBadge(
                      status: spot.availableSlotsCount > 0
                          ? ParkingSpotStatus.available
                          : ParkingSpotStatus.occupied,
                      showDot: false,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
