import 'package:flutter_bloc/flutter_bloc.dart';
import 'upload_event.dart';
import 'upload_state.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  UploadBloc() : super(UploadInitial()) {
    on<UploadGiftCard>(_onUploadGiftCard);
  }

  Future<void> _onUploadGiftCard(UploadGiftCard event, Emitter<UploadState> emit) async {
    emit(UploadLoading(0.0));

    try {
      // Ensure the image file is available before uploading
      if (!event.image.existsSync()) {
        throw Exception("Image file not found");
      }

      // Generate a unique file name based on timestamp
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final storageRef = FirebaseStorage.instance.ref().child('giftcards/$fileName');

      // Start the file upload task
      final uploadTask = storageRef.putFile(event.image);

      // Listen to upload progress and emit updates
      uploadTask.snapshotEvents.listen((snapshot) {
        final progress = snapshot.bytesTransferred / snapshot.totalBytes;
        emit(UploadLoading(progress));
      });

      // Wait for the upload to complete
      final storageSnapshot = await uploadTask;

      // Get the download URL of the uploaded file
      final imageUrl = await storageSnapshot.ref.getDownloadURL();

      // Save the details to Firestore
      await FirebaseFirestore.instance.collection('giftcards').add({
        'cardType': event.cardType,
        'subCategory': event.subCategory,
        'amount': event.amount,
        'imageUrl': imageUrl,
        'timestamp': FieldValue.serverTimestamp(),
      });

      emit(UploadSuccess());
    } catch (e) {
      emit(UploadFailure('Failed to upload gift card: $e'));
    }
  }
}
