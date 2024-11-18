import 'package:flutter_bloc/flutter_bloc.dart';
import 'transaction_history_event.dart';
import 'transaction_history_state.dart';
import '../models/transaction_model.dart';

class TransactionHistoryBloc extends Bloc<TransactionHistoryEvent, TransactionHistoryState> {
  TransactionHistoryBloc() : super(TransactionHistoryLoading()) {
    on<LoadTransactionHistory>(_onLoadTransactionHistory);
  }

  void _onLoadTransactionHistory(
      LoadTransactionHistory event, Emitter<TransactionHistoryState> emit) async {
    emit(TransactionHistoryLoading());
    try {
      // Mock data for now, replace with actual data fetching logic
      await Future.delayed(const Duration(seconds: 2));
      emit(TransactionHistoryLoaded([
        Transaction(
          id: '1',
          type: 'Upload',
          amount: 50.0,
          status: 'Success',
          date: DateTime.now().subtract(const Duration(days: 1)),
        ),
        Transaction(
          id: '2',
          type: 'Withdrawal',
          amount: 20.0,
          status: 'Success',
          date: DateTime.now().subtract(const Duration(days: 2)),
        ),
      ]));
    } catch (_) {
      emit(TransactionHistoryError());
    }
  }
}
