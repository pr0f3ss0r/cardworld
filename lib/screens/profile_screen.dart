import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/withdrawal_bloc.dart';
import '../bloc/withdrawal_event.dart';
import '../bloc/withdrawal_state.dart';
import '../bloc/transaction_history_bloc.dart';
import '../bloc/transaction_history_event.dart';
import '../bloc/transaction_history_state.dart';
import '../models/transaction_model.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _withdrawalFormKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    BlocProvider.of<TransactionHistoryBloc>(context).add(LoadTransactionHistory());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile & Balance'),
      ),
      body: BlocListener<WithdrawalBloc, WithdrawalState>(
        listener: (context, state) {
          if (state is WithdrawalSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Withdrawal Successful!')),
            );
          } else if (state is WithdrawalFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Current Balance: \$100.00', // Replace with actual balance from backend
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              Form(
                key: _withdrawalFormKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _amountController,
                      decoration: const InputDecoration(
                        labelText: 'Withdrawal Amount',
                      ),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the amount';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () {
                        if (_withdrawalFormKey.currentState?.validate() ?? false) {
                          BlocProvider.of<WithdrawalBloc>(context).add(
                            RequestWithdrawal(double.parse(_amountController.text)),
                          );
                        }
                      },
                      child: const Text('Withdraw Funds'),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32.0),
              Text(
                'Transaction History:',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 16.0),
              Expanded(
                child: BlocBuilder<TransactionHistoryBloc, TransactionHistoryState>(
                  builder: (context, state) {
                    if (state is TransactionHistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is TransactionHistoryLoaded) {
                      return ListView.builder(
                        itemCount: state.transactions.length,
                        itemBuilder: (context, index) {
                          final transaction = state.transactions[index];
                          return ListTile(
                            title: Text('${transaction.type} - \$${transaction.amount}'),
                            subtitle: Text(
                              '${transaction.status} - ${transaction.date.toLocal()}'.split(' ')[0],
                            ),
                          );
                        },
                      );
                    } else {
                      return const Center(child: Text('Failed to load transactions.'));
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
