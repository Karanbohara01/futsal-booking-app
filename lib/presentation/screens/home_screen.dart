import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/booking/booking_bloc.dart';
import 'package:futsal_frontend/blocs/futsal/futsal_bloc.dart';
import 'package:futsal_frontend/blocs/futsal/futsal_event.dart';
import 'package:futsal_frontend/blocs/futsal/futsal_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';
import 'package:futsal_frontend/presentation/screens/futsal_detail_screen.dart';
import 'package:futsal_frontend/presentation/screens/manage_futsals_screen.dart';
import 'package:futsal_frontend/presentation/screens/my_bookings_screen.dart';

class HomeScreen extends StatelessWidget {
  final ApiService apiService;

  const HomeScreen({super.key, required this.apiService});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          FutsalBloc(apiService: apiService)..add(FetchFutsals()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Futsal Grounds'),
          // The actions property takes a list of widgets
          actions: [
            // Button 1: My Bookings
            IconButton(
              icon: const Icon(Icons.calendar_today),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => MyBookingsScreen(apiService: apiService),
                  ),
                );
              },
            ),
            // Button 2: Manage My Futsals
            IconButton(
              icon: const Icon(Icons.edit_note),
              tooltip: 'Manage My Futsals',
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ManageFutsalsScreen(apiService: apiService),
                  ),
                );
              },
            ),
          ],
        ),
        body: BlocBuilder<FutsalBloc, FutsalState>(
          builder: (context, state) {
            if (state is FutsalLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is FutsalLoaded) {
              return ListView.builder(
                itemCount: state.futsals.length,
                itemBuilder: (context, index) {
                  final futsal = state.futsals[index];
                  return ListTile(
                    title: Text(futsal.name),
                    subtitle: Text(futsal.address),
                    trailing: Text('Rs. ${futsal.pricePerHour}/hr'),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => BlocProvider(
                            create: (context) =>
                                BookingBloc(apiService: apiService),
                            child: FutsalDetailScreen(futsal: futsal),
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }
            if (state is FutsalError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: Text('No futsal grounds found.'));
          },
        ),
      ),
    );
  }
}
