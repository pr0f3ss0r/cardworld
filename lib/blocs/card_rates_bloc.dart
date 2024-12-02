import 'package:flutter_bloc/flutter_bloc.dart';
import 'card_rates_event.dart';
import 'card_rates_state.dart';

class CardRatesBloc extends Bloc<CardRatesEvent, CardRatesState> {
  CardRatesBloc() : super(CardRatesLoading()) {
    // Register the handler for LoadCardRates event
    on<LoadCardRates>(_onLoadCardRates);
  }

  void _onLoadCardRates(LoadCardRates event, Emitter<CardRatesState> emit) async {
    emit(CardRatesLoading());
    try {
      // Mock data for now, replace with actual data fetching logic
      await Future.delayed(Duration(seconds: 2));
      emit(CardRatesLoaded(['Gift Card 1: N50', 'Gift Card 2: N60']));
    } catch (_) {
      emit(CardRatesError());
    }
  }
}
