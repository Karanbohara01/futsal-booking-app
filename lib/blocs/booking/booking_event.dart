import 'package:equatable/equatable.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object> get props => [];
}

class CreateBookingButtonPressed extends BookingEvent {
  final String futsalId;
  final DateTime date;
  final String timeSlot;

  const CreateBookingButtonPressed({
    required this.futsalId,
    required this.date,
    required this.timeSlot,
  });

  @override
  List<Object> get props => [futsalId, date, timeSlot];
}
