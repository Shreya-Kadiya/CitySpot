import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../../../core/widgets/status_badge.dart';
import '../../../core/theme/app_colors.dart';
import '../../../models/parking_spot.dart';
import '../../../models/vehicle_model.dart';
import '../../../core/constants/mock_data.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/vehicle_icon.dart';
import '../../../providers/booking_provider.dart';
import 'booking_confirm_screen.dart';

class BookingFlowScreen extends ConsumerStatefulWidget {
  final ParkingSpot spot;

  const BookingFlowScreen({
    Key? key,
    required this.spot,
  }) : super(key: key);

  @override
  ConsumerState<BookingFlowScreen> createState() => _BookingFlowScreenState();
}

class _BookingFlowScreenState extends ConsumerState<BookingFlowScreen> {
  final List<VehicleModel> _vehicles = MockData.mockVehicles;
  late VehicleModel _selectedVehicle;
  late ParkingSlot _selectedSlot;

  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  int _durationHours = 2;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Default select first vehicle
    _selectedVehicle = _vehicles.first;
    // Default select first available slot corresponding to the spot
    _selectedSlot = widget.spot.slots.firstWhere(
      (s) => s.status == ParkingSpotStatus.available,
      orElse: () => widget.spot.slots.first,
    );
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 7)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _handleConfirmBooking() {
    setState(() {
      _isLoading = true;
    });

    final startDateTime = DateTime(
      _selectedDate.year,
      _selectedDate.month,
      _selectedDate.day,
      _selectedTime.hour,
      _selectedTime.minute,
    );
    final endDateTime = startDateTime.add(Duration(hours: _durationHours));
    final subtotal = widget.spot.pricePerHour * _durationHours;
    final totalAmount = subtotal + 0.50; // subtotal + booking platform fee

    Future.delayed(const Duration(milliseconds: 1500), () {
      setState(() {
        _isLoading = false;
      });

      // Save reservation to provider
      ref.read(bookingProvider.notifier).createBooking(
            spot: widget.spot,
            slot: _selectedSlot,
            vehicle: _selectedVehicle,
            startTime: startDateTime,
            endTime: endDateTime,
            totalAmount: totalAmount,
          );

      // Route to confirmation screen passing transaction details
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => BookingConfirmScreen(
            spot: widget.spot,
            slot: _selectedSlot,
            vehicle: _selectedVehicle,
            startTime: startDateTime,
            endTime: endDateTime,
            total: totalAmount,
          ),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subtotal = widget.spot.pricePerHour * _durationHours;
    final platformFee = 0.50;
    final total = subtotal + platformFee;

    // Filter slots for vehicle support
    final supportedSlots = widget.spot.slots
        .where((s) =>
            s.supportedVehicle == _selectedVehicle.type &&
            s.status == ParkingSpotStatus.available)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Spot'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Target spot summary card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        widget.spot.imageUrl,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.image),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.spot.name,
                            style: GoogleFonts.outfit(
                                fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.spot.address,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: isDark
                                  ? AppColors.textDarkSecondary
                                  : AppColors.textLightSecondary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            '\$${widget.spot.pricePerHour.toStringAsFixed(2)}/hr',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Select Vehicle
            Text(
              'Select Registered Vehicle',
              style:
                  GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _vehicles.length,
              itemBuilder: (context, index) {
                final vehicle = _vehicles[index];
                final isSelected = _selectedVehicle.id == vehicle.id;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedVehicle = vehicle;
                      // Recalculate default slot since vehicle type changed
                      final newSlots = widget.spot.slots
                          .where((s) =>
                              s.supportedVehicle == vehicle.type &&
                              s.status == ParkingSpotStatus.available)
                          .toList();
                      if (newSlots.isNotEmpty) {
                        _selectedSlot = newSlots.first;
                      } else {
                        // fallback
                        _selectedSlot = widget.spot.slots.first;
                      }
                    });
                  },
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 8),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 14),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary.withOpacity(0.08)
                          : (isDark ? AppColors.cardDark : Colors.white),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : (isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                        width: isSelected ? 1.5 : 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        VehicleIcon(type: vehicle.type),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                vehicle.nickname,
                                style: GoogleFonts.outfit(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Plate: ${vehicle.plateNumber} • ${vehicle.typeLabel}',
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  color: isDark
                                      ? AppColors.textDarkSecondary
                                      : AppColors.textLightSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isSelected)
                          const Icon(Icons.check_circle,
                              color: AppColors.primary, size: 20),
                      ],
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),

            // Select Specific Slot
            Text(
              'Select Available Slot',
              style:
                  GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            if (supportedSlots.isEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.redAccent.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'No available slots for this vehicle type at this spot.',
                  style:
                      GoogleFonts.outfit(color: Colors.redAccent, fontSize: 13),
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: supportedSlots.map((slot) {
                  final isSelected = _selectedSlot.id == slot.id;
                  return ChoiceChip(
                    label: Text(slot.label),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _selectedSlot = slot;
                        });
                      }
                    },
                  );
                }).toList(),
              ),
            const SizedBox(height: 24),

            // Select Date & Time
            Text(
              'Date & Time Selection',
              style:
                  GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: _pickDate,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined,
                              size: 18, color: AppColors.secondary),
                          const SizedBox(width: 10),
                          Text(
                            DateFormat('MMM dd, yyyy').format(_selectedDate),
                            style: GoogleFonts.outfit(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: InkWell(
                    onTap: _pickTime,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.cardDark : Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: isDark
                                ? AppColors.borderDark
                                : AppColors.borderLight),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.access_time_outlined,
                              size: 18, color: AppColors.secondary),
                          const SizedBox(width: 10),
                          Text(
                            _selectedTime.format(context),
                            style: GoogleFonts.outfit(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Select Duration
            Text(
              'Duration (Hours)',
              style:
                  GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (index) {
                  final hr = index + 1;
                  final isSelected = _durationHours == hr;
                  return ChoiceChip(
                    label: Text('$hr ${hr == 1 ? 'Hr' : 'Hrs'}'),
                    selected: isSelected,
                    onSelected: (selected) {
                      if (selected) {
                        setState(() {
                          _durationHours = hr;
                        });
                      }
                    },
                  );
                },
              ),
            ),
            const Divider(height: 48),

            // Cost Summary Card
            Text(
              'Cost Breakdown',
              style:
                  GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.borderDark : AppColors.borderLight,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Rate (\$${widget.spot.pricePerHour.toStringAsFixed(2)} × $_durationHours hrs)',
                        style: GoogleFonts.outfit(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary),
                      ),
                      Text(
                        '\$${subtotal.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Smart Platform Fee',
                        style: GoogleFonts.outfit(
                            color: isDark
                                ? AppColors.textDarkSecondary
                                : AppColors.textLightSecondary),
                      ),
                      Text(
                        '\$${platformFee.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total Price',
                        style: GoogleFonts.outfit(
                            fontWeight: FontWeight.bold, fontSize: 16),
                      ),
                      Text(
                        '\$${total.toStringAsFixed(2)}',
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: AppColors.primary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Submit Button
            CustomButton(
              text: 'Confirm Reservation',
              onPressed: _handleConfirmBooking,
              isLoading: _isLoading,
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
