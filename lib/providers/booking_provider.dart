import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../core/constants/mock_data.dart';
import '../models/parking_spot.dart';
import '../models/vehicle_model.dart';

class BookingNotifier extends StateNotifier<List<BookingModel>> {
  BookingNotifier() : super(MockData.mockBookings);

  BookingModel? get activeBooking {
    try {
      return state.firstWhere((b) => b.status == BookingStatus.active);
    } catch (_) {
      return null;
    }
  }

  void createBooking({
    required ParkingSpot spot,
    required ParkingSlot slot,
    required VehicleModel vehicle,
    required DateTime startTime,
    required DateTime endTime,
    required double totalAmount,
  }) {
    final newBooking = BookingModel(
      id: 'bk_${state.length + 1}',
      spot: spot,
      slot: slot,
      vehicle: vehicle,
      startTime: startTime,
      endTime: endTime,
      totalAmount: totalAmount,
      status: BookingStatus.upcoming,
      passcode: 'CITY-${1000 + state.length * 11}',
      isCheckedIn: false,
    );
    state = [newBooking, ...state];
  }

  void checkIn(String bookingId) {
    state = state.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(
          status: BookingStatus.active,
          isCheckedIn: true,
        );
      }
      return b;
    }).toList();
  }

  void completeBooking(String bookingId) {
    state = state.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(
          status: BookingStatus.completed,
          isCheckedIn: false,
        );
      }
      return b;
    }).toList();
  }

  void cancelBooking(String bookingId) {
    state = state.map((b) {
      if (b.id == bookingId) {
        return b.copyWith(
          status: BookingStatus.cancelled,
        );
      }
      return b;
    }).toList();
  }
}

final bookingProvider = StateNotifierProvider<BookingNotifier, List<BookingModel>>((ref) {
  return BookingNotifier();
});
