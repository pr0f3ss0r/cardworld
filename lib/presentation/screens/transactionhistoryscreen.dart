import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  Future<List<Map<String, dynamic>>> _getTransactionHistory() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception("User not logged in");
    }

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('giftcards')
        .where('userId', isEqualTo: user.uid)
        .get();

    return querySnapshot.docs
        .map((doc) => {
              'cardType': doc['cardType'],
              'subCategory': doc['subCategory'],
              'amount': doc['amount'],
              'imageUrl': doc['imageUrl'],
              'timestamp': doc['timestamp'],
              'status': doc['status'] ?? 'Pending',
            })
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transaction History'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _getTransactionHistory(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      // Retry fetching the data
                      (context as Element).reassemble();
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No transactions found.'));
          } else {
            final transactions = snapshot.data!;
            return ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final transaction = transactions[index];
                return Card(
                  child: ListTile(
                    title: Text(transaction['cardType']),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Sub Category: ${transaction['subCategory']}'),
                        Text('Amount: ${transaction['amount']}'),
                        Text(
                          'Date: ${transaction['timestamp'] != null ? _formatTimestamp(transaction['timestamp']) : 'Unknown'}',
                        ),
                        if (transaction['imageUrl'] != null)
                          Image.network(
                            transaction['imageUrl'],
                            height: 100.0,
                          ),
                        Text('Status: ${transaction['status']}'),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }

  String _formatTimestamp(Timestamp? timestamp) {
    if (timestamp == null) return 'Unknown';
    final DateTime dateTime = timestamp.toDate();
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute}';
  }
}
