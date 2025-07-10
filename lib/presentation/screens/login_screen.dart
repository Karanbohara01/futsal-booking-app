import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/auth/auth_bloc.dart';
import 'package:futsal_frontend/blocs/auth/auth_event.dart';
import 'package:futsal_frontend/blocs/auth/auth_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';
import 'package:futsal_frontend/presentation/screens/home_screen.dart';
import 'package:futsal_frontend/presentation/screens/register_screen.dart';

class LoginScreen extends StatefulWidget {
  // Add the apiService as a final field
  final ApiService apiService;
  const LoginScreen({super.key, required this.apiService});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            // Pass the apiService instance to the HomeScreen
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (context) => HomeScreen(apiService: widget.apiService),
              ),
            );
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.error)),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () {
                    context.read<AuthBloc>().add(LoginButtonPressed(
                          email: _emailController.text,
                          password: _passwordController.text,
                        ));
                  },
                  child: const Text('Login'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => BlocProvider.value(
                          value: BlocProvider.of<AuthBloc>(context),
                          child: const RegisterScreen(),
                        ),
                      ),
                    );
                  },
                  child: const Text("Don't have an account? Register"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
