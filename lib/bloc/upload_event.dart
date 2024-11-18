import 'dart:io';

import 'package:equatable/equatable.dart';

abstract class UploadEvent extends Equatable {
  const UploadEvent();

  @override
  List<Object> get props => [];
}

class UploadGiftCard extends UploadEvent {
  final String cardType;
  final String amount;
  final File image;

  const UploadGiftCard(this.cardType, this.amount, this.image);

  @override
  List<Object> get props => [cardType, amount, image];
}
