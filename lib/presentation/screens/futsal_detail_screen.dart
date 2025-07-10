import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/booking/booking_bloc.dart';
import 'package:futsal_frontend/blocs/booking/booking_event.dart';
import 'package:futsal_frontend/blocs/booking/booking_state.dart';
import 'package:futsal_frontend/data/models/futsal_model.dart';
import 'package:intl/intl.dart';

class FutsalDetailScreen extends StatefulWidget {
  final Futsal futsal;
  const FutsalDetailScreen({super.key, required this.futsal});

  @override
  State<FutsalDetailScreen> createState() => _FutsalDetailScreenState();
}

class _FutsalDetailScreenState extends State<FutsalDetailScreen> {
  DateTime? _selectedDate;
  String? _selectedTimeSlot;

  final List<String> _timeSlots = [
    '07:00 AM - 08:00 AM',
    '08:00 AM - 09:00 AM',
    '09:00 AM - 10:00 AM',
    '10:00 AM - 11:00 AM',
    '04:00 PM - 05:00 PM',
    '05:00 PM - 06:00 PM',
  ];

  void _presentDatePicker() {
    showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    ).then((pickedDate) {
      if (pickedDate == null) return;
      setState(() => _selectedDate = pickedDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.futsal.name)),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking Successful!')),
            );
            Navigator.of(context).pop(); // Go back to the home screen
          } else if (state is BookingFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.futsal.name,
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 8),
                Text(widget.futsal.address,
                    style: Theme.of(context).textTheme.titleMedium),
                const SizedBox(height: 16),
                Text('Price: Rs. ${widget.futsal.pricePerHour} per hour',
                    style: Theme.of(context).textTheme.titleLarge),
                const Divider(height: 40),

                // Date and Time Selection UI
                Row(
                  children: [
                    Expanded(
                        child: Text(_selectedDate == null
                            ? 'No Date Chosen'
                            : 'Date: ${DateFormat.yMd().format(_selectedDate!)}')),
                    TextButton(
                        onPressed: _presentDatePicker,
                        child: const Text('Choose Date')),
                  ],
                ),
                const SizedBox(height: 16),
                DropdownButton<String>(
                  hint: const Text('Select a Time Slot'),
                  value: _selectedTimeSlot,
                  isExpanded: true,
                  items: _timeSlots
                      .map((slot) =>
                          DropdownMenuItem(value: slot, child: Text(slot)))
                      .toList(),
                  onChanged: (newValue) =>
                      setState(() => _selectedTimeSlot = newValue),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed:
                        (_selectedDate == null || _selectedTimeSlot == null)
                            ? null
                            : () {
                                context
                                    .read<BookingBloc>()
                                    .add(CreateBookingButtonPressed(
                                      futsalId: widget.futsal.id,
                                      date: _selectedDate!,
                                      timeSlot: _selectedTimeSlot!,
                                    ));
                              },
                    child: state is BookingLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text('Confirm Booking'),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
