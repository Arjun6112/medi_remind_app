import 'package:flutter/material.dart';
import 'package:medi_remind_app/features/medication/data/models/medication_model.dart';

class HistoryPage extends StatelessWidget {
  final List<Medication> medications;

  const HistoryPage({super.key, required this.medications});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Medication History',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: _buildHistoryContent(context),
    );
  }

  Widget _buildHistoryContent(BuildContext context) {
    if (medications.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Theme.of(context).colorScheme.primary.withOpacity(0.5),
            ),
            const SizedBox(height: 16),
            Text(
              'No medication history yet',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text(
              'Add medications to start tracking your history',
              style: Theme.of(context).textTheme.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTodaySection(context),
          const SizedBox(height: 32),
          _buildThisWeekSection(context),
          const SizedBox(height: 32),
          _buildAdherenceStats(context),
        ],
      ),
    );
  }

  Widget _buildTodaySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Today', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        ...medications.map(
          (medication) => _buildMedicationHistoryCard(
            context,
            medication,
            _getRandomStatus(),
            DateTime.now(),
          ),
        ),
      ],
    );
  }

  Widget _buildThisWeekSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('This Week', style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 16),
        // Mock data for demonstration
        _buildMedicationHistoryCard(
          context,
          medications.isNotEmpty ? medications[0] : _createMockMedication(),
          'taken',
          DateTime.now().subtract(const Duration(days: 1)),
        ),
        _buildMedicationHistoryCard(
          context,
          medications.isNotEmpty ? medications[0] : _createMockMedication(),
          'missed',
          DateTime.now().subtract(const Duration(days: 2)),
        ),
        _buildMedicationHistoryCard(
          context,
          medications.isNotEmpty ? medications[0] : _createMockMedication(),
          'taken',
          DateTime.now().subtract(const Duration(days: 3)),
        ),
      ],
    );
  }

  Widget _buildMedicationHistoryCard(
    BuildContext context,
    Medication medication,
    String status,
    DateTime date,
  ) {
    final statusColor = status == 'taken'
        ? Colors.green
        : status == 'missed'
        ? Colors.red
        : Colors.orange;

    final statusIcon = status == 'taken'
        ? Icons.check_circle
        : status == 'missed'
        ? Icons.cancel
        : Icons.schedule;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.medication,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medication.name,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${medication.dosage} • ${medication.time.format(context)}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    _formatDate(date),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Icon(statusIcon, color: statusColor, size: 16),
                  const SizedBox(width: 4),
                  Text(
                    status.toUpperCase(),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: statusColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdherenceStats(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Adherence Statistics',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem(context, '85%', 'This Week', Colors.green),
                    _buildStatItem(context, '92%', 'This Month', Colors.blue),
                    _buildStatItem(context, '78%', 'Overall', Colors.purple),
                  ],
                ),
                const SizedBox(height: 20),
                Text(
                  'Keep up the great work! Your medication adherence is excellent.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String percentage,
    String label,
    Color color,
  ) {
    return Column(
      children: [
        Text(
          percentage,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;

    if (difference == 0) {
      return 'Today';
    } else if (difference == 1) {
      return 'Yesterday';
    } else if (difference < 7) {
      return '$difference days ago';
    } else {
      return '${date.month}/${date.day}/${date.year}';
    }
  }

  String _getRandomStatus() {
    final statuses = ['taken', 'missed', 'scheduled'];
    return statuses[DateTime.now().millisecondsSinceEpoch % statuses.length];
  }

  Medication _createMockMedication() {
    return Medication(
      id: 'mock',
      name: 'Sample Medication',
      dosage: '500mg',
      frequency: 'Once daily',
      time: TimeOfDay.now(),
      times: [TimeOfDay.now()],
      startDate: DateTime.now(),
    );
  }
}
