import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/auth/auth_event.dart';
import 'package:futsal_frontend/blocs/auth/auth_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final ApiService apiService;

  AuthBloc({required this.apiService}) : super(AuthInitial()) {
    // CORRECTED: Registration should just emit a simple success state.
    on<RegisterButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        await apiService.registerUser(
          name: event.name,
          email: event.email,
          password: event.password,
        );
        emit(AuthSuccess()); // No token is handled here.
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });

    // CORRECT: This login logic is correct.
    on<LoginButtonPressed>((event, emit) async {
      emit(AuthLoading());
      try {
        final token = await apiService.loginUser(
          email: event.email,
          password: event.password,
        );

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        emit(AuthSuccess(token: token));
      } catch (e) {
        emit(AuthFailure(error: e.toString()));
      }
    });
  }
}
