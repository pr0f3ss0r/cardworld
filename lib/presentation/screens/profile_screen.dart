import 'package:cardworld/presentation/screens/transactionhistoryscreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/account_bloc.dart';
import '../../blocs/account_event.dart';
import '../../blocs/account_state.dart';  // Assuming you have created this screen

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _withdrawalAmountController =
      TextEditingController();

  Future<void> _handleWithdraw() async {
    final amount = double.tryParse(_withdrawalAmountController.text);
    if (amount != null && amount > 0) {
      // Trigger an event to process withdrawal via the AccountBloc
      BlocProvider.of<AccountBloc>(context)
          .add(RequestWithdrawal(amount: amount));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please enter a valid amount to withdraw')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: BlocBuilder<AccountBloc, AccountState>(
        builder: (context, state) {
          if (state is AccountLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is AccountLoaded) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Name: ${state.userName ?? 'No name provided'}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 8.0),
                  Text(
                    'Email: ${state.email ?? 'No email provided'}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                  Text(
                      'Account Balance: \$${state.balance.toStringAsFixed(2)}'),
                  const SizedBox(height: 16.0),
                  TextFormField(
                    controller: _withdrawalAmountController,
                    decoration: const InputDecoration(
                      labelText: 'Withdrawal Amount',
                    ),
                    keyboardType: TextInputType.number,
                  ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: _handleWithdraw,
                    child: const Text('Withdraw'),
                  ),
                  if (state.withdrawalStatus == WithdrawalStatus.processing)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(child: CircularProgressIndicator()),
                    ),
                  if (state.withdrawalStatus == WithdrawalStatus.success)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child: Center(child: Text('Withdrawal successful!')),
                    ),
                  if (state.withdrawalStatus == WithdrawalStatus.failure)
                    const Padding(
                      padding: EdgeInsets.only(top: 16.0),
                      child:
                          Center(child: Text('Withdrawal failed. Try again.')),
                    ),
                  const SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              const TransactionHistoryScreen(),
                        ),
                      );
                    },
                    child: const Text('View Transaction History'),
                  ),
                ],
              ),
            );
          } else {
            return const Center(child: Text('Failed to load account details.'));
          }
        },
      ),
    );
  }
}
