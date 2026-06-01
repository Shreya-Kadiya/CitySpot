import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/parking_provider.dart';
import '../../../models/parking_spot.dart';
import '../details/spot_details_screen.dart';

class ParkingMapScreen extends ConsumerStatefulWidget {
  const ParkingMapScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ParkingMapScreen> createState() => _ParkingMapScreenState();
}

class _ParkingMapScreenState extends ConsumerState<ParkingMapScreen> {
  final MapController _mapController = MapController();
  ParkingSpot? _selectedSpot;

  // Center coordinate - San Francisco Downtown
  final LatLng _sfCenter = const LatLng(37.7879, -122.4014);

  @override
  Widget build(BuildContext context) {
    final spots = ref.watch(parkingProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // OpenStreetMap Map Layer
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _sfCenter,
              initialZoom: 14.5,
              onTap: (_, __) {
                setState(() {
                  _selectedSpot = null;
                });
              },
            ),
            children: [
              TileLayer(
                urlTemplate: isDark
                    ? 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png'
                    : 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: spots.map((spot) {
                  final isSelected = _selectedSpot?.id == spot.id;
                  return Marker(
                    point: LatLng(spot.latitude, spot.longitude),
                    width: 50,
                    height: 50,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedSpot = spot;
                        });
                        _mapController.move(
                          LatLng(spot.latitude - 0.002,
                              spot.longitude), // slightly center to allow details card overlap
                          _mapController.camera.zoom,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        decoration: BoxDecoration(
                          color: isSelected ? AppColors.primary : Colors.white,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color:
                                isSelected ? Colors.white : AppColors.primary,
                            width: 2.5,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.local_parking_rounded,
                          color: isSelected ? Colors.white : AppColors.primary,
                          size: 24,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Search Header overlay
          Positioned(
            top: 60,
            left: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 56,
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                children: [
                  const Icon(Icons.arrow_back_ios_new, size: 18),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'San Francisco, CA',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 24,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(width: 12),
                  const Icon(Icons.filter_list_rounded,
                      color: AppColors.primary),
                ],
              ),
            ),
          ),

          // Float Buttons (GPS + Filters)
          Positioned(
            right: 20,
            bottom: _selectedSpot != null ? 220 : 40,
            child: Column(
              children: [
                FloatingActionButton.small(
                  heroTag: 'map_layer',
                  backgroundColor: isDark ? AppColors.cardDark : Colors.white,
                  foregroundColor: isDark ? Colors.white : Colors.black,
                  onPressed: () {},
                  child: const Icon(Icons.layers_outlined),
                ),
                const SizedBox(height: 12),
                FloatingActionButton(
                  heroTag: 'gps',
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  onPressed: () {
                    _mapController.move(_sfCenter, 14.5);
                  },
                  child: const Icon(Icons.my_location),
                ),
              ],
            ),
          ),

          // Selected Spot Details Panel
          if (_selectedSpot != null)
            Positioned(
              bottom: 24,
              left: 20,
              right: 20,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          SpotDetailsScreen(spot: _selectedSpot!),
                    ),
                  );
                },
                child: Container(
                  height: 140,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color:
                          isDark ? AppColors.borderDark : AppColors.borderLight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.12),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(20),
                          bottomLeft: Radius.circular(20),
                        ),
                        child: Image.network(
                          _selectedSpot!.imageUrl,
                          width: 130,
                          height: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(child: Icon(Icons.image)),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                _selectedSpot!.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _selectedSpot!.address,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textDarkSecondary
                                      : AppColors.textLightSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      color: Colors.amber, size: 14),
                                  const SizedBox(width: 4),
                                  Text(
                                    _selectedSpot!.rating.toString(),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    '${_selectedSpot!.availableSlotsCount} slots open',
                                    style: GoogleFonts.outfit(
                                      fontSize: 12,
                                      color: AppColors.iotAvailable,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '\$${_selectedSpot!.pricePerHour.toStringAsFixed(2)}/hr',
                                    style: GoogleFonts.outfit(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                  const Icon(Icons.arrow_forward,
                                      size: 18, color: AppColors.primary),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
