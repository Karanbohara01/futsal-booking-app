import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:futsal_frontend/blocs/manage_futsals/manage_futsals_bloc.dart';
import 'package:futsal_frontend/blocs/manage_futsals/manage_futsals_event.dart';
import 'package:futsal_frontend/blocs/manage_futsals/manage_futsals_state.dart';
import 'package:futsal_frontend/data/models/futsal_model.dart';

class EditFutsalScreen extends StatefulWidget {
  final Futsal futsal;
  const EditFutsalScreen({super.key, required this.futsal});

  @override
  State<EditFutsalScreen> createState() => _EditFutsalScreenState();
}

class _EditFutsalScreenState extends State<EditFutsalScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _addressController;
  late TextEditingController _priceController;

  @override
  void initState() {
    super.initState();
    // Pre-fill the text fields with the existing futsal data
    _nameController = TextEditingController(text: widget.futsal.name);
    _addressController = TextEditingController(text: widget.futsal.address);
    _priceController =
        TextEditingController(text: widget.futsal.pricePerHour.toString());
  }

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      context.read<ManageFutsalsBloc>().add(UpdateFutsalButtonPressed(
            futsalId: widget.futsal.id,
            name: _nameController.text,
            address: _addressController.text,
            pricePerHour: int.parse(_priceController.text),
          ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Futsal'),
      ),
      body: BlocListener<ManageFutsalsBloc, ManageFutsalsState>(
        listener: (context, state) {
          if (state is ManageFutsalsLoaded) {
            // If update was successful (list is reloaded), navigate back
            Navigator.of(context).pop();
          } else if (state is ManageFutsalsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error: ${state.message}')),
            );
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(labelText: 'Futsal Name'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a name' : null,
                ),
                TextFormField(
                  controller: _addressController,
                  decoration: const InputDecoration(labelText: 'Address'),
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter an address' : null,
                ),
                TextFormField(
                  controller: _priceController,
                  decoration:
                      const InputDecoration(labelText: 'Price per Hour'),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value!.isEmpty ? 'Please enter a price' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Save Changes'),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
