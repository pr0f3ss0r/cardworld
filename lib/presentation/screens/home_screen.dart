
import 'package:cardworld/presentation/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'upload_screen.dart';
import 'profile_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/card_rates_bloc.dart';
import '../../blocs/card_rates_state.dart';
import '../../blocs/upload_bloc.dart';
import '../../blocs/withdrawal_bloc.dart';
import '../../blocs/transaction_history_bloc.dart';
import '../../blocs/transaction_history_event.dart';
import '../../blocs/account_bloc.dart';
import '../../blocs/account_event.dart';

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
                  builder: (context) => BlocProvider(
                    create: (context) => AccountBloc()..add(LoadAccountBalance()),
                    child: ProfileScreen(),
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
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
