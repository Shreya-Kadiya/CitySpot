import 'dart:async';
import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/parking_spot.dart';
import '../core/constants/mock_data.dart';
import '../core/widgets/status_badge.dart';

class ParkingNotifier extends StateNotifier<List<ParkingSpot>> {
  Timer? _iotTimer;
  DateTime _lastUpdated = DateTime.now();

  ParkingNotifier() : super(MockData.mockSpots) {
    _startIotSimulator();
  }

  DateTime get lastUpdated => _lastUpdated;

  void _startIotSimulator() {
    _iotTimer = Timer.periodic(const Duration(seconds: 8), (timer) {
      // Pick a random spot, random slot, and toggle its status to simulate IoT events
      final random = Random();
      final spots = [...state];
      if (spots.isEmpty) return;

      final spotIdx = random.nextInt(spots.length);
      final spot = spots[spotIdx];
      if (spot.slots.isEmpty) return;

      final slotIdx = random.nextInt(spot.slots.length);
      final slot = spot.slots[slotIdx];

      // Toggle status between available and occupied, or sometimes reserved
      ParkingSpotStatus newStatus;
      if (slot.status == ParkingSpotStatus.available) {
        newStatus = ParkingSpotStatus.occupied;
      } else if (slot.status == ParkingSpotStatus.occupied) {
        newStatus = random.nextBool() ? ParkingSpotStatus.available : ParkingSpotStatus.reserved;
      } else {
        newStatus = ParkingSpotStatus.available;
      }

      final updatedSlots = [...spot.slots];
      updatedSlots[slotIdx] = slot.copyWith(status: newStatus);

      spots[spotIdx] = spot.copyWith(slots: updatedSlots);
      _lastUpdated = DateTime.now();
      state = spots;
    });
  }

  void addSpot(ParkingSpot newSpot) {
    state = [...state, newSpot];
  }

  void updateSlotStatus(String spotId, String slotId, ParkingSpotStatus status) {
    state = state.map((spot) {
      if (spot.id == spotId) {
        final updatedSlots = spot.slots.map((slot) {
          if (slot.id == slotId) {
            return slot.copyWith(status: status);
          }
          return slot;
        }).toList();
        return spot.copyWith(slots: updatedSlots);
      }
      return spot;
    }).toList();
  }

  @override
  void dispose() {
    _iotTimer?.cancel();
    super.dispose();
  }
}

final parkingProvider = StateNotifierProvider<ParkingNotifier, List<ParkingSpot>>((ref) {
  return ParkingNotifier();
});
