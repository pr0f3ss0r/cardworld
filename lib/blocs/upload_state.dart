import 'package:equatable/equatable.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class UploadInitial extends UploadState {}

class UploadLoading extends UploadState {
  final double progress; // Represents the upload progress from 0.0 to 1.0

  const UploadLoading(this.progress);

  @override
  List<Object> get props => [progress];
}

class UploadSuccess extends UploadState {}

class UploadFailure extends UploadState {
  final String error;

  const UploadFailure(this.error);

  @override
  List<Object> get props => [error];
}
