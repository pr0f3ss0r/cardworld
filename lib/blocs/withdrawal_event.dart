import 'package:equatable/equatable.dart';

abstract class WithdrawalEvent extends Equatable {
  const WithdrawalEvent();

  @override
  List<Object> get props => [];
}

class RequestWithdrawal extends WithdrawalEvent {
  final double amount;

  const RequestWithdrawal(this.amount);

  @override
  List<Object> get props => [amount];
}
