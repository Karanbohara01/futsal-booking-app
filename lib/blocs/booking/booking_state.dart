import 'package:equatable/equatable.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingSuccess extends BookingState {}

class BookingFailure extends BookingState {
  final String error;

  const BookingFailure({required this.error});

  @override
  List<Object> get props => [error];
}
