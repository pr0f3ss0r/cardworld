import 'package:bloc/bloc.dart';
import 'package:cardworld/blocs/account_event.dart';
import 'package:cardworld/blocs/account_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  AccountBloc() : super(AccountLoading()) {
    on<LoadAccountBalance>(_onLoadAccountBalance);
    on<RequestWithdrawal>(_onRequestWithdrawal);
  }

  Future<void> _onLoadAccountBalance(
      LoadAccountBalance event, Emitter<AccountState> emit) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userDoc.exists) {
          final balance = userDoc['balance'] ?? 0.0;
          final userName = userDoc['username'] ?? 'No username';
          final email = user.email ?? 'No email';

          emit(AccountLoaded(
            balance: balance,
            userName: userName,
            email: email,
          ));
        } else {
          emit(AccountLoaded(
            balance: 0.0,
            userName: 'No username',
            email: user.email ?? 'No email',
          ));
        }
      } else {
        emit(AccountLoaded(
          balance: 0.0,
          userName: 'No username',
          email: 'No email',
        ));
      }
    } catch (e) {
      emit(AccountLoaded(
        balance: 0.0,
        userName: 'Error loading username',
        email: 'Error loading email',
      ));
    }
  }

  Future<void> _onRequestWithdrawal(
      RequestWithdrawal event, Emitter<AccountState> emit) async {
    if (state is AccountLoaded) {
      final currentState = state as AccountLoaded;
      emit(
          currentState.copyWith(withdrawalStatus: WithdrawalStatus.processing));

      try {
        // Simulate processing the withdrawal
        await Future.delayed(Duration(seconds: 2));
        double newBalance = currentState.balance - event.amount;
        newBalance = newBalance < 0 ? 0 : newBalance;

        // Update the balance in Firestore
        final user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(user.uid)
              .update({'balance': newBalance});
        }

        emit(currentState.copyWith(
          balance: newBalance,
          withdrawalStatus: WithdrawalStatus.success,
        ));
      } catch (e) {
        emit(currentState.copyWith(withdrawalStatus: WithdrawalStatus.failure));
      }
    }
  }
}
