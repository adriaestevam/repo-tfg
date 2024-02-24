import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../Domain/NavigatorBloc/navigator_event.dart';
import '../Widgets/bottom_navigation_widget.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi Calendario de Eventos',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class Event {
  final String name;
  final IconData icon;

  Event(this.name, this.icon);
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final List<Event> _events;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  @override
  void initState() {
    super.initState();
    _events = [
      Event('Yoga', Icons.self_improvement),
      Event('Lunch', Icons.lunch_dining),
      Event('Gym Meeting', Icons.fitness_center),
      // Add more events if needed
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Assume AppTheme is defined somewhere in your application
    final appTheme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Mi Horario'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              // Navigate to profile settings
            },
          ),
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              // Navigate to general settings
            },
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          TableCalendar(
            firstDay: DateTime.utc(2010, 10, 16),
            lastDay: DateTime.utc(2030, 3, 14),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            // Apply the app theme to TableCalendar if needed
            calendarStyle: CalendarStyle(
              // Use properties from appTheme
            ),
            headerStyle: HeaderStyle(
              // Use properties from appTheme
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _events.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Icon(_events[index].icon),
                  title: Text(_events[index].name),
                  onTap: () {
                    // Handle the tap on an event
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          // Add logic to create a new event
        },
      ), // Your custom bottom navigation bar
    );
  }
}
