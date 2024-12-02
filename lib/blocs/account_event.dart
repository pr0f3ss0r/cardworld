import 'package:equatable/equatable.dart';

abstract class AccountEvent extends Equatable {
  const AccountEvent();

  @override
  List<Object> get props => [];
}

class LoadAccountBalance extends AccountEvent {}

class RequestWithdrawal extends AccountEvent {
  final double amount;

  const RequestWithdrawal({required this.amount});

  @override
  List<Object> get props => [amount];
}
