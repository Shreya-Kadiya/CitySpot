import 'package:flutter/material.dart';

class AppColors {
  // Brand Colors (Airbnb Coral + Google Maps Blue)
  static const Color primary = Color(0xFFFF385C); // Airbnb Coral
  static const Color secondary = Color(0xFF1A73E8); // Google Maps Blue
  static const Color accent = Color(0xFF8A2BE2); // Royal Purple

  // Neutral Colors - Light Mode
  static const Color bgLight = Color(0xFFF7F7F7);
  static const Color cardLight = Colors.white;
  static const Color textLightPrimary = Color(0xFF222222);
  static const Color textLightSecondary = Color(0xFF717171);
  static const Color borderLight = Color(0xFFDDDDDD);

  // Neutral Colors - Dark Mode
  static const Color bgDark = Color(0xFF0F0F11);
  static const Color cardDark = Color(0xFF1E1E24);
  static const Color textDarkPrimary = Color(0xFFF7F7F7);
  static const Color textDarkSecondary = Color(0xFFA0A0A5);
  static const Color borderDark = Color(0xFF2D2D35);

  // IoT Sensor Status Colors
  static const Color iotAvailable = Color(0xFF00C853);    // Vibrant Green
  static const Color iotOccupied = Color(0xFFFF1744);     // Vibrant Red
  static const Color iotReserved = Color(0xFFFFD600);     // Vibrant Yellow/Amber
  static const Color iotOffline = Color(0xFF90A4AE);      // Slate Gray
  static const Color iotMaintenance = Color(0xFFFF9100);  // Vibrant Orange

  // Vehicle Type Colors
  static const Color vehicleCar = Color(0xFF1A73E8);
  static const Color vehicleBike = Color(0xFF00C853);
  static const Color vehicleEV = Color(0xFF00B0FF);
  static const Color vehicleRickshaw = Color(0xFFFF9100);
}
