import 'package:equatable/equatable.dart';
import '../data/models/transaction_model.dart';

abstract class TransactionHistoryState extends Equatable {
  const TransactionHistoryState();

  @override
  List<Object> get props => [];
}

class TransactionHistoryLoading extends TransactionHistoryState {}

class TransactionHistoryLoaded extends TransactionHistoryState {
  final List<Transaction> transactions;

  TransactionHistoryLoaded(this.transactions);

  @override
  List<Object> get props => [transactions];
}

class TransactionHistoryError extends TransactionHistoryState {}
