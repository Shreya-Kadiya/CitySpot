import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/role_provider.dart';
import '../../providers/theme_provider.dart';
import '../../models/user_model.dart';
import '../../core/constants/mock_data.dart';
import '../../core/widgets/custom_button.dart';
import '../../core/widgets/vehicle_icon.dart';
import '../../models/vehicle_model.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final List<VehicleModel> _vehicles = [...MockData.mockVehicles];

  void _showAddVehicleDialog() {
    final nameController = TextEditingController();
    final plateController = TextEditingController();
    VehicleType selectedType = VehicleType.car;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Container(
              padding: EdgeInsets.only(
                left: 24,
                right: 24,
                top: 24,
                bottom: MediaQuery.of(context).viewInsets.bottom + 24,
              ),
              decoration: BoxDecoration(
                color: isDark ? AppColors.cardDark : Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 48,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.borderDark : AppColors.borderLight,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Add New Vehicle',
                    style: GoogleFonts.outfit(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Vehicle Nickname',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. My EV Hatchback',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'License Plate Number',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 8),
                  TextField(
                    controller: plateController,
                    decoration: const InputDecoration(
                      hintText: 'e.g. 7XYZ99',
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Vehicle Type',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: VehicleType.values.map((type) {
                      final isSelected = selectedType == type;
                      final iconWidget = VehicleIcon(type: type, size: 28);
                      String label = 'Car';
                      if (type == VehicleType.bike) label = 'Bike';
                      if (type == VehicleType.ev) label = 'EV';
                      if (type == VehicleType.rickshaw) label = 'Rickshaw';

                      return GestureDetector(
                        onTap: () {
                          setModalState(() {
                            selectedType = type;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primary.withOpacity(0.12)
                                : (isDark ? AppColors.bgDark : Colors.grey.shade100),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : Colors.transparent,
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            children: [
                              iconWidget,
                              const SizedBox(height: 6),
                              Text(
                                label,
                                style: GoogleFonts.outfit(
                                  fontSize: 12,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              )
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 32),
                  CustomButton(
                    text: 'Save Vehicle',
                    onPressed: () {
                      if (nameController.text.isNotEmpty && plateController.text.isNotEmpty) {
                        setState(() {
                          _vehicles.add(
                            VehicleModel(
                              id: 'v_${_vehicles.length + 1}',
                              nickname: nameController.text,
                              plateNumber: plateController.text,
                              type: selectedType,
                            ),
                          );
                        });
                        Navigator.of(context).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Vehicle added successfully!'),
                            backgroundColor: AppColors.iotAvailable,
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentRole = ref.watch(roleProvider);
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: Icon(themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode),
            onPressed: () => ref.read(themeProvider.notifier).toggleTheme(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User Summary Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 36,
                      backgroundImage: NetworkImage(MockData.mockUser.avatarUrl),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MockData.mockUser.name,
                            style: GoogleFonts.outfit(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            MockData.mockUser.email,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            MockData.mockUser.phone,
                            style: GoogleFonts.outfit(
                              fontSize: 14,
                              color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),

            // Role Switcher Section
            Text(
              'Account Role',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primary.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.swap_horizontal_circle, color: AppColors.primary),
                          ),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Mode',
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary,
                                ),
                              ),
                              Text(
                                currentRole == UserRole.driver
                                    ? 'Driver / Reservist'
                                    : (currentRole == UserRole.owner ? 'Parking Spot Owner' : 'System Administrator'),
                                style: GoogleFonts.outfit(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ChoiceChip(
                        label: const Text('Driver'),
                        selected: currentRole == UserRole.driver,
                        onSelected: (selected) {
                          if (selected) {
                            ref.read(roleProvider.notifier).setRole(UserRole.driver);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Owner'),
                        selected: currentRole == UserRole.owner,
                        onSelected: (selected) {
                          if (selected) {
                            ref.read(roleProvider.notifier).setRole(UserRole.owner);
                          }
                        },
                      ),
                      ChoiceChip(
                        label: const Text('Admin Dashboard'),
                        selected: currentRole == UserRole.admin,
                        onSelected: (selected) {
                          if (selected) {
                            ref.read(roleProvider.notifier).setRole(UserRole.admin);
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Vehicles List Section (Driver Mode only)
            if (currentRole == UserRole.driver) ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Registered Vehicles',
                    style: GoogleFonts.outfit(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: _showAddVehicleDialog,
                    icon: const Icon(Icons.add, size: 18),
                    label: Text(
                      'Add',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 8),
              if (_vehicles.isEmpty)
                Container(
                  padding: const EdgeInsets.all(24),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.cardDark : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Center(
                    child: Text(
                      'No vehicles added yet.',
                      style: GoogleFonts.outfit(color: isDark ? AppColors.textDarkSecondary : AppColors.textLightSecondary),
                    ),
                  ),
                )
              else
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _vehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = _vehicles[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: vehicle.type == VehicleType.ev
                                ? AppColors.vehicleEV.withOpacity(0.1)
                                : (vehicle.type == VehicleType.car ? AppColors.vehicleCar.withOpacity(0.1) : Colors.grey.withOpacity(0.1)),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: VehicleIcon(type: vehicle.type),
                        ),
                        title: Text(
                          vehicle.nickname,
                          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          'Plate: ${vehicle.plateNumber}',
                          style: GoogleFonts.outfit(fontSize: 13),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete_outline, color: Colors.redAccent, size: 20),
                          onPressed: () {
                            setState(() {
                              _vehicles.removeAt(index);
                            });
                          },
                        ),
                      ),
                    );
                  },
                ),
              const SizedBox(height: 24),
            ],

            // General Settings Cards
            Text(
              'App Settings',
              style: GoogleFonts.outfit(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.notifications_none_rounded),
                    title: const Text('Notifications'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.payment_rounded),
                    title: const Text('Payment Methods'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.security_outlined),
                    title: const Text('Privacy & Security'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {},
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                    title: const Text('Log Out', style: TextStyle(color: Colors.redAccent)),
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
