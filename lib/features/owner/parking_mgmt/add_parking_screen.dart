import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../providers/parking_provider.dart';
import '../../../models/parking_spot.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/vehicle_icon.dart';
import '../../../core/widgets/status_badge.dart';

class AddParkingScreen extends ConsumerStatefulWidget {
  const AddParkingScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<AddParkingScreen> createState() => _AddParkingScreenState();
}

class _AddParkingScreenState extends ConsumerState<AddParkingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descController = TextEditingController();
  final _addressController = TextEditingController();
  final _priceController = TextEditingController();

  ParkingType _selectedType = ParkingType.residential;
  int _slotsCount = 4;
  bool _isLoading = false;

  final List<String> _availableAmenities = [
    '24/7 Security',
    'EV Charging',
    'Wheelchair Access',
    'CCTV',
    'Covered'
  ];
  final List<String> _selectedAmenities = [];

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      // Assemble mock slots
      final List<ParkingSlot> slots = List.generate(
        _slotsCount,
        (i) => ParkingSlot(
          id: 's_new_$i',
          label: 'Slot ${i + 1}',
          status: ParkingSpotStatus.available,
          supportedVehicle: i % 2 == 0 ? VehicleType.car : VehicleType.ev,
        ),
      );

      final newSpot = ParkingSpot(
        id: 'spot_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text,
        description: _descController.text,
        address: _addressController.text,
        imageUrl:
            'https://images.unsplash.com/photo-1506521788723-868151859b87?w=600',
        type: _selectedType,
        rating: 5.0,
        reviewsCount: 0,
        pricePerHour: double.parse(_priceController.text),
        latitude: 37.7749,
        longitude: -122.4194,
        distanceKm: 0.1,
        amenities: _selectedAmenities,
        rules: [
          'Only park inside marked boundaries',
          'Locked vehicle requested at all times'
        ],
        slots: slots,
      );

      Future.delayed(const Duration(milliseconds: 1500), () {
        setState(() {
          _isLoading = false;
        });
        ref.read(parkingProvider.notifier).addSpot(newSpot);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Parking Listing published successfully!'),
            backgroundColor: AppColors.iotAvailable,
          ),
        );
        Navigator.of(context).pop();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Parking Spot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'List Your Space',
                  style: GoogleFonts.outfit(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Offer slots to drivers and earn automatically.',
                  style: GoogleFonts.outfit(
                    fontSize: 14,
                    color: isDark
                        ? AppColors.textDarkSecondary
                        : AppColors.textLightSecondary,
                  ),
                ),
                const SizedBox(height: 28),

                // Plaza Name
                Text('Plaza / Listing Name',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                      hintText: 'e.g. Rincon Building Deck B'),
                  validator: (v) =>
                      v!.isEmpty ? 'Plaza name is required' : null,
                ),
                const SizedBox(height: 20),

                // Description
                Text('Detailed Description',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _descController,
                  maxLines: 3,
                  decoration: const InputDecoration(
                      hintText:
                          'Describe entry guidelines, height limits, access instructions...'),
                  validator: (v) =>
                      v!.isEmpty ? 'Description is required' : null,
                ),
                const SizedBox(height: 20),

                // Address
                Text('Address Location',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(
                      hintText: 'Street address, city, state, zip'),
                  validator: (v) =>
                      v!.isEmpty ? 'Location address is required' : null,
                ),
                const SizedBox(height: 20),

                // Price rate & Category
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Rate / Hour (\$)',
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _priceController,
                            keyboardType: const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration:
                                const InputDecoration(hintText: 'e.g. 4.00'),
                            validator: (v) {
                              if (v!.isEmpty) return 'Price rate is required';
                              if (double.tryParse(v) == null)
                                return 'Enter valid rate';
                              return null;
                            },
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Parking Type',
                              style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.w600)),
                          const SizedBox(height: 8),
                          DropdownButtonFormField<ParkingType>(
                            value: _selectedType,
                            decoration: const InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            items: ParkingType.values.map((type) {
                              String label = 'Residential';
                              if (type == ParkingType.society)
                                label = 'Society';
                              if (type == ParkingType.apartment)
                                label = 'Apartment';
                              if (type == ParkingType.commercial)
                                label = 'Commercial';
                              if (type == ParkingType.mall) label = 'Mall';
                              if (type == ParkingType.public) label = 'Public';
                              if (type == ParkingType.event) label = 'Event';

                              return DropdownMenuItem(
                                value: type,
                                child: Text(label,
                                    style: const TextStyle(fontSize: 14)),
                              );
                            }).toList(),
                            onChanged: (val) {
                              setState(() {
                                _selectedType = val!;
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Slots Count Selector
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Number of Slots',
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.w600, fontSize: 16)),
                        Text(
                          'Hardware telemetry counts slots dynamically.',
                          style: GoogleFonts.outfit(
                            fontSize: 11,
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: _slotsCount > 1
                              ? () => setState(() => _slotsCount--)
                              : null,
                          icon: const Icon(Icons.remove_circle_outline),
                        ),
                        Text(
                          '$_slotsCount',
                          style: GoogleFonts.outfit(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        IconButton(
                          onPressed: () => setState(() => _slotsCount++),
                          icon: const Icon(Icons.add_circle_outline),
                        ),
                      ],
                    )
                  ],
                ),
                const Divider(height: 32),

                // Amenities Checklist
                Text('Select Amenities',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600)),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _availableAmenities.map((amenity) {
                    final isSelected = _selectedAmenities.contains(amenity);
                    return FilterChip(
                      label: Text(amenity),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedAmenities.add(amenity);
                          } else {
                            _selectedAmenities.remove(amenity);
                          }
                        });
                      },
                    );
                  }).toList(),
                ),
                const SizedBox(height: 48),

                // Publish Button
                CustomButton(
                  text: 'Publish Listing',
                  onPressed: _handleSubmit,
                  isLoading: _isLoading,
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
