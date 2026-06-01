import '../core/widgets/status_badge.dart';
import '../core/widgets/vehicle_icon.dart';

enum ParkingType {
  residential,
  society,
  apartment,
  commercial,
  mall,
  public,
  event,
}

class ParkingSlot {
  final String id;
  final String label;
  final ParkingSpotStatus status;
  final VehicleType supportedVehicle;

  ParkingSlot({
    required this.id,
    required this.label,
    required this.status,
    required this.supportedVehicle,
  });

  ParkingSlot copyWith({
    String? id,
    String? label,
    ParkingSpotStatus? status,
    VehicleType? supportedVehicle,
  }) {
    return ParkingSlot(
      id: id ?? this.id,
      label: label ?? this.label,
      status: status ?? this.status,
      supportedVehicle: supportedVehicle ?? this.supportedVehicle,
    );
  }
}

class ParkingSpot {
  final String id;
  final String name;
  final String description;
  final String address;
  final String imageUrl;
  final ParkingType type;
  final double rating;
  final int reviewsCount;
  final double pricePerHour;
  final double latitude;
  final double longitude;
  final double distanceKm;
  final List<String> amenities;
  final List<String> rules;
  final List<ParkingSlot> slots;

  ParkingSpot({
    required this.id,
    required this.name,
    required this.description,
    required this.address,
    required this.imageUrl,
    required this.type,
    required this.rating,
    required this.reviewsCount,
    required this.pricePerHour,
    required this.latitude,
    required this.longitude,
    required this.distanceKm,
    required this.amenities,
    required this.rules,
    required this.slots,
  });

  int get availableSlotsCount =>
      slots.where((s) => s.status == ParkingSpotStatus.available).length;

  int get totalSlotsCount => slots.length;

  String get typeLabel {
    switch (type) {
      case ParkingType.residential:
        return 'Residential';
      case ParkingType.society:
        return 'Society';
      case ParkingType.apartment:
        return 'Apartment';
      case ParkingType.commercial:
        return 'Commercial';
      case ParkingType.mall:
        return 'Mall';
      case ParkingType.public:
        return 'Public Parking';
      case ParkingType.event:
        return 'Event Parking';
    }
  }

  ParkingSpot copyWith({
    String? id,
    String? name,
    String? description,
    String? address,
    String? imageUrl,
    ParkingType? type,
    double? rating,
    int? reviewsCount,
    double? pricePerHour,
    double? latitude,
    double? longitude,
    double? distanceKm,
    List<String>? amenities,
    List<String>? rules,
    List<ParkingSlot>? slots,
  }) {
    return ParkingSpot(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      address: address ?? this.address,
      imageUrl: imageUrl ?? this.imageUrl,
      type: type ?? this.type,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      pricePerHour: pricePerHour ?? this.pricePerHour,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      distanceKm: distanceKm ?? this.distanceKm,
      amenities: amenities ?? this.amenities,
      rules: rules ?? this.rules,
      slots: slots ?? this.slots,
    );
  }
}
