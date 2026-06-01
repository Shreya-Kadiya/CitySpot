import '../core/widgets/vehicle_icon.dart';

class VehicleModel {
  final String id;
  final String nickname;
  final String plateNumber;
  final VehicleType type;

  VehicleModel({
    required this.id,
    required this.nickname,
    required this.plateNumber,
    required this.type,
  });

  String get typeLabel {
    switch (type) {
      case VehicleType.car:
        return 'Car';
      case VehicleType.bike:
        return 'Bike';
      case VehicleType.ev:
        return 'EV';
      case VehicleType.rickshaw:
        return 'Auto Rickshaw';
    }
  }
}
