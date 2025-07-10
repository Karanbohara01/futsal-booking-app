import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/my_bookings/my_bookings_event.dart';
import 'package:futsal_frontend/blocs/my_bookings/my_bookings_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';

class MyBookingsBloc extends Bloc<MyBookingsEvent, MyBookingsState> {
  final ApiService apiService;

  MyBookingsBloc({required this.apiService}) : super(MyBookingsInitial()) {
    on<FetchMyBookings>((event, emit) async {
      emit(MyBookingsLoading());
      try {
        final bookings = await apiService.getMyBookings();
        emit(MyBookingsLoaded(bookings: bookings));
      } catch (e) {
        emit(MyBookingsError(message: e.toString()));
      }
    });
  }
}
