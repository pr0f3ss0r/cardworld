import 'package:flutter/material.dart';
import 'upload_screen.dart';
import 'profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/card_rates_bloc.dart';
import '../bloc/card_rates_state.dart';
import '../bloc/upload_bloc.dart';
import '../bloc/withdrawal_bloc.dart';
import '../bloc/transaction_history_bloc.dart';
import '../bloc/transaction_history_event.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CardWorld - Gift Cards'),
        actions: [
          IconButton(
            icon: Icon(Icons.account_circle),
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create: (context) => WithdrawalBloc(),
                      ),
                      BlocProvider(
                        create: (context) => TransactionHistoryBloc()..add(LoadTransactionHistory()),
                      ),
                    ],
                    child: ProfileScreen(),
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<CardRatesBloc, CardRatesState>(
        builder: (context, state) {
          if (state is CardRatesLoading) {
            return Center(child: CircularProgressIndicator());
          } else if (state is CardRatesLoaded) {
            return ListView.builder(
              itemCount: state.cardRates.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    title: Text(state.cardRates[index]),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => BlocProvider(
                          create: (context) => UploadBloc(),
                          child: UploadScreen(),
                        ),
                      ));
                    },
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('Failed to load gift card rates.'));
          }
        },
      ),
    );
  }
}
