import 'package:equatable/equatable.dart';

enum WithdrawalStatus { initial, processing, success, failure }

abstract class AccountState extends Equatable {
  const AccountState();

  @override
  List<Object> get props => [];
}

class AccountLoading extends AccountState {}

class AccountLoaded extends AccountState {
  final double balance;
  final WithdrawalStatus withdrawalStatus;
  final String userName;
  final String email;

  const AccountLoaded({
    required this.balance,
    this.withdrawalStatus = WithdrawalStatus.initial,
  required this.userName, required this.email});

  @override
  List<Object> get props => [balance, withdrawalStatus];

  // Add a copyWith method
  AccountLoaded copyWith({
    double? balance,
    WithdrawalStatus? withdrawalStatus,
    String? userName,
    String? email,
  }) {
    return AccountLoaded(
      userName: userName ?? this.userName,
      email: email ?? this.email,
      balance: balance ?? this.balance,
      withdrawalStatus: withdrawalStatus ?? this.withdrawalStatus,
    );
  }
}

class AccountError extends AccountState {}
