import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../core/constants/mock_data.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({Key? key}) : super(key: key);

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  final List<String> _notifications = [...MockData.mockNotifications];

  Future<void> _handleRefresh() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      _notifications.insert(0, '🔔 Live Update: Spot A3 at Transbay Transit Plaza has just become available.');
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _handleRefresh,
        child: _notifications.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.notifications_off_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No Notifications Yet',
                      style: GoogleFonts.outfit(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                      ),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _notifications.length,
                itemBuilder: (context, index) {
                  final note = _notifications[index];
                  // Simple alert icon parser
                  IconData icon = Icons.info_outline_rounded;
                  Color iconColor = AppColors.secondary;

                  if (note.contains('confirmed')) {
                    icon = Icons.check_circle_outline_rounded;
                    iconColor = AppColors.iotAvailable;
                  } else if (note.contains('occupancy') || note.contains('rising')) {
                    icon = Icons.warning_amber_rounded;
                    iconColor = AppColors.iotReserved;
                  } else if (note.contains('code') || note.contains('activated')) {
                    icon = Icons.lock_outline;
                    iconColor = AppColors.primary;
                  } else if (note.contains('available') || note.contains('become')) {
                    icon = Icons.event_available_rounded;
                    iconColor = AppColors.iotAvailable;
                  }

                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: iconColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(icon, color: iconColor, size: 20),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  note.replaceFirst(RegExp(r'^[^:\s]+[:]?\s*'), ''), // Strip emojis if parsed
                                  style: GoogleFonts.outfit(
                                    fontSize: 14,
                                    color: isDark ? AppColors.textDarkPrimary : AppColors.textLightPrimary,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Just now',
                                  style: GoogleFonts.outfit(
                                    fontSize: 11,
                                    color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}
