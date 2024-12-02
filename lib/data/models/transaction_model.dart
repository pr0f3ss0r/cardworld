class Transaction {
  final String id;
  final String type; // e.g., "Upload", "Withdrawal"
  final double amount;
  final String status; // e.g., "Success", "Pending", "Failed"
  final DateTime date;

  Transaction({
    required this.id,
    required this.type,
    required this.amount,
    required this.status,
    required this.date,
  });
}
