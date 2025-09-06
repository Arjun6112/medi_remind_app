import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medi_remind_app/features/home/presentation/blocs/home_bloc.dart';

class HomePage extends StatelessWidget {
  final VoidCallback? onThemeToggle;
  final ThemeMode? currentThemeMode;

  const HomePage({super.key, this.onThemeToggle, this.currentThemeMode});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => HomeBloc()..add(HomeLoadEvent()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'MediMinder',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 24,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: Icon(
                currentThemeMode == ThemeMode.dark
                    ? Icons.light_mode
                    : Icons.dark_mode,
              ),
              onPressed: onThemeToggle,
              tooltip: currentThemeMode == ThemeMode.dark
                  ? 'Switch to Light Mode'
                  : 'Switch to Dark Mode',
            ),
          ],
        ),
        body: BlocBuilder<HomeBloc, HomeState>(
          builder: (context, state) {
            if (state is HomeLoaded) {
              return _buildHomeContent(context);
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            // Navigate to camera
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Camera feature coming soon!')),
            );
          },
          tooltip: 'Scan Medication',
          child: const Icon(Icons.camera_alt),
        ),
      ),
    );
  }

  Widget _buildHomeContent(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          Text(
            'Welcome back!',
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          const SizedBox(height: 8),
          Text(
            'Keep track of your medications and stay healthy.',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 32),
          _buildStreakSection(context),
          const SizedBox(height: 32),
          _buildQuickActions(context),
          const SizedBox(height: 32),
          _buildUpcomingReminders(context),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'Add Medication',
                Icons.add,
                () {
                  // Navigate to add medication
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Add medication feature coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context,
                'Scan Document',
                Icons.document_scanner,
                () {
                  // Navigate to camera
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scan feature coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildActionCard(
                context,
                'View History',
                Icons.history,
                () {
                  // Navigate to history
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('History feature coming soon!')),
                  );
                },
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildActionCard(
                context,
                'Symptom Diary',
                Icons.note_alt,
                () {
                  // Navigate to symptom diary
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Symptom diary coming soon!')),
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Icon(
                icon,
                size: 32,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingReminders(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Upcoming Reminders',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'No upcoming reminders',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Add your first medication to get started',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStreakSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Your Progress',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.local_fire_department,
                      color: Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      '7',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.orange,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Day Streak!',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Keep it up! You\'re doing great.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                _buildWeekCalendar(context),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeekCalendar(BuildContext context) {
    final days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final completedDays = [true, true, true, true, true, true, true]; // Mock data

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(7, (index) {
        return Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: completedDays[index]
                    ? Theme.of(context).colorScheme.primary
                    : Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                  width: 1,
                ),
              ),
              child: Center(
                child: completedDays[index]
                    ? Icon(
                        Icons.check,
                        color: Theme.of(context).colorScheme.onPrimary,
                        size: 20,
                      )
                    : Text(
                        days[index],
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              days[index],
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        );
      }),
    );
  }
}
