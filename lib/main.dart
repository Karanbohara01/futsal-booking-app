// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/auth/auth_bloc.dart';
import 'package:futsal_frontend/data/services/api_service.dart';
import 'package:futsal_frontend/presentation/screens/login_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a single instance of ApiService
    final ApiService apiService = ApiService();

    return MaterialApp(
      title: 'Futsal Booking App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BlocProvider(
        // Provide the single ApiService instance to the AuthBloc
        create: (context) => AuthBloc(apiService: apiService),
        child: LoginScreen(apiService: apiService), // Pass it to LoginScreen
      ),
    );
  }
}
