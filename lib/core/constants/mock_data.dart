import '../../models/user_model.dart';
import '../../models/vehicle_model.dart';
import '../../models/parking_spot.dart';
import '../../models/booking_model.dart';
import '../../models/earnings_model.dart';
import '../widgets/status_badge.dart';
import '../widgets/vehicle_icon.dart';

class MockData {
  static final UserModel mockUser = UserModel(
    id: 'user_1',
    name: 'Sarah Jenkins',
    email: 'sarah.jenkins@smartcity.com',
    phone: '+1 (555) 019-2834',
    avatarUrl: 'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=150',
    currentRole: UserRole.driver,
  );

  static final List<VehicleModel> mockVehicles = [
    VehicleModel(id: 'v_1', nickname: 'Sarah\'s Tesla', plateNumber: '7XYZ89', type: VehicleType.ev),
    VehicleModel(id: 'v_2', nickname: 'Family SUV', plateNumber: '5ABC12', type: VehicleType.car),
    VehicleModel(id: 'v_3', nickname: 'Eco Scooter', plateNumber: '2MNO45', type: VehicleType.bike),
  ];

  static final List<ParkingSpot> mockSpots = [
    ParkingSpot(
      id: 'spot_1',
      name: 'Transbay Transit Plaza',
      description: 'Ultra-modern underground transit hub parking. Includes automatic plate scanning, high-speed EV chargers, and 24/7 security. Perfect for city commuters and downtown workers.',
      address: '425 Mission St, San Francisco, CA 94105',
      imageUrl: 'https://images.unsplash.com/photo-1573348722427-f1d6819fdf98?w=600',
      type: ParkingType.public,
      rating: 4.8,
      reviewsCount: 342,
      pricePerHour: 4.50,
      latitude: 37.7897,
      longitude: -122.3999,
      distanceKm: 0.4,
      amenities: ['24/7 Security', 'EV Charging', 'Wheelchair Access', 'CCTV', 'Covered'],
      rules: ['No tailgating', 'Maximum height 7\'2"', 'EV slots only for charging vehicles'],
      slots: [
        ParkingSlot(id: 's_1_1', label: 'Slot A1 (EV)', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.ev),
        ParkingSlot(id: 's_1_2', label: 'Slot A2 (EV)', status: ParkingSpotStatus.occupied, supportedVehicle: VehicleType.ev),
        ParkingSlot(id: 's_1_3', label: 'Slot A3 (Car)', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_1_4', label: 'Slot A4 (Car)', status: ParkingSpotStatus.reserved, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_1_5', label: 'Slot B1 (Bike)', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.bike),
        ParkingSlot(id: 's_1_6', label: 'Slot B2 (Rickshaw)', status: ParkingSpotStatus.offline, supportedVehicle: VehicleType.rickshaw),
        ParkingSlot(id: 's_1_7', label: 'Slot B3 (Car)', status: ParkingSpotStatus.maintenance, supportedVehicle: VehicleType.car),
      ],
    ),
    ParkingSpot(
      id: 'spot_2',
      name: 'Rincon Center Garage',
      description: 'Secure commercial building parking located close to Salesforce Tower and financial district. Premium elevator access directly to lobby, automated ticketless checkin.',
      address: '121 Spear St, San Francisco, CA 94105',
      imageUrl: 'https://images.unsplash.com/photo-1590674899484-d5640e854abe?w=600',
      type: ParkingType.commercial,
      rating: 4.5,
      reviewsCount: 198,
      pricePerHour: 6.00,
      latitude: 37.7915,
      longitude: -122.3942,
      distanceKm: 0.8,
      amenities: ['CCTV', 'Covered Parking', 'Restrooms', 'Car Wash Services'],
      rules: ['Lock your vehicle', 'No overnight storing without prior reservation'],
      slots: [
        ParkingSlot(id: 's_2_1', label: 'Slot 101 (Car)', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_2_2', label: 'Slot 102 (Car)', status: ParkingSpotStatus.occupied, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_2_3', label: 'Slot 103 (Car)', status: ParkingSpotStatus.occupied, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_2_4', label: 'Slot 104 (EV)', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.ev),
        ParkingSlot(id: 's_2_5', label: 'Slot 105 (Bike)', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.bike),
      ],
    ),
    ParkingSpot(
      id: 'spot_3',
      name: 'Salesforce Mall Deck',
      description: 'Multi-level shopping mall deck parking with automated smart signage indicating real-time slot occupancy. Convenient access to major shopping, food court, and theater.',
      address: '865 Market St, San Francisco, CA 94103',
      imageUrl: 'https://images.unsplash.com/photo-1506521788723-868151859b87?w=600',
      type: ParkingType.mall,
      rating: 4.6,
      reviewsCount: 512,
      pricePerHour: 5.00,
      latitude: 37.7842,
      longitude: -122.4075,
      distanceKm: 1.2,
      amenities: ['24/7 Security', 'Elevators', 'Covered Parking', 'Shopping Discounts'],
      rules: ['Keep ticket safe', 'Speed limit 5 MPH', 'Park in marked slots only'],
      slots: [
        ParkingSlot(id: 's_3_1', label: 'Level 2 - C1', status: ParkingSpotStatus.occupied, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_3_2', label: 'Level 2 - C2', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_3_3', label: 'Level 2 - E1', status: ParkingSpotStatus.reserved, supportedVehicle: VehicleType.ev),
        ParkingSlot(id: 's_3_4', label: 'Level 2 - E2', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.ev),
      ],
    ),
    ParkingSpot(
      id: 'spot_4',
      name: 'SOMA Private Driveway',
      description: 'Safe, residential space listed by a local community owner. Secured behind electronic remote-controlled gates. Ideal for long-term day parking.',
      address: '745 Folsom St, San Francisco, CA 94107',
      imageUrl: 'https://images.unsplash.com/photo-1542282088-fe8426682b8f?w=600',
      type: ParkingType.residential,
      rating: 4.9,
      reviewsCount: 89,
      pricePerHour: 3.50,
      latitude: 37.7818,
      longitude: -122.4011,
      distanceKm: 1.5,
      amenities: ['Gated Entrance', 'CCTV', 'Independent Access'],
      rules: ['Be quiet when arriving/leaving', 'Only park vehicle corresponding to license plate'],
      slots: [
        ParkingSlot(id: 's_4_1', label: 'Driveway A', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_4_2', label: 'Driveway B', status: ParkingSpotStatus.offline, supportedVehicle: VehicleType.car),
      ],
    ),
    ParkingSpot(
      id: 'spot_5',
      name: 'Oracle Park Event Parking',
      description: 'Special outdoor lot reserve-able for SF Giants baseball games and concerts. Right next to the waterfront and SOMA restaurants.',
      address: '24 Willie Mays Plaza, San Francisco, CA 94107',
      imageUrl: 'https://images.unsplash.com/photo-1604147706283-d7119b5b822c?w=600',
      type: ParkingType.event,
      rating: 4.2,
      reviewsCount: 224,
      pricePerHour: 8.00,
      latitude: 37.7786,
      longitude: -122.3893,
      distanceKm: 2.1,
      amenities: ['Tailgating Allowed', 'Staff On Site', 'Waterfront View'],
      rules: ['Event tickets required for slot entry', 'No vehicles left past 12 AM'],
      slots: [
        ParkingSlot(id: 's_5_1', label: 'Lot A - 10', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_5_2', label: 'Lot A - 11', status: ParkingSpotStatus.occupied, supportedVehicle: VehicleType.car),
        ParkingSlot(id: 's_5_3', label: 'Lot A - 12 (EV)', status: ParkingSpotStatus.available, supportedVehicle: VehicleType.ev),
      ],
    ),
  ];

  static final List<BookingModel> mockBookings = [
    BookingModel(
      id: 'bk_1',
      spot: mockSpots[0],
      slot: mockSpots[0].slots[0], // Slot A1 (EV)
      vehicle: mockVehicles[0], // Tesla
      startTime: DateTime.now().subtract(const Duration(minutes: 45)),
      endTime: DateTime.now().add(const Duration(minutes: 75)),
      totalAmount: 9.00,
      status: BookingStatus.active,
      passcode: 'CITY-9921',
      isCheckedIn: true,
    ),
    BookingModel(
      id: 'bk_2',
      spot: mockSpots[1],
      slot: mockSpots[1].slots[0], // Slot 101
      vehicle: mockVehicles[1], // Family SUV
      startTime: DateTime.now().add(const Duration(hours: 3)),
      endTime: DateTime.now().add(const Duration(hours: 6)),
      totalAmount: 18.00,
      status: BookingStatus.upcoming,
      passcode: 'CITY-4530',
      isCheckedIn: false,
    ),
    BookingModel(
      id: 'bk_3',
      spot: mockSpots[2],
      slot: mockSpots[2].slots[1], // Slot C2
      vehicle: mockVehicles[0],
      startTime: DateTime.now().subtract(const Duration(days: 2, hours: 4)),
      endTime: DateTime.now().subtract(const Duration(days: 2, hours: 1)),
      totalAmount: 15.00,
      status: BookingStatus.completed,
      passcode: 'CITY-1102',
      isCheckedIn: true,
    ),
    BookingModel(
      id: 'bk_4',
      spot: mockSpots[3],
      slot: mockSpots[3].slots[0], // Driveway A
      vehicle: mockVehicles[2], // Scooter
      startTime: DateTime.now().subtract(const Duration(days: 5, hours: 8)),
      endTime: DateTime.now().subtract(const Duration(days: 5, hours: 4)),
      totalAmount: 14.00,
      status: BookingStatus.completed,
      passcode: 'CITY-3829',
      isCheckedIn: true,
    ),
  ];

  static final EarningsModel mockEarnings = EarningsModel(
    walletBalance: 245.50,
    totalEarnings: 1580.00,
    monthlyEarnings: 620.50,
    totalBookingsCount: 142,
    transactions: [
      EarningsTransaction(id: 'tx_1', parkingSpotName: 'Transbay Transit Plaza', dateTime: DateTime.now().subtract(const Duration(hours: 2)), amount: 18.00, status: EarningsTransactionStatus.completed),
      EarningsTransaction(id: 'tx_2', parkingSpotName: 'Rincon Center Garage', dateTime: DateTime.now().subtract(const Duration(days: 1)), amount: 24.00, status: EarningsTransactionStatus.completed),
      EarningsTransaction(id: 'tx_3', parkingSpotName: 'Salesforce Mall Deck', dateTime: DateTime.now().subtract(const Duration(days: 3)), amount: 15.00, status: EarningsTransactionStatus.completed),
      EarningsTransaction(id: 'tx_4', parkingSpotName: 'SOMA Private Driveway', dateTime: DateTime.now().subtract(const Duration(days: 5)), amount: 35.00, status: EarningsTransactionStatus.completed),
      EarningsTransaction(id: 'tx_5', parkingSpotName: 'Salesforce Mall Deck', dateTime: DateTime.now().subtract(const Duration(days: 7)), amount: 20.00, status: EarningsTransactionStatus.completed),
    ],
  );

  static final List<String> mockNotifications = [
    '🔔 Booking confirmed! Your slot A1 at Transbay Transit Plaza is ready.',
    '📍 Real-time alert: Parking occupancy at Salesforce Mall is rising fast (now 85% full).',
    '🔒 Security notice: Your check-in code CITY-9921 has been activated.',
    '⚡ EV Charger initialized successfully in Slot A1.',
    '💬 Reminder: Your upcoming booking for Rincon Center starts in 2 hours.',
  ];
}
