import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/manage_futsals/manage_futsals_bloc.dart';
import 'package:futsal_frontend/blocs/manage_futsals/manage_futsals_event.dart';
import 'package:futsal_frontend/blocs/manage_futsals/manage_futsals_state.dart';
import 'package:futsal_frontend/data/services/api_service.dart';
import 'package:futsal_frontend/presentation/screens/add_futsal_screen.dart';
import 'package:futsal_frontend/presentation/screens/edit_futsal_screen.dart';

class ManageFutsalsScreen extends StatelessWidget {
  final ApiService apiService;
  const ManageFutsalsScreen({super.key, required this.apiService});

// lib/presentation/screens/manage_futsals_screen.dart

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ManageFutsalsBloc(apiService: apiService)..add(FetchOwnerFutsals()),
      // Add a Builder widget here
      child: Builder(
        builder: (context) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Manage My Futsals'),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    // Now this context can find the Bloc
                    builder: (_) => BlocProvider.value(
                      value: BlocProvider.of<ManageFutsalsBloc>(context),
                      child: const AddFutsalScreen(),
                    ),
                  ),
                );
              },
              child: const Icon(Icons.add),
            ),
            body: BlocBuilder<ManageFutsalsBloc, ManageFutsalsState>(
              builder: (context, state) {
                if (state is ManageFutsalsLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is ManageFutsalsLoaded) {
                  if (state.futsals.isEmpty) {
                    return const Center(
                        child:
                            Text("You haven't added any futsal grounds yet."));
                  }
                  return ListView.builder(
                    itemCount: state.futsals.length,
                    itemBuilder: (context, index) {
                      final futsal = state.futsals[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                        child: ListTile(
                          title: Text(futsal.name),
                          subtitle: Text(futsal.address),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  // Show a confirmation dialog before deleting
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return AlertDialog(
                                        title: const Text('Confirm Deletion'),
                                        content: const Text(
                                            'Are you sure you want to delete this futsal ground?'),
                                        actions: <Widget>[
                                          TextButton(
                                            child: const Text('Cancel'),
                                            onPressed: () {
                                              Navigator.of(dialogContext)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                          TextButton(
                                            child: const Text('Delete'),
                                            onPressed: () {
                                              // Dispatch the delete event to the Bloc
                                              context
                                                  .read<ManageFutsalsBloc>()
                                                  .add(
                                                      DeleteFutsalButtonPressed(
                                                          futsal.id));
                                              Navigator.of(dialogContext)
                                                  .pop(); // Close the dialog
                                            },
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              ),
                              IconButton(
                                icon:
                                    const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () {
                                  // Navigate to the Edit screen, passing the futsal data
                                  // and the existing Bloc instance.
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) => BlocProvider.value(
                                        value:
                                            BlocProvider.of<ManageFutsalsBloc>(
                                                context),
                                        child: EditFutsalScreen(futsal: futsal),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                if (state is ManageFutsalsError) {
                  return Center(child: Text(state.message));
                }
                return const Center(child: Text('Welcome, Owner!'));
              },
            ),
          );
        },
      ),
    );
  }
}
