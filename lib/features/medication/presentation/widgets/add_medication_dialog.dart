import 'package:flutter/material.dart';
import 'package:medi_remind_app/features/medication/data/models/medication_model.dart';

class AddMedicationDialog extends StatefulWidget {
  final Function(Medication) onMedicationAdded;

  const AddMedicationDialog({super.key, required this.onMedicationAdded});

  @override
  State<AddMedicationDialog> createState() => _AddMedicationDialogState();
}

class _AddMedicationDialogState extends State<AddMedicationDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _notesController = TextEditingController();

  String _selectedFrequency = 'Once daily';
  TimeOfDay _selectedTime = TimeOfDay.now();
  List<TimeOfDay> _selectedTimes = [];

  final List<String> _frequencies = [
    'Once daily',
    'Twice daily',
    'Three times daily',
    'Four times daily',
    'Every 6 hours',
    'Every 8 hours',
    'Every 12 hours',
    'As needed',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        constraints: const BoxConstraints(maxHeight: 600),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.medical_services,
                      color: Theme.of(context).colorScheme.primary,
                      size: 28,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'Add Medication',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Medication Name
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    labelText: 'Medication Name',
                    hintText: 'e.g., Aspirin, Vitamin D',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.medication),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter medication name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Dosage
                TextFormField(
                  controller: _dosageController,
                  decoration: InputDecoration(
                    labelText: 'Dosage',
                    hintText: 'e.g., 500mg, 1 tablet',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.scale),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter dosage';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Frequency
                DropdownButtonFormField<String>(
                  value: _selectedFrequency,
                  decoration: InputDecoration(
                    labelText: 'Frequency',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.schedule),
                  ),
                  items: _frequencies.map((frequency) {
                    return DropdownMenuItem(
                      value: frequency,
                      child: Text(frequency),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedFrequency = value!;
                      _updateTimesBasedOnFrequency();
                    });
                  },
                ),
                const SizedBox(height: 16),

                // Time Picker
                InkWell(
                  onTap: _selectTime,
                  child: InputDecorator(
                    decoration: InputDecoration(
                      labelText: 'Time',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      prefixIcon: const Icon(Icons.access_time),
                    ),
                    child: Text(
                      _selectedTime.format(context),
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Notes
                TextFormField(
                  controller: _notesController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    hintText: 'Additional instructions or reminders',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    prefixIcon: const Icon(Icons.note),
                  ),
                ),
                const SizedBox(height: 24),

                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: _addMedication,
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: const Text('Add Medication'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _updateTimesBasedOnFrequency() {
    // This is a simple implementation - in a real app, you'd have more sophisticated time management
    switch (_selectedFrequency) {
      case 'Once daily':
        _selectedTimes = [_selectedTime];
        break;
      case 'Twice daily':
        _selectedTimes = [
          _selectedTime,
          TimeOfDay(
            hour: (_selectedTime.hour + 12) % 24,
            minute: _selectedTime.minute,
          ),
        ];
        break;
      case 'Three times daily':
        _selectedTimes = [
          _selectedTime,
          TimeOfDay(
            hour: (_selectedTime.hour + 8) % 24,
            minute: _selectedTime.minute,
          ),
          TimeOfDay(
            hour: (_selectedTime.hour + 16) % 24,
            minute: _selectedTime.minute,
          ),
        ];
        break;
      default:
        _selectedTimes = [_selectedTime];
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _updateTimesBasedOnFrequency();
      });
    }
  }

  void _addMedication() {
    if (_formKey.currentState!.validate()) {
      final medication = Medication(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        name: _nameController.text.trim(),
        dosage: _dosageController.text.trim(),
        frequency: _selectedFrequency,
        time: _selectedTime,
        times: _selectedTimes,
        startDate: DateTime.now(),
        notes: _notesController.text.isNotEmpty
            ? _notesController.text.trim()
            : null,
      );

      widget.onMedicationAdded(medication);
      Navigator.of(context).pop();
    }
  }
}
