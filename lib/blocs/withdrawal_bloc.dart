import 'package:flutter_bloc/flutter_bloc.dart';
import 'withdrawal_event.dart';
import 'withdrawal_state.dart';

class WithdrawalBloc extends Bloc<WithdrawalEvent, WithdrawalState> {
  WithdrawalBloc() : super(WithdrawalInitial()) {
    on<RequestWithdrawal>(_onRequestWithdrawal);
  }

  void _onRequestWithdrawal(RequestWithdrawal event, Emitter<WithdrawalState> emit) async {
    emit(WithdrawalInProgress());
    try {
      // Simulate withdrawal process, replace with backend call
      await Future.delayed(const Duration(seconds: 2));
      emit(WithdrawalSuccess());
    } catch (_) {
      emit(WithdrawalFailure("Failed to process withdrawal"));
    }
  }
}
