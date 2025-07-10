import 'package:equatable/equatable.dart';
import 'package:futsal_frontend/data/models/booking_model.dart';

abstract class MyBookingsState extends Equatable {
  const MyBookingsState();

  @override
  List<Object> get props => [];
}

class MyBookingsInitial extends MyBookingsState {}

class MyBookingsLoading extends MyBookingsState {}

class MyBookingsLoaded extends MyBookingsState {
  final List<Booking> bookings;

  const MyBookingsLoaded({required this.bookings});

  @override
  List<Object> get props => [bookings];
}

class MyBookingsError extends MyBookingsState {
  final String message;

  const MyBookingsError({required this.message});

  @override
  List<Object> get props => [message];
}
