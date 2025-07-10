import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/booking/booking_event.dart';
import 'package:futsal_frontend/blocs/booking/booking_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final ApiService apiService;

  BookingBloc({required this.apiService}) : super(BookingInitial()) {
    on<CreateBookingButtonPressed>((event, emit) async {
      emit(BookingLoading());
      try {
        await apiService.createBooking(
          futsalId: event.futsalId,
          date: event.date,
          timeSlot: event.timeSlot,
        );
        emit(BookingSuccess());
      } catch (e) {
        emit(BookingFailure(error: e.toString()));
      }
    });
  }
}
