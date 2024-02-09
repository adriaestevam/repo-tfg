import 'package:flutter/material.dart';
import 'package:login_signup_v2/classes/event.dart';
import 'package:login_signup_v2/classes/events_repository.dart';
import 'package:login_signup_v2/pages/notification_page.dart';
import 'package:login_signup_v2/pages/objectives_page.dart';
import 'package:login_signup_v2/pages/subjects_page.dart';
import 'package:tfg_v1/Presentation/lib/utilities/app_colors.dart';
import 'package:login_signup_v2/widgets/bottom_navigation_widget.dart';
import 'package:flutter_calendar_carousel/flutter_calendar_carousel.dart' show CalendarCarousel;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final EventsRepository _eventsRepository = EventsRepository(); // Create an instance of EventsRepository
  late Map<DateTime, List<Event>> _markedDateMap; // Define the marked date map

  @override
  void initState() {
    super.initState();
    _markedDateMap = {}; // Initialize the marked date map
    _loadEvents(); // Load events when the widget initializes
  }

  void _loadEvents() {
    // Load events from the repository and update the _markedDateMap
    final List<Event> allEvents = _eventsRepository.getAllEvents();
    setState(() {
      _markedDateMap = _generateMarkedDateMap(allEvents);
    });
  }

  Map<DateTime, List<Event>> _generateMarkedDateMap(List<Event> events) {
    final Map<DateTime, List<Event>> markedDateMap = {};
    for (final event in events) {
      markedDateMap[event.date] = [event];
    }
    return markedDateMap;
  }

  // Function to show a dialog for adding events
  Future<void> _showAddEventDialog(BuildContext context) async {
    // Implement your logic to add events and update the repository
    // You can use a dialog or navigate to another page for adding events
    // Example:
    final newEvent = Event('Sample Event', DateTime.now());
    _eventsRepository.addEvent(newEvent);

    // Refresh the UI
    setState(() {
      _loadEvents();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: AppColors.text),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.settings, color: AppColors.text),
            onPressed: () {},
          ),
        ],
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              color: AppColors.background,
              child: CalendarCarousel(
                selectedDateTime: DateTime.now(),
                todayBorderColor: Colors.transparent,
                onDayPressed: (DateTime date, List<Event> events) {
                  // Handle day selection, you can display events for the selected day
                  print('Selected day: $date');
                  print('Events: $events');
                },
                markedDatesMap: _markedDateMap, // Pass events to the calendar
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Open a dialog or navigate to another page to add events
              _showAddEventDialog(context);
            },
            child: const Text('Add Event'),
          ),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        onTabTapped: (index) {
          switch (index) {
            case 0:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const HomePage()));
              break;
            case 1:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ObjectivesPage()));
              break;
            case 2:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
              break;
            case 3:
              Navigator.push(context, MaterialPageRoute(builder: (context) => const SubjectPage()));
              break;
            default:
              break;
          }
        },
      ),
      backgroundColor: AppColors.background,
    );
  }
}
