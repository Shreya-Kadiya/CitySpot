enum EarningsTransactionStatus {
  completed,
  pending,
  failed,
}

class EarningsTransaction {
  final String id;
  final String parkingSpotName;
  final DateTime dateTime;
  final double amount;
  final EarningsTransactionStatus status;

  EarningsTransaction({
    required this.id,
    required this.parkingSpotName,
    required this.dateTime,
    required this.amount,
    required this.status,
  });
}

class EarningsModel {
  final double walletBalance;
  final double totalEarnings;
  final double monthlyEarnings;
  final int totalBookingsCount;
  final List<EarningsTransaction> transactions;

  EarningsModel({
    required this.walletBalance,
    required this.totalEarnings,
    required this.monthlyEarnings,
    required this.totalBookingsCount,
    required this.transactions,
  });
}
