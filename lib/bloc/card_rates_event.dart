import 'package:equatable/equatable.dart';

abstract class CardRatesEvent extends Equatable {
  const CardRatesEvent();

  @override
  List<Object> get props => [];
}

class LoadCardRates extends CardRatesEvent {}
