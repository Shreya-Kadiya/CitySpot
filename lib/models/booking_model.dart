import 'parking_spot.dart';
import 'vehicle_model.dart';

enum BookingStatus {
  upcoming,
  active,
  completed,
  cancelled,
}

class BookingModel {
  final String id;
  final ParkingSpot spot;
  final ParkingSlot slot;
  final VehicleModel vehicle;
  final DateTime startTime;
  final DateTime endTime;
  final double totalAmount;
  final BookingStatus status;
  final String passcode;
  final bool isCheckedIn;

  BookingModel({
    required this.id,
    required this.spot,
    required this.slot,
    required this.vehicle,
    required this.startTime,
    required this.endTime,
    required this.totalAmount,
    required this.status,
    required this.passcode,
    this.isCheckedIn = false,
  });

  BookingModel copyWith({
    String? id,
    ParkingSpot? spot,
    ParkingSlot? slot,
    VehicleModel? vehicle,
    DateTime? startTime,
    DateTime? endTime,
    double? totalAmount,
    BookingStatus? status,
    String? passcode,
    bool? isCheckedIn,
  }) {
    return BookingModel(
      id: id ?? this.id,
      spot: spot ?? this.spot,
      slot: slot ?? this.slot,
      vehicle: vehicle ?? this.vehicle,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      totalAmount: totalAmount ?? this.totalAmount,
      status: status ?? this.status,
      passcode: passcode ?? this.passcode,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
    );
  }
}
