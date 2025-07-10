import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/my_bookings/my_bookings_bloc.dart';
import 'package:futsal_frontend/blocs/my_bookings/my_bookings_event.dart';
import 'package:futsal_frontend/blocs/my_bookings/my_bookings_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';
import 'package:intl/intl.dart';

class MyBookingsScreen extends StatelessWidget {
  final ApiService apiService;
  const MyBookingsScreen({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          MyBookingsBloc(apiService: apiService)..add(FetchMyBookings()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Bookings'),
        ),
        body: BlocBuilder<MyBookingsBloc, MyBookingsState>(
          builder: (context, state) {
            if (state is MyBookingsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is MyBookingsLoaded) {
              if (state.bookings.isEmpty) {
                return const Center(child: Text('You have no bookings yet.'));
              }
              return ListView.builder(
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return Card(
                    margin: const EdgeInsets.all(8.0),
                    child: ListTile(
                      title: Text(booking.futsalName,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          '${booking.futsalAddress}\nDate: ${DateFormat.yMMMd().format(booking.date)}\nTime: ${booking.timeSlot}'),
                      trailing: Text(booking.status,
                          style: TextStyle(
                              color: booking.status == 'confirmed'
                                  ? Colors.green
                                  : Colors.red)),
                      isThreeLine: true,
                    ),
                  );
                },
              );
            }
            if (state is MyBookingsError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('Tap to load bookings.'));
          },
        ),
      ),
    );
  }
}
