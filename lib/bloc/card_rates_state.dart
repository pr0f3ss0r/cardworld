import 'package:equatable/equatable.dart';

abstract class CardRatesState extends Equatable {
  const CardRatesState();

  @override
  List<Object> get props => [];
}

class CardRatesLoading extends CardRatesState {}

class CardRatesLoaded extends CardRatesState {
  final List<String> cardRates; // Replace with actual model later

  const CardRatesLoaded(this.cardRates);

  @override
  List<Object> get props => [cardRates];
}

class CardRatesError extends CardRatesState {}
