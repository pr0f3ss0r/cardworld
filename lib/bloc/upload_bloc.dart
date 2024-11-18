import 'package:flutter_bloc/flutter_bloc.dart';
import 'upload_event.dart';
import 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc() : super(UploadInitial()) {
    on<UploadGiftCard>(_onUploadGiftCard);
  }

  void _onUploadGiftCard(UploadGiftCard event, Emitter<UploadState> emit) async {
    emit(UploadInProgress());
    try {
      // Mock upload process, replace with actual backend call
      await Future.delayed(const Duration(seconds: 2));
      emit(UploadSuccess());
    } catch (e) {
      emit(UploadFailure("Failed to upload gift card"));
    }
  }
}
