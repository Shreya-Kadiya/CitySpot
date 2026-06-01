import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

enum VehicleType {
  car,
  bike,
  ev,
  rickshaw,
}

class VehicleIcon extends StatelessWidget {
  final VehicleType type;
  final double size;
  final Color? color;

  const VehicleIcon({
    Key? key,
    required this.type,
    this.size = 24,
    this.color,
  }) : super(key: key);

  IconData get icon {
    switch (type) {
      case VehicleType.car:
        return Icons.directions_car_filled_outlined;
      case VehicleType.bike:
        return Icons.two_wheeler_outlined;
      case VehicleType.ev:
        return Icons.ev_station_outlined;
      case VehicleType.rickshaw:
        return Icons.electric_rickshaw_outlined;
    }
  }

  Color get defaultColor {
    switch (type) {
      case VehicleType.car:
        return AppColors.vehicleCar;
      case VehicleType.bike:
        return AppColors.vehicleBike;
      case VehicleType.ev:
        return AppColors.vehicleEV;
      case VehicleType.rickshaw:
        return AppColors.vehicleRickshaw;
    }
  }

  String get label {
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

  @override
  Widget build(BuildContext context) {
    return Icon(
      icon,
      size: size,
      color: color ?? defaultColor,
    );
  }
}
