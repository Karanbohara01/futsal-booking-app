import 'package:equatable/equatable.dart';

abstract class MyBookingsEvent extends Equatable {
  const MyBookingsEvent();

  @override
  List<Object> get props => [];
}

class FetchMyBookings extends MyBookingsEvent {}
