import 'package:dio/dio.dart';
import 'package:futsal_frontend/data/models/booking_model.dart';
import 'package:futsal_frontend/data/models/futsal_model.dart';

class ApiService {
  final Dio _dio;
  String? _token;

  ApiService()
      : _dio = Dio(
          BaseOptions(
            // For Android Emulator, use 'http://10.0.2.2:3000/api'
            // For web testing, use 'http://localhost:3000/api'
            // baseUrl: 'http://10.0.2.2:3000/api',
            baseUrl: 'http://localhost:3000/api',
            connectTimeout: const Duration(seconds: 5),
            receiveTimeout: const Duration(seconds: 3),
          ),
        ) {
    // This interceptor automatically adds the token to every request.
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_token != null) {
            options.headers['Authorization'] = 'Bearer $_token';
          }
          return handler.next(options);
        },
      ),
    );
  }

  // Method to set the token after login
  void setAuthToken(String token) {
    _token = token;
  }

  // --- Auth Methods ---
  Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      await _dio.post(
        '/auth/register',
        data: {
          'name': name,
          'email': email,
          'password': password,
          'role': 'user',
        },
      );
    } on DioException catch (e) {
      throw Exception(
          'Failed to register: ${e.response?.data['error'] ?? e.message}');
    }
  }

  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      final token = response.data['token'] as String;
      setAuthToken(token); // Set the token for future requests
      return token;
    } on DioException catch (e) {
      throw Exception(
          'Failed to log in: ${e.response?.data['error'] ?? e.message}');
    }
  }

  // --- Futsal Methods ---
  Future<List<Futsal>> getFutsals() async {
    try {
      final response = await _dio.get('/futsal');
      final List<dynamic> data = response.data['data'];
      return data.map((json) => Futsal.fromJson(json)).toList();
    } on DioException catch (e) {
      throw Exception('Failed to load futsals: ${e.message}');
    }
  }

  // --- Booking Methods ---
  Future<void> createBooking({
    required String futsalId,
    required DateTime date,
    required String timeSlot,
  }) async {
    try {
      await _dio.post(
        '/bookings',
        data: {
          'futsalId': futsalId,
          'date': date.toIso8601String(),
          'time_slot': timeSlot,
        },
      );
    } on DioException catch (e) {
      throw Exception(
          'Failed to create booking: ${e.response?.data['error'] ?? e.message}');
    }
  }

  Future<List<Booking>> getMyBookings() async {
    try {
      final response = await _dio.get('/bookings/mybookings');
      if (response.statusCode == 200) {
        // Map the dynamic list to a list of Booking objects
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Booking.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load bookings');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to load bookings: ${e.response?.data['error'] ?? e.message}');
    }
  }

  Future<List<Futsal>> getOwnerFutsals() async {
    try {
      final response = await _dio.get('/futsal/myfutsals');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => Futsal.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load owner futsals');
      }
    } on DioException catch (e) {
      throw Exception(
          'Failed to load owner futsals: ${e.response?.data['error'] ?? e.message}');
    }
  }

  Future<void> createFutsal({
    required String name,
    required String address,
    required int pricePerHour,
  }) async {
    try {
      // This requires the user to be logged in as an owner.
      // Our interceptor will automatically add the auth token.
      await _dio.post(
        '/futsal',
        data: {
          'name': name,
          'address': address,
          'price_per_hour': pricePerHour,
        },
      );
    } on DioException catch (e) {
      throw Exception(
          'Failed to create futsal: ${e.response?.data['error'] ?? e.message}');
    }
  }

  Future<void> deleteFutsal(String futsalId) async {
    try {
      await _dio.delete('/futsal/$futsalId');
    } on DioException catch (e) {
      throw Exception(
          'Failed to delete futsal: ${e.response?.data['error'] ?? e.message}');
    }
  }

  Future<void> updateFutsal(String futsalId, Map<String, dynamic> data) async {
    try {
      await _dio.put('/futsal/$futsalId', data: data);
    } on DioException catch (e) {
      throw Exception(
          'Failed to update futsal: ${e.response?.data['error'] ?? e.message}');
    }
  }
}
